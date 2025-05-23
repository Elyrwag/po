import pytest

if __name__ == "__main__":
    pytest.main([
        "tests/test_cart.py",
        "tests/test_products.py",
        "tests/test_payments.py",
        "tests/test_navigation.py"
    ])
