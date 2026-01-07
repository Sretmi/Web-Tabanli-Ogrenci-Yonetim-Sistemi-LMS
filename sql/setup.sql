-- =====================================================
-- ÖĞRENCİ LMS VERİTABANI (TESLİME HAZIR)
-- =====================================================

DROP DATABASE IF EXISTS ogrenci_lms;
CREATE DATABASE ogrenci_lms;
USE ogrenci_lms;

-- =====================================================
-- 1. TABLOLAR
-- =====================================================

CREATE TABLE Fakulteler (
    FakulteID INT PRIMARY KEY AUTO_INCREMENT,
    FakulteAdi VARCHAR(100) NOT NULL
);

CREATE TABLE Bolumler (
    BolumID INT PRIMARY KEY AUTO_INCREMENT,
    BolumAdi VARCHAR(100) NOT NULL,
    FakulteID INT NOT NULL,
    CONSTRAINT fk_bolum_fakulte
        FOREIGN KEY (FakulteID) REFERENCES Fakulteler(FakulteID)
);

CREATE TABLE Roller (
    RolID INT PRIMARY KEY AUTO_INCREMENT,
    RolAdi VARCHAR(20) NOT NULL
);

CREATE TABLE Kullanicilar (
    KullaniciID INT PRIMARY KEY AUTO_INCREMENT,
    Email VARCHAR(100) UNIQUE NOT NULL,
    Sifre VARCHAR(255) NOT NULL,
    RolID INT NOT NULL,
    CONSTRAINT fk_kullanici_rol
        FOREIGN KEY (RolID) REFERENCES Roller(RolID)
);

CREATE TABLE KullaniciDetay (
    KullaniciID INT PRIMARY KEY,
    Ad VARCHAR(50) NOT NULL,
    Soyad VARCHAR(50) NOT NULL,
    No_SicilNo VARCHAR(20),
    BolumID INT NOT NULL,
    CONSTRAINT fk_kullanici_detay_kullanici
        FOREIGN KEY (KullaniciID) REFERENCES Kullanicilar(KullaniciID),
    CONSTRAINT fk_kullanici_detay_bolum
        FOREIGN KEY (BolumID) REFERENCES Bolumler(BolumID)
);

CREATE TABLE Donemler (
    DonemID INT PRIMARY KEY AUTO_INCREMENT,
    Yil VARCHAR(4) NOT NULL,
    DonemAdi VARCHAR(10) NOT NULL
);

CREATE TABLE Dersler (
    DersID INT PRIMARY KEY AUTO_INCREMENT,
    DersKodu VARCHAR(20) NOT NULL,
    DersAdi VARCHAR(100) NOT NULL,
    BolumID INT NOT NULL,
    OgretmenID INT NOT NULL,
    DonemID INT NOT NULL,
    CONSTRAINT fk_ders_bolum
        FOREIGN KEY (BolumID) REFERENCES Bolumler(BolumID),
    CONSTRAINT fk_ders_ogretmen
        FOREIGN KEY (OgretmenID) REFERENCES Kullanicilar(KullaniciID),
    CONSTRAINT fk_ders_donem
        FOREIGN KEY (DonemID) REFERENCES Donemler(DonemID)
);

CREATE TABLE DersKayitlari (
    KayitID INT PRIMARY KEY AUTO_INCREMENT,
    OgrenciID INT NOT NULL,
    DersID INT NOT NULL,
    KayitTarihi DATETIME DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT fk_kayit_ogrenci
        FOREIGN KEY (OgrenciID) REFERENCES Kullanicilar(KullaniciID),
    CONSTRAINT fk_kayit_ders
        FOREIGN KEY (DersID) REFERENCES Dersler(DersID),
    CONSTRAINT uq_ogrenci_ders UNIQUE (OgrenciID, DersID)
);

CREATE TABLE Duyurular (
    DuyuruID INT PRIMARY KEY AUTO_INCREMENT,
    DersID INT NOT NULL,
    YapanKullaniciID INT NOT NULL,
    Baslik VARCHAR(200),
    Icerik TEXT,
    Tarih DATETIME DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT fk_duyuru_ders
        FOREIGN KEY (DersID) REFERENCES Dersler(DersID),
    CONSTRAINT fk_duyuru_yapan
        FOREIGN KEY (YapanKullaniciID) REFERENCES Kullanicilar(KullaniciID)
);

CREATE TABLE Odevler (
    OdevID INT PRIMARY KEY AUTO_INCREMENT,
    DersID INT NOT NULL,
    Baslik VARCHAR(200),
    Aciklama TEXT,
    SonTeslimTarihi DATETIME,
    CONSTRAINT fk_odev_ders
        FOREIGN KEY (DersID) REFERENCES Dersler(DersID)
);

CREATE TABLE Teslimler (
    TeslimID INT PRIMARY KEY AUTO_INCREMENT,
    OdevID INT NOT NULL,
    OgrenciID INT NOT NULL,
    TeslimTarihi DATETIME DEFAULT CURRENT_TIMESTAMP,
    DosyaYolu VARCHAR(255),
    Puan INT DEFAULT NULL,
    CONSTRAINT fk_teslim_odev
        FOREIGN KEY (OdevID) REFERENCES Odevler(OdevID),
    CONSTRAINT fk_teslim_ogrenci
        FOREIGN KEY (OgrenciID) REFERENCES Kullanicilar(KullaniciID),
    CONSTRAINT uq_odev_ogrenci UNIQUE (OdevID, OgrenciID)
);

-- 1. Ders Materyalleri Tablosu
CREATE TABLE IF NOT EXISTS DersMateryalleri (
    MateryalID INT PRIMARY KEY AUTO_INCREMENT,
    DersID INT NOT NULL,
    Baslik VARCHAR(255) NOT NULL,
    DosyaYolu VARCHAR(255) NOT NULL,
    YuklemeTarihi DATETIME DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT fk_materyal_ders FOREIGN KEY (DersID) REFERENCES Dersler(DersID)
);

-- =====================================================
-- 2. ÖRNEK VERİLER
-- =====================================================

INSERT INTO Roller (RolAdi) VALUES ('Admin'), ('Instructor'), ('Student');
INSERT INTO Fakulteler (FakulteAdi) VALUES ('Mühendislik');
INSERT INTO Bolumler (BolumAdi, FakulteID) VALUES ('Bilgisayar Müh.', 1);
INSERT INTO Donemler (Yil, DonemAdi) VALUES ('2026', 'Güz');

INSERT INTO Kullanicilar (Email, Sifre, RolID) VALUES
('admin@test.com', '1234', 1),
('hoca@test.com', '1234', 2),
('test@test.com', '1234', 3),
('ayse@test.com', '1234', 3),
('mehmet@test.com', '1234', 3),
('zeynep@test.com', '1234', 3),
('can@test.com', '1234', 3);

INSERT INTO KullaniciDetay VALUES
(1, 'Sistem', 'Yöneticisi', 'ADM001', 1),
(2, 'Ahmet', 'Yılmaz', 'HOCA001', 1),
(3, 'Devran', 'Öğrenci', '2026100', 1),
(4, 'Ayşe', 'Demir', '2026101', 1),
(5, 'Mehmet', 'Kaya', '2026102', 1),
(6, 'Zeynep', 'Çelik', '2026103', 1),
(7, 'Can', 'Yıldız', '2026104', 1);

INSERT INTO Dersler VALUES
(1, 'YZL101', 'Veritabanı Yönetimi', 1, 2, 1),
(2, 'WEB101', 'Web Programlama', 1, 2, 1);

INSERT INTO DersKayitlari (OgrenciID, DersID) VALUES
(3,1),(4,2),(5,1),(5,2),(6,2),(7,1);

INSERT INTO Odevler VALUES
(1,1,'SQL Projesi','Final projesi','2026-06-01'),
(2,2,'React Hesap Makinesi','React state projesi','2026-06-15');

INSERT INTO Teslimler (OdevID,OgrenciID,Puan,DosyaYolu) VALUES
(1,3,90,'proje.zip'),
(2,4,85,'ayse_react.zip'),
(2,5,100,'mehmet_proje_final.rar'),
(1,7,40,'can_sql_odev.sql');

-- =====================================================
