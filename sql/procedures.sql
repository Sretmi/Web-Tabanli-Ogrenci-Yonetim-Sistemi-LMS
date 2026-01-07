DELIMITER //

-- 1. KİMLİK DOĞRULAMA (LOGIN) --
DROP PROCEDURE IF EXISTS sp_LoginKontrol //
CREATE PROCEDURE sp_LoginKontrol(IN p_email VARCHAR(100), IN p_sifre VARCHAR(255))
BEGIN
    SELECT 
        k.KullaniciID,
        k.Email,
        r.RolAdi,
        kd.Ad,
        kd.Soyad,
        kd.BolumID
    FROM Kullanicilar k
    JOIN KullaniciDetay kd ON k.KullaniciID = kd.KullaniciID
    JOIN Roller r ON k.RolID = r.RolID
    WHERE k.Email = p_email AND k.Sifre = p_sifre;
END //

-- 2. AKADEMİK LİSTELEME --
DROP PROCEDURE IF EXISTS sp_BolumDersleriniGetir //
CREATE PROCEDURE sp_BolumDersleriniGetir(IN p_bolum_id INT)
BEGIN
    SELECT d.DersKodu, d.DersAdi, kd.Ad, kd.Soyad, don.DonemAdi, don.Yil
    FROM Dersler d
    JOIN KullaniciDetay kd ON d.OgretmenID = kd.KullaniciID
    JOIN Donemler don ON d.DonemID = don.DonemID
    JOIN Bolumler b ON d.BolumID = b.BolumID
    WHERE d.BolumID = p_bolum_id;
END //

-- 3. ÖĞRENCİ DERS PROGRAMI --
DROP PROCEDURE IF EXISTS sp_OgrenciDersProgrami //
CREATE PROCEDURE sp_OgrenciDersProgrami(IN p_ogrenci_id INT)
BEGIN
    SELECT d.DersKodu, d.DersAdi, kd.Ad AS HocaAd, kd.Soyad AS HocaSoyad
    FROM DersKayitlari dk
    JOIN Dersler d ON dk.DersID = d.DersID
    JOIN KullaniciDetay kd ON d.OgretmenID = kd.KullaniciID
    WHERE dk.OgrenciID = p_ogrenci_id;
END //

-- 4. ÖDEV VE NOT DÖKÜMÜ --
DROP PROCEDURE IF EXISTS sp_OgrenciNotDokumu //
CREATE PROCEDURE sp_OgrenciNotDokumu(IN p_ogrenci_id INT)
BEGIN
    SELECT d.DersAdi, o.Baslik AS OdevBasligi, t.Puan, t.TeslimTarihi, kd.Ad AS Hoca
    FROM Teslimler t
    JOIN Odevler o ON t.OdevID = o.OdevID
    JOIN Dersler d ON o.DersID = d.DersID
    JOIN KullaniciDetay kd ON d.OgretmenID = kd.KullaniciID
    WHERE t.OgrenciID = p_ogrenci_id;
END //

-- 5. HOCA DERS İSTATİSTİK --
DROP PROCEDURE IF EXISTS sp_HocaDersIstatistik //
CREATE PROCEDURE sp_HocaDersIstatistik(IN p_hoca_id INT)
BEGIN
    SELECT d.DersAdi, COUNT(dk.OgrenciID) AS ToplamOgrenci
    FROM Dersler d
    LEFT JOIN DersKayitlari dk ON d.DersID = dk.DersID
    WHERE d.OgretmenID = p_hoca_id
    GROUP BY d.DersID;
END //

-- 5B. HOCA DERSLERİ LİSTELEME (GÜNCELLENMİŞ HALİ) --
DROP PROCEDURE IF EXISTS sp_HocaDersleri //
CREATE PROCEDURE sp_HocaDersleri(IN p_hoca_id INT)
BEGIN
    SELECT 
        d.DersID, d.DersKodu, d.DersAdi, b.BolumAdi, dn.Yil, dn.DonemAdi,
        -- Frontend uyumluluğu için küçük harfli versiyonlar
        d.DersID AS ders_id, d.DersKodu AS ders_kodu, d.DersAdi AS ders_adi,
        b.BolumAdi AS bolum_adi, dn.Yil AS yil, dn.DonemAdi AS donem_adi
    FROM Dersler d
    LEFT JOIN Bolumler b ON d.BolumID = b.BolumID
    LEFT JOIN Donemler dn ON d.DonemID = dn.DonemID
    WHERE d.OgretmenID = p_hoca_id;
END //

-- 6. DUYURU SİSTEMİ --
DROP PROCEDURE IF EXISTS sp_OgrenciDuyuruListesi //
CREATE PROCEDURE sp_OgrenciDuyuruListesi(IN p_ogrenci_id INT)
BEGIN
    SELECT duy.Baslik, duy.Icerik, d.DersAdi, kd.Ad AS YapanAd, duy.Tarih
    FROM Duyurular duy
    JOIN Dersler d ON duy.DersID = d.DersID
    JOIN DersKayitlari dk ON d.DersID = dk.DersID
    JOIN KullaniciDetay kd ON duy.YapanKullaniciID = kd.KullaniciID
    WHERE dk.OgrenciID = p_ogrenci_id
    ORDER BY duy.Tarih DESC;
END //

-- 7. ADMİN RAPORU --
DROP PROCEDURE IF EXISTS sp_GenelOgrenciRaporu //
CREATE PROCEDURE sp_GenelOgrenciRaporu()
BEGIN
    SELECT k.KullaniciID, kd.Ad, kd.Soyad, kd.No_SicilNo, b.BolumAdi, f.FakulteAdi, f.FakulteAdi
    FROM KullaniciDetay kd
    JOIN Kullanicilar k ON kd.KullaniciID = k.KullaniciID
    JOIN Roller r ON k.RolID = r.RolID
    JOIN Bolumler b ON kd.BolumID = b.BolumID
    JOIN Fakulteler f ON b.FakulteID = f.FakulteID
    ORDER BY k.KullaniciID DESC;
END //

-- 8. ÖDEV TESLİMLERİ (Genel Rapor İçin) --
DROP PROCEDURE IF EXISTS sp_DersOdevTeslimleri //
CREATE PROCEDURE sp_DersOdevTeslimleri(IN p_ders_id INT)
BEGIN
    SELECT t.TeslimID, o.Baslik, kd.Ad, kd.Soyad, t.TeslimTarihi, t.Puan, t.DosyaYolu
    FROM Teslimler t
    JOIN Odevler o ON t.OdevID = o.OdevID
    JOIN KullaniciDetay kd ON t.OgrenciID = kd.KullaniciID
    WHERE o.DersID = p_ders_id;
END //

-- 9. ÖĞRENCİNİN ALDIĞI DERSLER --
DROP PROCEDURE IF EXISTS sp_OgrenciDersleri //
CREATE PROCEDURE sp_OgrenciDersleri(IN p_OgrenciID INT)
BEGIN
    SELECT 
        d.DersID,
        d.DersKodu,
        d.DersAdi,
        CONCAT(hoca.Ad, ' ', hoca.Soyad) AS HocaAdi,
        donem.Yil,
        donem.DonemAdi
    FROM DersKayitlari dk
    JOIN Dersler d ON dk.DersID = d.DersID
    JOIN KullaniciDetay hoca ON d.OgretmenID = hoca.KullaniciID
    JOIN Donemler donem ON d.DonemID = donem.DonemID
    WHERE dk.OgrenciID = p_OgrenciID;
END //

-- 10. ÖDEV LİSTELEME --
DROP PROCEDURE IF EXISTS sp_DersOdevListesi //
CREATE PROCEDURE sp_DersOdevListesi(IN p_ders_id INT, IN p_ogrenci_id INT)
BEGIN
    SELECT 
        o.OdevID, 
        o.Baslik, 
        o.Aciklama, 
        o.SonTeslimTarihi,
        t.TeslimTarihi,
        t.Puan,
        t.DosyaYolu
    FROM Odevler o
    LEFT JOIN Teslimler t ON o.OdevID = t.OdevID AND t.OgrenciID = p_ogrenci_id
    WHERE o.DersID = p_ders_id;
END //

-- 11. ÖDEV TESLİM ET / GÜNCELLE --
DROP PROCEDURE IF EXISTS sp_OdevTeslimEt //
CREATE PROCEDURE sp_OdevTeslimEt(IN p_odev_id INT, IN p_ogrenci_id INT, IN p_dosya_yolu VARCHAR(255))
BEGIN
    IF EXISTS (SELECT * FROM Teslimler WHERE OdevID = p_odev_id AND OgrenciID = p_ogrenci_id) THEN
        UPDATE Teslimler SET DosyaYolu = p_dosya_yolu, TeslimTarihi = NOW() 
        WHERE OdevID = p_odev_id AND OgrenciID = p_ogrenci_id;
    ELSE
        INSERT INTO Teslimler (OdevID, OgrenciID, DosyaYolu) VALUES (p_odev_id, p_ogrenci_id, p_dosya_yolu);
    END IF;
END //

-- 12. ÖDEV EKLEME (HOCA) YENİ --
DROP PROCEDURE IF EXISTS sp_OdevEkle //
CREATE PROCEDURE sp_OdevEkle(IN p_ders_id INT, IN p_baslik VARCHAR(255), IN p_aciklama TEXT, IN p_son_teslim DATETIME)
BEGIN
    INSERT INTO Odevler(DersID, Baslik, Aciklama, SonTeslimTarihi) 
    VALUES (p_ders_id, p_baslik, p_aciklama, p_son_teslim);
END //

-- 13. DERS MATERYAL EKLEME (HOCA) YENİ --
DROP PROCEDURE IF EXISTS sp_DersMateryalEkle //
CREATE PROCEDURE sp_DersMateryalEkle(IN p_ders_id INT, IN p_baslik VARCHAR(255), IN p_dosya_yolu VARCHAR(255))
BEGIN
    INSERT INTO DersMateryalleri(DersID, Baslik, DosyaYolu) 
    VALUES (p_ders_id, p_baslik, p_dosya_yolu);
END //

-- 14. ADMİN İŞLEMLERİ (YENİ EKLENEN KISIMLAR) --

-- 14A. YENİ KULLANICI EKLEME (Backend sp_KullaniciEkle çağırıyor)
DROP PROCEDURE IF EXISTS sp_KullaniciEkle //
CREATE PROCEDURE sp_KullaniciEkle(
    IN p_email VARCHAR(100), 
    IN p_sifre VARCHAR(255), 
    IN p_rol INT, 
    IN p_ad VARCHAR(50), 
    IN p_soyad VARCHAR(50), 
    IN p_no VARCHAR(20), 
    IN p_bolum INT
)
BEGIN
    DECLARE yeni_id INT;
    -- Önce Kullanicilar tablosuna ekle
    INSERT INTO Kullanicilar (Email, Sifre, RolID) VALUES (p_email, p_sifre, p_rol);
    SET yeni_id = LAST_INSERT_ID();
    -- Sonra Detay tablosuna ekle
    INSERT INTO KullaniciDetay (KullaniciID, Ad, Soyad, No_SicilNo, BolumID) 
    VALUES (yeni_id, p_ad, p_soyad, p_no, p_bolum);
END //

-- 14B. YENİ DERS EKLEME (Backend sp_YeniDersEkle çağırıyor)
DROP PROCEDURE IF EXISTS sp_YeniDersEkle //
CREATE PROCEDURE sp_YeniDersEkle(
    IN p_kod VARCHAR(20), 
    IN p_ad VARCHAR(100), 
    IN p_bolum INT, 
    IN p_hoca INT, 
    IN p_donem INT
)
BEGIN
    INSERT INTO Dersler (DersKodu, DersAdi, BolumID, OgretmenID, DonemID) 
    VALUES (p_kod, p_ad, p_bolum, p_hoca, p_donem);
END //

-- 15. DİĞER YARDIMCI SORGULAR --

DROP PROCEDURE IF EXISTS sp_DersEkle //
CREATE PROCEDURE sp_DersEkle(IN p_kod VARCHAR(20), IN p_ad VARCHAR(100), IN p_bolum INT, IN p_hoca INT, IN p_donem INT)
BEGIN
    INSERT INTO Dersler(DersKodu, DersAdi, BolumID, OgretmenID, DonemID) 
    VALUES (p_kod, p_ad, p_bolum, p_hoca, p_donem);
END //

DROP PROCEDURE IF EXISTS sp_NotVer //
CREATE PROCEDURE sp_NotVer(IN p_teslim_id INT, IN p_puan INT)
BEGIN
    UPDATE Teslimler SET Puan = p_puan WHERE TeslimID = p_teslim_id;
END //

DROP PROCEDURE IF EXISTS sp_DuyuruEkle //
CREATE PROCEDURE sp_DuyuruEkle(IN p_ders INT, IN p_user INT, IN p_baslik VARCHAR(200), IN p_icerik TEXT)
BEGIN
    INSERT INTO Duyurular(DersID, YapanKullaniciID, Baslik, Icerik) 
    VALUES (p_ders, p_user, p_baslik, p_icerik);
END //

DROP PROCEDURE IF EXISTS sp_KullaniciSil //
CREATE PROCEDURE sp_KullaniciSil(IN p_id INT)
BEGIN
    DELETE FROM Kullanicilar WHERE KullaniciID = p_id;
END //

DROP PROCEDURE IF EXISTS sp_FakulteleriGetir //
CREATE PROCEDURE sp_FakulteleriGetir()
BEGIN
    SELECT * FROM Fakulteler;
END //

DROP PROCEDURE IF EXISTS sp_BolumleriGetir //
CREATE PROCEDURE sp_BolumleriGetir(IN p_fakulte_id INT)
BEGIN
    SELECT * FROM Bolumler WHERE FakulteID = p_fakulte_id;
END //

-- 2. Ders Materyallerini Listeleme Prosedürü
DROP PROCEDURE IF EXISTS sp_DersMateryalleriGetir //
CREATE PROCEDURE sp_DersMateryalleriGetir(IN p_ders_id INT)
BEGIN
    SELECT * FROM DersMateryalleri WHERE DersID = p_ders_id ORDER BY YuklemeTarihi DESC;
END //

DELIMITER ;