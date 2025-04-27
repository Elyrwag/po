import React from 'react';
import { useShop } from "../context/ShopContext";
import axios from 'axios';

function Cart() {
    const { cart, removeFromCart, clearCart } = useShop();

    const submitCart = async () => {
        await axios.post('http://localhost:5000/api/submit-cart', {
            items: cart
        }).catch(err => console.error('Submit cart error: ', err));
    };

    return (
        <div>
            <h1>Koszyk</h1>
            {cart.length === 0 ? (
                <p>Koszyk jest pusty</p>
            ) : (
                <ul>
                    {cart.map(({product, quantity}) => (
                        <li key={product.id}>
                            <h2>{product.name}</h2>
                            <p>Cena: {product.price} PLN</p>
                            <p>Ilość: {quantity}</p>
                            <p>Razem: {product.price * quantity} PLN</p>
                            <button onClick={() => removeFromCart(product.id)}>Usuń</button>
                        </li>
                    ))}
                </ul>
            )}
            {cart.length > 0 && (
                <div>
                    <button onClick={submitCart}>Zatwierdź koszyk</button>
                    <button onClick={clearCart}>Wyczyść koszyk</button>
                </div>
            )}
        </div>
    );
}

export default Cart;
