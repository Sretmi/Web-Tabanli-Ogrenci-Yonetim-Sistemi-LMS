# 🎓 Web Tabanlı Öğrenci Yönetim Sistemi (LMS)

Bu proje, üniversite süreçlerini (ders seçimi, notlandırma, ödev teslimi ve duyurular) dijitalleştiren kapsamlı bir **Veritabanı Yönetim Sistemi** uygulamasıdır. 

Modern web mimarisi kullanılarak geliştirilmiş olup, iş mantığının büyük bir kısmı veritabanı seviyesinde (**Stored Procedures, Triggers**) yönetilmiştir.

## 🚀 Özellikler

- **Rol Tabanlı Yetkilendirme (RBAC):** Yönetici, Akademisyen ve Öğrenci için özelleştirilmiş paneller.
- **Akademisyen Paneli:** Ders oluşturma, ödev verme, not girişi ve duyuru yayınlama.
- **Öğrenci Paneli:** Ders seçimi, ödev yükleme, not görüntüleme ve transkript takibi.
- **Gelişmiş Veritabanı Mimarisi:** - Tüm CRUD işlemleri **Saklı Yordamlar (Stored Procedures)** ile yapılmıştır.
  - Veri bütünlüğü **Tetikleyiciler (Triggers)** ile sağlanmıştır.
  - Karmaşık raporlamalar için **JOIN** yapıları kullanılmıştır.

## 🛠️ Kullanılan Teknolojiler

- **Backend:** Python (FastAPI)
- **Frontend:** React.js (Vite)
- **Veritabanı:** MySQL
- **Veri İletişimi:** REST API (Axios)

## ⚙️ Kurulum ve Çalıştırma

Projeyi yerel makinenizde çalıştırmak için adımları takip edin.

### 1. Veritabanı Kurulumu
- `ogrenci_lms` adında bir MySQL veritabanı oluşturun.
- Sırasıyla şu SQL dosyalarını içe aktarın (Import):
  1. `setup.sql` (Tablolar)
  2. `procedures.sql` (Prosedürler)
  3. `dummy_data.sql` (Örnek Veriler)

### 2. Backend (Sunucu)
# Gerekli kütüphaneleri yükleyin
pip install fastapi uvicorn mysql-connector-python python-multipart

# Sunucuyu başlatın
python main.py

### 3. Frontend (Arayüz)
cd src
# Paketleri yükleyin
npm install
# Uygulamayı başlatın
npm run dev

TEST giriş bilgileri
Yönetici	admin@gmail.com	12345
Akademisyen	ahmet.hoca@uni.edu.tr	12345
Öğrenci	ogrenci1@gmail.com	12345
