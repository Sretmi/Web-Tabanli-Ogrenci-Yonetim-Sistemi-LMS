import React from 'react';
import ReactDOM from 'react-dom/client';
import App from './App'; // App.js dosyasını çağırır
import 'bootstrap/dist/css/bootstrap.min.css'; // Bootstrap'i ekler

const root = ReactDOM.createRoot(document.getElementById('root'));
root.render(
  <React.StrictMode>
    <App />
  </React.StrictMode>
);