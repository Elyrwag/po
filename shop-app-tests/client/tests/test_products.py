from selenium.webdriver.common.by import By
from base_test import BaseTest
import random

# 6 test cases
# 41 asserts

class TestProducts(BaseTest):
    def before_each(self):
        self.driver.get("http://localhost:3000/")

    def test_load_product_list(self):
        self.before_each()

        h1 = self.driver.find_element(By.TAG_NAME, "h1")
        assert "Produkty" in h1.text

        li_items = self.driver.find_elements(By.TAG_NAME, "li")
        assert len(li_items) == 3

        h2 = self.driver.find_elements(By.TAG_NAME, "h2")
        assert len(h2) == 3
        assert any("Produkt 1" in name.text for name in h2)
        assert any("Produkt 2" in name.text for name in h2)
        assert any("Produkt 3" in name.text for name in h2)

        prices = [p for p in self.driver.find_elements(By.TAG_NAME, "p") if "Cena" in p.text]
        assert len(prices) == 3

        add_buttons = [btn for btn in self.driver.find_elements(By.TAG_NAME, "button") if "Dodaj do koszyka" in btn.text]
        assert len(add_buttons) == 3

    def test_add_product_to_cart(self):
        self.before_each()

        add_button = [btn for btn in self.driver.find_elements(By.TAG_NAME, "button") if "Dodaj do koszyka" in btn.text][0]
        add_button.click()

        self.driver.find_element(By.LINK_TEXT, "Koszyk").click()
        assert "/cart" in self.driver.current_url

        h1 = self.driver.find_elements(By.TAG_NAME, "h1")
        assert len(h1) == 1
        assert "Koszyk" in h1[0].text

        items = self.driver.find_elements(By.TAG_NAME, "li")
        assert len(items) == 1
        assert "Produkt 1" in items[0].text

        p_tags = self.driver.find_elements(By.TAG_NAME, "p")
        assert any("Cena: 10.00 PLN" in p.text for p in p_tags)
        assert any("Ilość: 1" in p.text for p in p_tags)
        assert any("Razem: 10 PLN" in p.text for p in p_tags)

        remove_buttons = [btn for btn in self.driver.find_elements(By.TAG_NAME, "button") if "Usuń" in btn.text]
        assert len(remove_buttons) == 1

    def test_add_same_product_twice(self):
        self.before_each()

        add_button = [btn for btn in self.driver.find_elements(By.TAG_NAME, "button") if "Dodaj do koszyka" in btn.text][0]
        add_button.click()
        add_button.click()

        self.driver.find_element(By.LINK_TEXT, "Koszyk").click()
        assert "/cart" in self.driver.current_url

        h1 = self.driver.find_elements(By.TAG_NAME, "h1")
        assert len(h1) == 1
        assert "Koszyk" in h1[0].text

        p_tags = self.driver.find_elements(By.TAG_NAME, "p")
        assert any("Cena: 10.00 PLN" in p.text for p in p_tags)
        assert any("Ilość: 2" in p.text for p in p_tags)
        assert any("Razem: 20 PLN" in p.text for p in p_tags)

        remove_buttons = [btn for btn in self.driver.find_elements(By.TAG_NAME, "button") if "Usuń" in btn.text]
        assert len(remove_buttons) == 1

    def test_add_different_products(self):
        self.before_each()

        add_buttons = [btn for btn in self.driver.find_elements(By.TAG_NAME, "button") if "Dodaj do koszyka" in btn.text]
        add_buttons[0].click()
        add_buttons[1].click()
        add_buttons[1].click()

        self.driver.find_element(By.LINK_TEXT, "Koszyk").click()
        assert "/cart" in self.driver.current_url

        h1 = self.driver.find_elements(By.TAG_NAME, "h1")
        assert len(h1) == 1
        assert "Koszyk" in h1[0].text

        items = self.driver.find_elements(By.TAG_NAME, "li")
        assert len(items) == 2
        assert "Produkt 1" in items[0].text
        assert "Produkt 2" in items[1].text

        p_tags = self.driver.find_elements(By.TAG_NAME, "p")
        assert any("Cena: 10.00 PLN" in p.text for p in p_tags)
        assert any("Ilość: 1" in p.text for p in p_tags)
        assert any("Razem: 10 PLN" in p.text for p in p_tags)
        assert any("Cena: 20.00 PLN" in p.text for p in p_tags)
        assert any("Ilość: 2" in p.text for p in p_tags)
        assert any("Razem: 40 PLN" in p.text for p in p_tags)

        remove_buttons = [btn for btn in self.driver.find_elements(By.TAG_NAME, "button") if "Usuń" in btn.text]
        assert len(remove_buttons) == 2

        submit_cart_button = [btn for btn in self.driver.find_elements(By.TAG_NAME, "button") if "Zatwierdź koszyk" in btn.text]
        assert len(submit_cart_button) == 1

        clear_cart_button = [btn for btn in self.driver.find_elements(By.TAG_NAME, "button") if "Wyczyść koszyk" in btn.text]
        assert len(clear_cart_button) == 1

    def test_add_all_products(self):
        self.before_each()

        add_buttons = [btn for btn in self.driver.find_elements(By.TAG_NAME, "button") if "Dodaj do koszyka" in btn.text]
        n = len(add_buttons)

        for add_btn in add_buttons:
            add_btn.click()

        self.driver.find_element(By.LINK_TEXT, "Koszyk").click()

        p_tags = [p for p in self.driver.find_elements(By.TAG_NAME, "p") if "Ilość: 1" in p.text]
        assert len(p_tags) == n

    def test_add_same_product_random_number_times(self):
        self.before_each()

        add_button = [btn for btn in self.driver.find_elements(By.TAG_NAME, "button") if "Dodaj do koszyka" in btn.text][0]
        n = random.randint(1, 15)

        for _ in range(n):
            add_button.click()

        self.driver.find_element(By.LINK_TEXT, "Koszyk").click()

        p_tags = self.driver.find_elements(By.TAG_NAME, "p")
        assert any(f"Razem: {n*10} PLN" in p.text for p in p_tags)