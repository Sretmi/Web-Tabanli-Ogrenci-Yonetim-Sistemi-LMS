import axios from 'axios';

const API_URL = 'http://127.0.0.1:8000';

// ============================
// 🔐 1) LOGIN (GİRİŞ)
// ============================
export const loginUser = (email, password) => {
    return axios.post(`${API_URL}/auth/login`, { email, password });
};

// ============================
// 🎓 2) ÖĞRENCİ FONKSİYONLARI
// ============================
export const getStudentCourses = (studentId) =>
    axios.get(`${API_URL}/student/courses/${studentId}`);

export const getCourseAssignments = (courseId, studentId) =>
    axios.get(`${API_URL}/student/assignments/${courseId}?student_id=${studentId}`);

export const uploadHomework = (formData) =>
    axios.post(`${API_URL}/student/upload-homework`, formData, {
        headers: { 'Content-Type': 'multipart/form-data' }
    });

export const getStudentGrades = (studentId) =>
    axios.get(`${API_URL}/student/grades/${studentId}`);

export const getAnnouncements = (studentId) =>
    axios.get(`${API_URL}/student/announcements/${studentId}`);

// ============================
// 👨‍🏫 3) HOCA FONKSİYONLARI
// ============================

// Hoca dersleri
export const getTeacherCourses = (teacherId) =>
    axios.get(`${API_URL}/instructor/courses/${teacherId}`);

// Materyalleri getir
export const getCourseMaterials = (courseId) =>
    axios.get(`${API_URL}/instructor/materials/${courseId}`);

// Materyal yükle
export const uploadMaterial = (formData) =>
    axios.post(`${API_URL}/instructor/upload-material`, formData, {
        headers: { 'Content-Type': 'multipart/form-data' }
    });

// Yeni Ödev Oluştur (Backend query param beklediği için params kullanıyoruz)
export const createAssignment = (ders_id, baslik, aciklama, son_teslim) =>
    axios.post(`${API_URL}/instructor/add-assignment`, null, {
        params: { ders_id, baslik, aciklama, son_teslim }
    });

// Gelen ödevleri listele
export const getCourseSubmissions = (courseId) =>
    axios.get(`${API_URL}/instructor/submissions/${courseId}`);

// Not Ver
export const giveGrade = (submission_id, grade) =>
    axios.post(`${API_URL}/instructor/grade-submission`, null, {
        params: { submission_id, grade }
    });

// Duyuru ekleme (Backend JSON beklediği için body olarak gönderiyoruz)
export const createAnnouncement = (ders_id, hoca_id, baslik, icerik) =>
    axios.post(`${API_URL}/instructor/announcement`, {
        ders_id,
        hoca_id,
        baslik,
        icerik
    });

// ============================
// 🛠️ 4) ADMİN FONKSİYONLARI
// ============================

// Kullanıcı Ekle (JSON Body olarak gider - Pydantic Model için)
export const adminAddUser = (userData) =>
    axios.post(`${API_URL}/admin/add-user`, userData);

// Ders Ekle (JSON Body olarak gider - Pydantic Model için)
export const adminAddCourse = (courseData) =>
    axios.post(`${API_URL}/admin/add-course`, courseData);

// Kullanıcı Sil
export const deleteUser = (userId) => 
    axios.delete(`${API_URL}/admin/user/${userId}`);

// Genel Rapor (Kullanıcı Listesi)
export const getAllUsersReport = () =>
    axios.get(`${API_URL}/admin/report`);

// Fakülte ve Bölüm Listeleri (Dropdownlar için)
export const getFaculties = () => 
    axios.get(`${API_URL}/faculties`);

export const getDepartments = (facultyId) => 
    axios.get(`${API_URL}/departments/${facultyId}`);