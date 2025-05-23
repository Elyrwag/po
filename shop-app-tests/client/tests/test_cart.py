from selenium.webdriver.common.by import By
from base_test import BaseTest
import random

# 9 test cases
# 46 asserts

class TestCart(BaseTest):
    def before_each(self):
        self.driver.get("http://localhost:3000/")
        add_button = [btn for btn in self.driver.find_elements(By.TAG_NAME, "button") if "Dodaj do koszyka" in btn.text][0]
        add_button.click()
        self.driver.find_element(By.LINK_TEXT, "Koszyk").click()

    def test_display_added_product(self):
        self.before_each()

        h1 = self.driver.find_elements(By.TAG_NAME, "h1")
        assert len(h1) == 1

        assert "Koszyk" in h1[0].text

        items = self.driver.find_elements(By.TAG_NAME, "li")
        assert len(items) == 1

        assert "Produkt 1" in items[0].text

        buttons = self.driver.find_elements(By.TAG_NAME, "button")
        assert any("Usuń" in btn.text for btn in buttons)
        assert any("Zatwierdź koszyk" in btn.text for btn in buttons)
        assert any("Wyczyść koszyk" in btn.text for btn in buttons)

        p_tags = self.driver.find_elements(By.TAG_NAME, "p")
        assert any("Cena: 10.00 PLN" in p.text for p in p_tags)
        assert any("Ilość: 1" in p.text for p in p_tags)
        assert any("Razem: 10 PLN" in p.text for p in p_tags)

    def test_remove_product_from_cart_with_one_product(self):
        self.before_each()

        remove_button = [btn for btn in self.driver.find_elements(By.TAG_NAME, "button") if "Usuń" in btn.text]
        remove_button[0].click()

        h1 = self.driver.find_elements(By.TAG_NAME, "h1")
        assert len(h1) == 1

        assert "Koszyk" in h1[0].text

        body = self.driver.find_element(By.TAG_NAME, "body")
        assert "Koszyk jest pusty" in body.text
        assert "/cart" in self.driver.current_url

    def test_remove_product_from_cart_with_two_different_products(self):
        self.driver.get("http://localhost:3000/")
        add_buttons = [btn for btn in self.driver.find_elements(By.TAG_NAME, "button") if "Dodaj do koszyka" in btn.text]
        add_buttons[0].click()
        add_buttons[1].click()
        add_buttons[1].click()
        self.driver.find_element(By.LINK_TEXT, "Koszyk").click()

        remove_button = [btn for btn in self.driver.find_elements(By.TAG_NAME, "button") if "Usuń" in btn.text]
        remove_button[0].click()

        h1 = self.driver.find_elements(By.TAG_NAME, "h1")
        assert len(h1) == 1

        assert "Koszyk" in h1[0].text

        items = self.driver.find_elements(By.TAG_NAME, "li")
        assert len(items) == 1

        assert "Produkt 1" not in items[0].text
        assert "Produkt 2" in items[0].text

        p_tags = self.driver.find_elements(By.TAG_NAME, "p")
        assert any("Cena: 20.00 PLN" in p.text for p in p_tags)
        assert any("Ilość: 2" in p.text for p in p_tags)
        assert any("Razem: 40 PLN" in p.text for p in p_tags)

    def test_submit_cart(self):
        self.before_each()

        submit_button = [btn for btn in self.driver.find_elements(By.TAG_NAME, "button") if "Zatwierdź koszyk" in btn.text][0]
        submit_button.click()
        assert "/cart" in self.driver.current_url

        h1 = self.driver.find_elements(By.TAG_NAME, "h1")
        assert len(h1) == 1

        assert "Koszyk" in h1[0].text

        items = self.driver.find_elements(By.TAG_NAME, "li")
        assert len(items) == 1

        assert "Produkt 1" in items[0].text

        buttons = self.driver.find_elements(By.TAG_NAME, "button")
        assert any("Usuń" in btn.text for btn in buttons)
        assert any("Zatwierdź koszyk" in btn.text for btn in buttons)
        assert any("Wyczyść koszyk" in btn.text for btn in buttons)

        p_tags = self.driver.find_elements(By.TAG_NAME, "p")
        assert any("Cena: 10.00 PLN" in p.text for p in p_tags)
        assert any("Ilość: 1" in p.text for p in p_tags)
        assert any("Razem: 10 PLN" in p.text for p in p_tags)

    def test_clear_cart_with_one_product_type(self):
        self.before_each()

        clear_button = [btn for btn in self.driver.find_elements(By.TAG_NAME, "button") if "Wyczyść koszyk" in btn.text][0]
        clear_button.click()

        body = self.driver.find_element(By.TAG_NAME, "body")
        assert "Koszyk jest pusty" in body.text

    def test_clear_cart_with_many_product_types(self):
        self.driver.get("http://localhost:3000/")
        buttons = self.driver.find_elements(By.TAG_NAME, "button")
        for btn in buttons:
            if "Dodaj do koszyka" in btn.text:
                btn.click()
        self.driver.find_element(By.LINK_TEXT, "Koszyk").click()

        clear_button = [btn for btn in self.driver.find_elements(By.TAG_NAME, "button") if "Wyczyść koszyk" in btn.text][0]
        clear_button.click()

        body = self.driver.find_element(By.TAG_NAME, "body")
        assert "Koszyk jest pusty" in body.text

    def test_clear_cart_with_many_product_types_and_many_quantities(self):
        self.driver.get("http://localhost:3000/")
        buttons = self.driver.find_elements(By.TAG_NAME, "button")
        for btn in buttons:
            if "Dodaj do koszyka" in btn.text:
                n = random.randint(0, 5)
                for _ in range(n):
                    btn.click()
        self.driver.find_element(By.LINK_TEXT, "Koszyk").click()

        clear_button = [btn for btn in self.driver.find_elements(By.TAG_NAME, "button") if "Wyczyść koszyk" in btn.text][0]
        clear_button.click()

        body = self.driver.find_element(By.TAG_NAME, "body")
        assert "Koszyk jest pusty" in body.text

    def test_add_multiple_products(self):
        self.driver.get("http://localhost:3000/")
        buttons = self.driver.find_elements(By.TAG_NAME, "button")
        for btn in buttons:
            if "Dodaj do koszyka" in btn.text:
                btn.click()
        self.driver.find_element(By.LINK_TEXT, "Koszyk").click()

        items = self.driver.find_elements(By.TAG_NAME, "li")
        assert len(items) == 3
        assert "Produkt 1" in items[0].text
        assert "Produkt 2" in items[1].text
        assert "Produkt 3" in items[2].text

        remove_buttons = [btn for btn in self.driver.find_elements(By.TAG_NAME, "button") if "Usuń" in btn.text]
        assert len(remove_buttons) == 3

        submit_cart_button = [btn for btn in self.driver.find_elements(By.TAG_NAME, "button") if "Zatwierdź koszyk" in btn.text]
        assert len(submit_cart_button) == 1

        clear_cart_button = [btn for btn in self.driver.find_elements(By.TAG_NAME, "button") if "Wyczyść koszyk" in btn.text]
        assert len(clear_cart_button) == 1

    def test_add_multiple_products_and_remove_them(self):
        self.driver.get("http://localhost:3000/")
        buttons = self.driver.find_elements(By.TAG_NAME, "button")
        for btn in buttons:
            if "Dodaj do koszyka" in btn.text:
                btn.click()
        self.driver.find_element(By.LINK_TEXT, "Koszyk").click()

        items = self.driver.find_elements(By.TAG_NAME, "li")
        assert len(items) == 3

        remove_buttons = [btn for btn in self.driver.find_elements(By.TAG_NAME, "button") if "Usuń" in btn.text]
        assert len(remove_buttons) == 3
        for rm_btn in remove_buttons:
                rm_btn.click()

        body = self.driver.find_element(By.TAG_NAME, "body")
        assert "Koszyk jest pusty" in body.text