SET FOREIGN_KEY_CHECKS = 0;

DELETE FROM Teslimler;
ALTER TABLE Teslimler AUTO_INCREMENT = 1;

DELETE FROM Odevler;
ALTER TABLE Odevler AUTO_INCREMENT = 1;

DELETE FROM DersKayitlari;
ALTER TABLE DersKayitlari AUTO_INCREMENT = 1;

DELETE FROM Dersler;
ALTER TABLE Dersler AUTO_INCREMENT = 1;

DELETE FROM KullaniciDetay;

DELETE FROM Kullanicilar;
ALTER TABLE Kullanicilar AUTO_INCREMENT = 1;

DELETE FROM Bolumler;
ALTER TABLE Bolumler AUTO_INCREMENT = 1;

DELETE FROM Fakulteler;
ALTER TABLE Fakulteler AUTO_INCREMENT = 1;

DELETE FROM Roller;
ALTER TABLE Roller AUTO_INCREMENT = 1;

DELETE FROM Donemler;
ALTER TABLE Donemler AUTO_INCREMENT = 1;

INSERT INTO Fakulteler (FakulteID, FakulteAdi) VALUES
(1, 'Mühendislik Fakültesi'),
(2, 'Fen Edebiyat Fakültesi'),
(3, 'İktisadi ve İdari Bilimler Fakültesi');

INSERT INTO Bolumler (BolumID, BolumAdi, FakulteID) VALUES
(1, 'Bilgisayar Mühendisliği', 1),
(2, 'Elektrik-Elektronik Müh.', 1),
(3, 'Endüstri Mühendisliği', 1),
(4, 'Makine Mühendisliği', 1),
(5, 'İnşaat Mühendisliği', 1),
(6, 'Matematik', 2),
(7, 'Fizik', 2),
(8, 'Psikoloji', 2),
(9, 'İşletme', 3),
(10, 'Uluslararası İlişkiler', 3);

INSERT INTO Roller (RolID, RolAdi) VALUES
(1, 'Yonetici'),
(2, 'Hoca'),
(3, 'Ogrenci');

INSERT INTO Donemler (DonemID, Yil, DonemAdi) VALUES
(1, '2024', 'Güz'),
(2, '2025', 'Bahar');

INSERT INTO Kullanicilar (KullaniciID, Email, Sifre, RolID) VALUES
(1, 'admin@gmail.com', '12345', 1),
(2, 'ahmet.hoca@uni.edu.tr', '12345', 2),
(3, 'mehmet.hoca@uni.edu.tr', '12345', 2),
(4, 'ayse.hoca@uni.edu.tr', '12345', 2),
(5, 'fatma.hoca@uni.edu.tr', '12345', 2),
(6, 'mustafa.hoca@uni.edu.tr', '12345', 2),
(10, 'ogrenci1@gmail.com', '12345', 3),
(11, 'ogrenci2@gmail.com', '12345', 3),
(12, 'ogrenci3@gmail.com', '12345', 3),
(13, 'ogrenci4@gmail.com', '12345', 3),
(14, 'ogrenci5@gmail.com', '12345', 3),
(15, 'ogrenci6@gmail.com', '12345', 3),
(16, 'ogrenci7@gmail.com', '12345', 3),
(17, 'ogrenci8@gmail.com', '12345', 3),
(18, 'ogrenci9@gmail.com', '12345', 3),
(19, 'ogrenci10@gmail.com', '12345', 3);

INSERT INTO KullaniciDetay (KullaniciID, Ad, Soyad, No_SicilNo, BolumID) VALUES
(1, 'Süper', 'Admin', '001', 1),
(2, 'Ahmet', 'Yılmaz', 'H001', 1),
(3, 'Mehmet', 'Demir', 'H002', 2),
(4, 'Ayşe', 'Kaya', 'H003', 1),
(5, 'Fatma', 'Çelik', 'H004', 6),
(6, 'Mustafa', 'Can', 'H005', 9),
(10, 'Ali', 'Veli', '2023001', 1),
(11, 'Veli', 'Deli', '2023002', 1),
(12, 'Zeynep', 'Su', '2023003', 1),
(13, 'Cem', 'Yalçın', '2023004', 2),
(14, 'Deniz', 'Gezgin', '2023005', 2),
(15, 'Ece', 'Naz', '2023006', 6),
(16, 'Burak', 'Yıl', '2023007', 6),
(17, 'Selin', 'Ak', '2023008', 9),
(18, 'Kaan', 'Kurt', '2023009', 9),
(19, 'Gizem', 'Nur', '2023010', 1);

INSERT INTO Dersler (DersID, DersKodu, DersAdi, BolumID, OgretmenID, DonemID) VALUES
(1, 'BLM101', 'Algoritma ve Programlama', 1, 2, 1),
(2, 'BLM102', 'Veri Yapıları', 1, 4, 1),
(3, 'BLM201', 'Veritabanı Yönetimi', 1, 2, 1),
(4, 'EEM101', 'Devre Teorisi', 2, 3, 1),
(5, 'EEM102', 'Sinyaller ve Sistemler', 2, 3, 1),
(6, 'MAT101', 'Matematik I', 6, 5, 1),
(7, 'MAT102', 'Lineer Cebir', 6, 5, 1),
(8, 'ISL101', 'İşletmeye Giriş', 9, 6, 1),
(9, 'ISL102', 'Genel Muhasebe', 9, 6, 1),
(10, 'BLM301', 'Yapay Zeka', 1, 4, 1);

INSERT INTO DersKayitlari (OgrenciID, DersID, KayitTarihi) VALUES
(10, 1, NOW()), (10, 2, NOW()), (10, 3, NOW()),
(11, 1, NOW()), (11, 2, NOW()),
(12, 1, NOW()), (12, 10, NOW()),
(13, 4, NOW()), (13, 5, NOW()),
(14, 4, NOW()),
(15, 6, NOW()), (15, 7, NOW()),
(16, 6, NOW()),
(17, 8, NOW()), (17, 9, NOW()),
(18, 8, NOW()),
(19, 1, NOW()), (19, 3, NOW()), (19, 10, NOW());

INSERT INTO Odevler (OdevID, DersID, Baslik, Aciklama, SonTeslimTarihi) VALUES
(1, 1, 'Vize Projesi: Hesap Makinesi', 'Basit bir hesap makinesi yapınız.', '2025-12-31 23:59:00'),
(2, 1, 'Final Ödevi: Yılan Oyunu', 'Python ile yılan oyunu yapınız.', '2026-01-15 23:59:00'),
(3, 2, 'Linked List Uygulaması', 'Bağlı liste yapısını kodlayınız.', '2025-11-30 23:59:00'),
(4, 3, 'ER Diyagramı Çizimi', 'Hastane veritabanı tasarlayınız.', '2025-12-20 23:59:00'),
(5, 3, 'SQL Sorguları', 'Size verilen 10 sorguyu yazınız.', '2026-01-05 23:59:00'),
(6, 4, 'Kirchhoff Yasaları Raporu', 'Laboratuvar deney raporunu yükleyiniz.', '2025-12-10 23:59:00'),
(7, 6, 'Limit ve Türev Soruları', '10 adet soru çözümü.', '2025-12-05 23:59:00'),
(8, 8, 'SWOT Analizi', 'Bir şirketin analizini yapınız.', '2025-12-25 23:59:00'),
(9, 10, 'Görüntü İşleme Projesi', 'OpenCV ile yüz tanıma.', '2026-02-01 23:59:00'),
(10, 1, 'Algoritma Analizi', 'Big O notasyonu analizi.', '2025-12-15 23:59:00');

INSERT INTO Teslimler (OdevID, OgrenciID, Puan, DosyaYolu) VALUES
(1, 10, 85, 'odevler/ali_hesap.zip'),
(1, 11, 90, 'odevler/veli_hesap.zip'),
(1, 12, 70, 'odevler/zeynep_hesap.zip'),
(4, 10, 100, 'odevler/ali_er.pdf'),
(4, 19, 95, 'odevler/gizem_er.pdf'),
(5, 10, 60, 'odevler/ali_sql.txt'),
(6, 13, 80, 'odevler/cem_rapor.pdf'),
(8, 17, 88, 'odevler/selin_swot.docx'),
(9, 12, NULL, 'odevler/zeynep_ai.py'),
(2, 10, NULL, 'odevler/ali_yilan.py');

SET FOREIGN_KEY_CHECKS = 1;