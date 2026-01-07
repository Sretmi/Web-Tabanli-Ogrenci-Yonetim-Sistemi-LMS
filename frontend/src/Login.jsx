import React, { useState } from 'react';
import { loginUser } from './api';

function Login({ setAuth }) {
    const [email, setEmail] = useState('');
    const [password, setPassword] = useState('');

    const handleLogin = async () => {
        if (!email || !password) {
            alert("Lütfen email ve şifre giriniz.");
            return;
        }

        try {
            const response = await loginUser(email, password); 
            const userData = Array.isArray(response.data) ? response.data[0] : response.data;
            
            localStorage.setItem('user', JSON.stringify(userData));
            setAuth(userData);
        } catch (error) {
            console.error(error);
            alert("Giriş başarısız! Bilgilerinizi kontrol edin.");
        }
    };

    return (
        <div className="container mt-5">
            <div className="card p-4 mx-auto" style={{maxWidth: '400px'}}>
                <h3>Öğrenci Yönetim Sistemi</h3>
                
                <input 
                    type="email" 
                    className="form-control mb-3" 
                    placeholder="Email adresi" 
                    value={email}
                    onChange={(e) => setEmail(e.target.value)} 
                />

                <input 
                    type="password" 
                    className="form-control mb-3" 
                    placeholder="Şifre" 
                    value={password}
                    onChange={(e) => setPassword(e.target.value)} 
                />

                <button className="btn btn-primary w-100" onClick={handleLogin}>
                    Giriş Yap
                </button>
            </div>
        </div>
    );
}

export default Login;
