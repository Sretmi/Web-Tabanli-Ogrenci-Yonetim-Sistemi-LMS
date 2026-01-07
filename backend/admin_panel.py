from sqladmin import Admin, ModelView
from sqlalchemy import create_engine, Column, Integer, String, ForeignKey, DateTime, Text
from sqlalchemy.orm import sessionmaker, declarative_base, relationship

# ==========================================
# 🔧 AYARLAR
# ==========================================
DATABASE_URL = "mysql+mysqlconnector://root:mysql@localhost/ogrenci_lms"

try:
    engine = create_engine(DATABASE_URL)
    SessionLocal = sessionmaker(autocommit=False, autoflush=False, bind=engine)
    Base = declarative_base()
except Exception as e:
    print(f"Admin Paneli Bağlantı Hatası: {e}")

# ==========================================
# 📌 TABLO MODELLERİ
# ==========================================

class Fakulteler(Base):
    __tablename__ = 'Fakulteler'
    FakulteID = Column(Integer, primary_key=True)
    FakulteAdi = Column(String(100))

    def __str__(self):
        return self.FakulteAdi or "Fakülte"

class Bolumler(Base):
    __tablename__ = 'Bolumler'
    BolumID = Column(Integer, primary_key=True)
    BolumAdi = Column(String(100))
    FakulteID = Column(Integer, ForeignKey('Fakulteler.FakulteID'))

    fakulte = relationship("Fakulteler")

    def __str__(self):
        return self.BolumAdi or "Bölüm"

class Roller(Base):
    __tablename__ = 'Roller'
    RolID = Column(Integer, primary_key=True)
    RolAdi = Column(String(20))

    def __str__(self):
        return self.RolAdi or "Rol"

class Kullanicilar(Base):
    __tablename__ = 'Kullanicilar'
    KullaniciID = Column(Integer, primary_key=True)
    Email = Column(String(100))
    Sifre = Column(String(255))
    RolID = Column(Integer, ForeignKey('Roller.RolID'))

    rol = relationship("Roller")
    detay = relationship("KullaniciDetay", uselist=False, back_populates="kullanici")

    def __str__(self):
        return self.Email or "Kullanıcı"

class KullaniciDetay(Base):
    __tablename__ = 'KullaniciDetay'
    KullaniciID = Column(Integer, ForeignKey('Kullanicilar.KullaniciID'), primary_key=True)
    Ad = Column(String(50))
    Soyad = Column(String(50))
    No_SicilNo = Column(String(20))
    BolumID = Column(Integer, ForeignKey('Bolumler.BolumID'))

    kullanici = relationship("Kullanicilar", back_populates="detay")
    bolum = relationship("Bolumler")

    def __str__(self):
        return f"{self.Ad} {self.Soyad}"

class Donemler(Base):
    __tablename__ = 'Donemler'
    DonemID = Column(Integer, primary_key=True)
    Yil = Column(String(4))
    DonemAdi = Column(String(10))

    def __str__(self):
        return f"{self.Yil} {self.DonemAdi}"

class Dersler(Base):
    __tablename__ = 'Dersler'
    DersID = Column(Integer, primary_key=True)
    DersKodu = Column(String(20))
    DersAdi = Column(String(100))
    BolumID = Column(Integer, ForeignKey('Bolumler.BolumID'))
    OgretmenID = Column(Integer, ForeignKey('Kullanicilar.KullaniciID'))
    DonemID = Column(Integer, ForeignKey('Donemler.DonemID'))

    bolum = relationship("Bolumler")
    ogretmen = relationship("Kullanicilar")
    donem = relationship("Donemler")

    def __str__(self):
        return self.DersAdi or "Ders"

class Odevler(Base):
    __tablename__ = 'Odevler'
    OdevID = Column(Integer, primary_key=True)
    DersID = Column(Integer, ForeignKey('Dersler.DersID'))
    Baslik = Column(String(200))
    Aciklama = Column(Text)
    SonTeslimTarihi = Column(DateTime)

    ders = relationship("Dersler")

class Teslimler(Base):
    __tablename__ = 'Teslimler'
    TeslimID = Column(Integer, primary_key=True)
    OdevID = Column(Integer, ForeignKey('Odevler.OdevID'))
    OgrenciID = Column(Integer, ForeignKey('Kullanicilar.KullaniciID'))
    Puan = Column(Integer)
    DosyaYolu = Column(String(255))

    odev = relationship("Odevler")
    ogrenci = relationship("Kullanicilar")

class DersKayitlari(Base):
    __tablename__ = 'DersKayitlari'
    KayitID = Column(Integer, primary_key=True)
    OgrenciID = Column(Integer, ForeignKey('Kullanicilar.KullaniciID'))
    DersID = Column(Integer, ForeignKey('Dersler.DersID'))
    KayitTarihi = Column(DateTime)

    ogrenci = relationship("Kullanicilar")
    ders = relationship("Dersler")

# ==========================================
# 🛠️ PANEL GÖRÜNÜMLERİ
# ==========================================

class KullaniciAdmin(ModelView, model=Kullanicilar):
    name = "Kullanıcı"
    name_plural = "Kullanıcılar"
    column_list = [Kullanicilar.KullaniciID, Kullanicilar.Email, "rol.RolAdi", "detay.Ad", "detay.Soyad"]
    column_searchable_list = [Kullanicilar.Email]
    form_excluded_columns = ["detay"]   # ✅ DETAY KUTUSU KALKTI
    icon = "fa-solid fa-user"

class DetayAdmin(ModelView, model=KullaniciDetay):
    name = "Profil Detayı"
    name_plural = "Kullanıcı Profilleri"
    column_list = [KullaniciDetay.Ad, KullaniciDetay.Soyad, KullaniciDetay.No_SicilNo, "bolum.BolumAdi"]
    icon = "fa-solid fa-address-card"

class DersAdmin(ModelView, model=Dersler):
    name = "Ders"
    name_plural = "Dersler"
    column_list = [Dersler.DersKodu, Dersler.DersAdi, "ogretmen.Email", "donem.Yil"]
    icon = "fa-solid fa-book"

class OdevAdmin(ModelView, model=Odevler):
    name = "Ödev"
    name_plural = "Ödevler"
    column_list = [Odevler.Baslik, "ders.DersAdi", Odevler.SonTeslimTarihi]
    icon = "fa-solid fa-file-pen"

class TeslimAdmin(ModelView, model=Teslimler):
    name = "Teslim"
    name_plural = "Ödev Teslimleri"
    column_list = ["ogrenci.Email", "odev.Baslik", Teslimler.Puan]
    icon = "fa-solid fa-file-arrow-up"

class KayitAdmin(ModelView, model=DersKayitlari):
    name = "Ders Kaydı"
    name_plural = "Ders Kayıtları"
    column_list = ["ogrenci.Email", "ders.DersAdi"]
    icon = "fa-solid fa-clipboard-check"

class BolumAdmin(ModelView, model=Bolumler): column_list = [Bolumler.BolumID, Bolumler.BolumAdi]
class FakulteAdmin(ModelView, model=Fakulteler): pass
class DonemAdmin(ModelView, model=Donemler): pass
class RolAdmin(ModelView, model=Roller): pass

# ==========================================
# 🚀 BAŞLATICI
# ==========================================
def init_admin(app):
    admin = Admin(app, engine, title="Yönetim Paneli")

    admin.add_view(KullaniciAdmin)
    admin.add_view(DetayAdmin)
    admin.add_view(DersAdmin)
    admin.add_view(KayitAdmin)
    admin.add_view(OdevAdmin)
    admin.add_view(TeslimAdmin)
    admin.add_view(BolumAdmin)
    admin.add_view(FakulteAdmin)
    admin.add_view(DonemAdmin)
    admin.add_view(RolAdmin)
