import React, {createContext, useState, useContext, useEffect} from 'react';

const ShopContext = createContext();

export const useShop = () => useContext(ShopContext); // custom hook useShop

export const ShopProvider = ({ children }) => {
    const [cart, setCart] = useState([]);

    const addToCart = (product) => {
        setCart(prev => {
            const existing = prev.find(item => item.product.id === product.id);
            if (existing) {
                return prev.map(item => item.product.id === product.id
                        ? { ...item, quantity: item.quantity + 1 }
                        : item
                );
            } else {
                return [...prev, { product, quantity: 1 }];
            }
        });
    };

    const removeFromCart = (productId) => {
        setCart(prev => {
            return prev
                .map(item => item.product.id === productId
                        ? { ...item, quantity: item.quantity - 1 }
                        : item
                )
                .filter(item => item.quantity > 0);
        });
    };

    const clearCart = () => {
        setCart([]);
    };

    return (
        <ShopContext.Provider value={{ cart, addToCart, removeFromCart, clearCart }}>
            {children}
        </ShopContext.Provider>
    );

};
