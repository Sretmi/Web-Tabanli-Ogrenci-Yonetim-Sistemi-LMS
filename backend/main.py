from fastapi import FastAPI, HTTPException, File, UploadFile, Form
from fastapi.staticfiles import StaticFiles
from fastapi.middleware.cors import CORSMiddleware
from pydantic import BaseModel
import mysql.connector
import uvicorn
import shutil
import os

# 1. Veritabanı Bağlantısı (Normal API işlemleri için)
from db_config import get_connection

# 2. Yeni Admin Paneli Başlatıcısı (sqladmin)
# Eğer admin_panel.py dosyasını oluşturmadıysan hata verir!
from admin_panel import init_admin

app = FastAPI()

# =======================
# 💬 CORS AYARLARI
# =======================
app.add_middleware(
    CORSMiddleware,
    allow_origins=["*"],
    allow_methods=["*"],
    allow_headers=["*"],
)

# Klasör Kontrolü
os.makedirs("ders_materyalleri", exist_ok=True)
os.makedirs("yuklenen_odevler", exist_ok=True)

# Statik Dosyalar
app.mount("/ders_materyalleri", StaticFiles(directory="ders_materyalleri"), name="ders_materyalleri")
app.mount("/yuklenen_odevler", StaticFiles(directory="yuklenen_odevler"), name="yuklenen_odevler")

# =======================
# 📌 MODELLER
# =======================
class LoginSchema(BaseModel):
    email: str
    password: str

class AnnouncementSchema(BaseModel):
    ders_id: int
    hoca_id: int
    baslik: str
    icerik: str    

class UserAddSchema(BaseModel):
    email: str
    sifre: str
    rol_id: int
    ad: str
    soyad: str
    no: str
    bolum_id: int

class CourseAddSchema(BaseModel):
    kod: str
    ad: str
    bolum_id: int
    hoca_id: int
    donem_id: int

class UserUpdateSchema(BaseModel):
    kullanici_id: int
    email: str
    ad: str
    soyad: str
    no: str
    bolum_id: int
    rol_id: int

# =======================
# ⚙️ SQL PROSEDÜR ÇAĞIRICI (API için)
# =======================
def call_procedure(proc_name, args=()):
    conn = get_connection()
    if not conn:
        raise HTTPException(status_code=500, detail="Veritabanı bağlantısı kurulamadı!")

    cursor = conn.cursor(dictionary=True)
    try:
        cursor.callproc(proc_name, args)
        results = []
        for res in cursor.stored_results():
            results.extend(res.fetchall())
        conn.commit()
        return results
    except mysql.connector.Error as err:
        print(f"SQL Hatası ({proc_name}): {err}")
        raise HTTPException(status_code=400, detail=str(err))
    finally:
        if conn.is_connected():
            cursor.close()
            conn.close()

# =======================
# 🔐 AUTH & GENEL
# =======================
@app.post("/auth/login")
def login(data: LoginSchema):
    user = call_procedure('sp_LoginKontrol', [data.email, data.password])
    if not user:
        raise HTTPException(status_code=404, detail="Giriş başarısız! Bilgileri kontrol et.")
    return user[0]

# =======================
# 🎓 ÖĞRENCİ ENDPOINTLERİ
# =======================
@app.get("/student/grades/{student_id}")
def get_student_grades(student_id: int):
    return call_procedure('sp_OgrenciNotDokumu', [student_id])

@app.get("/student/schedule/{student_id}")
def get_student_schedule(student_id: int):
    return call_procedure('sp_OgrenciDersProgrami', [student_id])

@app.get("/student/announcements/{student_id}")
def get_announcements(student_id: int):
    return call_procedure('sp_OgrenciDuyuruListesi', [student_id])

@app.get("/student/courses/{student_id}")
def get_student_courses(student_id: int):
    return call_procedure('sp_OgrenciDersleri', [student_id])

@app.get("/student/assignments/{course_id}")
def get_course_assignments(course_id: int, student_id: int):
    return call_procedure('sp_DersOdevListesi', [course_id, student_id])

@app.post("/student/upload-homework")
def upload_homework(
    odev_id: int = Form(...),
    ogrenci_id: int = Form(...),
    file: UploadFile = File(...)
):
    try:
        dosya_adi = f"{ogrenci_id}_{odev_id}_{file.filename}"
        dosya_konumu = f"yuklenen_odevler/{dosya_adi}"
        with open(dosya_konumu, "wb") as buffer:
            shutil.copyfileobj(file.file, buffer)
        call_procedure('sp_OdevTeslimEt', [odev_id, ogrenci_id, dosya_adi])
        return {"message": "Ödev yüklendi", "dosya": dosya_adi}
    except Exception as e:
        raise HTTPException(status_code=500, detail=str(e))

# =======================
# 🧑‍🏫 HOCA ENDPOINTLERİ
# =======================
@app.get("/instructor/courses/{teacher_id}")
def get_teacher_courses(teacher_id: int):
    return call_procedure('sp_HocaDersleri', [teacher_id])

@app.get("/instructor/stats/{teacher_id}")
def get_teacher_stats(teacher_id: int):
    return call_procedure('sp_HocaDersIstatistik', [teacher_id])

@app.get("/instructor/submissions/{course_id}")
def get_course_submissions(course_id: int):
    return call_procedure('sp_DersOdevTeslimleri', [course_id])

@app.post("/instructor/grade-submission")
def grade_submission(submission_id: int, grade: int):
    call_procedure('sp_NotVer', [submission_id, grade])
    return {"message": "Not verildi"}

@app.post("/instructor/announcement")
def add_announcement(data: AnnouncementSchema):
    call_procedure('sp_DuyuruEkle', [data.ders_id, data.hoca_id, data.baslik, data.icerik])
    return {"message": "Duyuru yayınlandı"}

@app.post("/instructor/add-assignment")
def add_assignment(ders_id: int, baslik: str, aciklama: str, son_teslim: str):
    temiz_tarih = son_teslim.replace("T", " ")
    if len(temiz_tarih) == 16: temiz_tarih += ":00"
    call_procedure('sp_OdevEkle', [ders_id, baslik, aciklama, temiz_tarih])
    return {"message": "Ödev oluşturuldu"}

@app.get("/instructor/materials/{course_id}")
def get_course_materials(course_id: int):
    return call_procedure('sp_DersMateryalleriGetir', [course_id])

@app.post("/instructor/upload-material")
def upload_material(
    ders_id: int = Form(...),
    baslik: str = Form(...),
    file: UploadFile = File(...)
):
    try:
        dosya_adi = f"{ders_id}_{file.filename}"
        dosya_konumu = f"ders_materyalleri/{dosya_adi}"
        with open(dosya_konumu, "wb") as buffer:
            shutil.copyfileobj(file.file, buffer)
        call_procedure('sp_DersMateryalEkle', [ders_id, baslik, dosya_adi])
        return {"message": "Materyal yüklendi"}
    except Exception as e:
        raise HTTPException(status_code=500, detail=str(e))

# =======================
# 🛠️ ADMIN ENDPOINTLERİ (Eski API Desteği İçin)
# =======================
# Bu endpointler hala duruyor çünkü api.js üzerinden çağrılabilirler.
# Ancak asıl yönetim artık /admin panelinde.

@app.post("/admin/add-user")
def add_user(data: UserAddSchema):
    call_procedure('sp_KullaniciEkle', [
        data.email, data.sifre, data.rol_id, 
        data.ad, data.soyad, data.no, data.bolum_id
    ])
    return {"message": "Kullanıcı eklendi"}

@app.post("/admin/add-course")
def add_course(data: CourseAddSchema):
    call_procedure('sp_YeniDersEkle', [
        data.kod, data.ad, data.bolum_id, 
        data.hoca_id, data.donem_id
    ])
    return {"message": "Ders eklendi"}

@app.put("/admin/update-user")
def update_user(data: UserUpdateSchema):
    call_procedure('sp_KullaniciGuncelle', [
        data.kullanici_id, data.email, data.ad, 
        data.soyad, data.no, data.bolum_id, data.rol_id
    ])
    return {"message": "Kullanıcı güncellendi"}

@app.get("/admin/report")
def get_admin_report():
    return call_procedure('sp_GenelOgrenciRaporu')

@app.delete("/admin/user/{user_id}")
def delete_user(user_id: int):
    call_procedure('sp_KullaniciSil', [user_id])
    return {"message": "Kullanıcı silindi"}

# Dropdown Verileri
@app.get("/faculties")
def list_faculties(): return call_procedure('sp_FakulteleriGetir')

@app.get("/departments/{faculty_id}")
def list_departments(faculty_id: int): return call_procedure('sp_BolumleriGetir', [faculty_id])

# =======================
# 🚀 YENİ ADMIN PANELİ ENTEGRASYONU
# =======================
# En altta bunu çağırıyoruz. Bu, /admin rotasını otomatik oluşturur.
init_admin(app)

# =======================
# 🏁 SUNUCU BAŞLAT
# =======================
if __name__ == "__main__":
    print("🚀 Sunucu Başlatılıyor... Admin Paneli: http://127.0.0.1:8000/admin")
    uvicorn.run("main:app", host="127.0.0.1", port=8000, reload=True)