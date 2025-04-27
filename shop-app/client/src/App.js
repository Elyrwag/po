import React from 'react'
import './App.css'
import {Routes, Route, Link} from 'react-router-dom';
import Products from './components/Products.js';
import Cart from './components/Cart.js';
import Payments from './components/Payments.js';

const NavLinks = () => {
    return (
        <nav>
            <Link to="/">Produkty</Link><br/>
            <Link to="/cart">Koszyk</Link><br/>
            <Link to="/payments">Podsumowanie</Link>
        </nav>
    );
}

function App() {
    return (
        <div className="app">
            <NavLinks />

            <Routes>
                <Route path="/" element={<Products />} />
                <Route path="/cart" element={<Cart />} />
                <Route path="/payments" element={<Payments />} />
            </Routes>
        </div>
    );
}

export default App
