import React, { useState } from 'react';
import Login from './Login';
import Dashboard from './Dashboard';

function App() {
    const [user, setUser] = useState(JSON.parse(localStorage.getItem('user')));

    if (!user) {
        return <Login setAuth={setUser} />;
    }

    return (
        <div>
            <nav className="navbar navbar-dark bg-dark p-2">
                <span className="navbar-brand">LMS Projesi</span>
                <button className="btn btn-outline-light" onClick={() => {
                    localStorage.removeItem('user');
                    setUser(null);
                }}>Çıkış</button>
            </nav>
            <Dashboard user={user} />
        </div>
    );
}

export default App;