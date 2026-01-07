import mysql.connector
from mysql.connector import Error

def get_connection():
    try:
        connection = mysql.connector.connect(
            host='localhost',
            user='root',       # XAMPP varsayılan kullanıcı
            password='mysql',       # XAMPP varsayılan şifre BOŞTUR
            database='ogrenci_lms'
        )
        if connection.is_connected():
            return connection
    except Error as e:
        print(f"Bağlantı Hatası: {e}")
        return None

# --- TEST ETMEK İÇİN AŞAĞIDAKİ KISMI EKLEDİK ---
if __name__ == "__main__":
    print("Veritabanı bağlantısı test ediliyor...")
    baglanti = get_connection()

    if baglanti:
        print("TEBRİKLER: Veritabanına başarıyla bağlanıldı!")
        baglanti.close() # Test bittiği için kapattık
    else:
        print("HATA: Bağlantı kurulamadı. Lütfen XAMPP'ın açık olduğunu kontrol et.")