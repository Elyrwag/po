import React, {useState} from 'react';
import { useShop } from "../context/ShopContext";
import axios from 'axios';

function Payments() {
    const { cart, clearCart } = useShop();
    const [form, setForm] = useState({
        name: '',
        surname: '',
        email: '',
        cardNumber: ''
    });
    const [error, setError] = useState('');

    const handleChange = (e) => {
        const { name, value } = e.target;
        setForm(prev => ({ ...prev, [name]: value }));
    };

    const handlePayment = async () => {
        setError('');

        if (!/^\d{16}$/.test(form.cardNumber)) {
            setError('Numer karty musi mieć dokładnie 16 cyfr');
            return;
        }

        await axios.post('http://localhost:5000/api/complete-payment', {
            customer: form,
            cart: { items: cart },
            total: cart.reduce((total, item) => total + item.product.price * item.quantity, 0)
        })
            .then(() => {
                alert('Płatność zrealizowana!');
                clearCart();
            })
            .catch((err) => {
                console.error('Payment error:', err);
                setError('Wystąpił błąd podczas przetwarzania płatności.');
            });
    };

    return (
        <div>
            <h1>Podsumowanie</h1>
            {cart.length === 0 ? (
                <p>Koszyk jest pusty</p>
            ) : (
                <div>
                    <h2>Produkty w koszyku:</h2>
                    <ul>
                        {cart.map(({ product, quantity }) => (
                            <li key={product.id}>
                                {product.name} - {product.price} PLN x {quantity} = {product.price * quantity} PLN
                            </li>
                        ))}
                    </ul>
                    <p><strong>Do zapłaty:</strong> {
                        cart.reduce((total, item) => total + item.product.price * item.quantity, 0)
                    } PLN</p>

                    <form onSubmit={(e) => { e.preventDefault(); handlePayment(); }}>
                        <h2>Dane płatności:</h2>
                        <input type="text" name="name" placeholder="Imię" value={form.name} onChange={handleChange} required/>
                        <br/>
                        <input type="text" name="surname" placeholder="Nazwisko" value={form.surname} onChange={handleChange} required/>
                        <br/>
                        <input type="email" name="email" placeholder="Email" value={form.email} onChange={handleChange} required/>
                        <br/>
                        <input type="text" name="cardNumber" placeholder="Numer karty (16 cyfr)" value={form.cardNumber} onChange={handleChange} required/>
                        <br/>
                        {error &&
                            <p style={{ color: 'red' }}>{error}</p>
                        }
                        <button type="submit">Zakończ zakupy i zapłać</button>
                    </form>
                </div>
            )}
        </div>
    )
}

export default Payments;
