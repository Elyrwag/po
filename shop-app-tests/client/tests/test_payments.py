from selenium.webdriver.common.alert import Alert
from selenium.webdriver.common.by import By
from base_test import BaseTest
from utils import fill_payment_form
import time

# 11 test cases
# 24 asserts

class TestPayments(BaseTest):
    def before_each(self):
        self.driver.get("http://localhost:3000/")
        add_button = [btn for btn in self.driver.find_elements(By.TAG_NAME, "button") if "Dodaj do koszyka" in btn.text][0]
        add_button.click()
        self.driver.find_element(By.LINK_TEXT, "Podsumowanie").click()

    def test_show_payment_form_with_products(self):
        self.before_each()

        li_items = self.driver.find_elements(By.TAG_NAME, "li")
        assert len(li_items) == 1

        h2_elements = self.driver.find_elements(By.TAG_NAME, "h2")
        assert any("Produkty w koszyku:" in h2.text for h2 in h2_elements)

        product_h2 = [h2 for h2 in h2_elements if "Produkty w koszyku:" in h2.text][0]
        p_elements = product_h2.find_elements(By.XPATH, "following-sibling::p")
        assert p_elements and "Do zapłaty:" in p_elements[0].text

        assert self.driver.find_elements(By.TAG_NAME, "form")

        assert self.driver.find_elements(By.NAME, "name")
        assert self.driver.find_elements(By.NAME, "surname")
        assert self.driver.find_elements(By.NAME, "email")
        assert self.driver.find_elements(By.NAME, "cardNumber")

        submit_buttons = self.driver.find_elements(By.CSS_SELECTOR, 'button[type="submit"]')
        assert submit_buttons

    def test_hide_form_when_cart_is_empty(self):
        self.before_each()

        self.driver.find_element(By.LINK_TEXT, "Koszyk").click()
        clear_button = [btn for btn in self.driver.find_elements(By.TAG_NAME, "button") if "Wyczyść koszyk" in btn.text][0]
        clear_button.click()
        self.driver.find_element(By.LINK_TEXT, "Podsumowanie").click()

        body_text = self.driver.find_element(By.TAG_NAME, "body").text
        assert "Koszyk jest pusty" in body_text

        forms = self.driver.find_elements(By.TAG_NAME, "form")
        assert len(forms) == 0

    def test_show_error_for_empty_name_field(self):
        self.before_each()

        fill_payment_form(self.driver, {"name": ""})
        self.driver.find_element(By.CSS_SELECTOR, 'button[type="submit"]').click()

        invalid_name_inputs = self.driver.find_elements(By.CSS_SELECTOR, 'input[name="name"]:invalid')
        assert len(invalid_name_inputs) > 0

    def test_fill_partial_data(self):
        self.before_each()

        fill_payment_form(self.driver, {"email": "", "cardNumber": "1234567890123456"})
        self.driver.find_element(By.CSS_SELECTOR, 'button[type="submit"]').click()

        invalid_inputs = self.driver.find_elements(By.CSS_SELECTOR, 'input:invalid')
        assert len(invalid_inputs) >= 1

    def test_show_error_for_incorrect_email_field(self):
        self.before_each()

        fill_payment_form(self.driver, {"email": "example"})
        self.driver.find_element(By.CSS_SELECTOR, 'button[type="submit"]').click()

        invalid_email_inputs = self.driver.find_elements(By.CSS_SELECTOR, 'input[name="email"]:invalid')
        assert len(invalid_email_inputs) > 0

    def test_validate_empty_payment_form(self):
        self.before_each()

        fill_payment_form(self.driver, {"cardNumber": ""})
        self.driver.find_element(By.CSS_SELECTOR, 'button[type="submit"]').click()

        invalid_card_inputs = self.driver.find_elements(By.CSS_SELECTOR, 'input[name="cardNumber"]:invalid')
        assert len(invalid_card_inputs) > 0

    def test_validate_incorrect_card_number(self):
        self.before_each()

        fill_payment_form(self.driver, {"cardNumber": "123"})
        self.driver.find_element(By.CSS_SELECTOR, 'button[type="submit"]').click()

        body_text = self.driver.find_element(By.TAG_NAME, "body").text
        assert "Numer karty musi mieć dokładnie 16 cyfr" in body_text

    def test_accept_valid_payment_data_for_one_product(self):
        self.before_each()

        fill_payment_form(self.driver)
        self.driver.find_element(By.CSS_SELECTOR, 'button[type="submit"]').click()

        time.sleep(3)

        alert = Alert(self.driver)
        assert "Płatność zrealizowana!" in alert.text
        alert.accept()

        body_text = self.driver.find_element(By.TAG_NAME, "body").text
        assert "Wystąpił błąd podczas przetwarzania płatności." not in body_text

    def test_accept_valid_payment_data_for_many_products(self):
        self.driver.get("http://localhost:3000/")
        add_buttons = [btn for btn in self.driver.find_elements(By.TAG_NAME, "button") if "Dodaj do koszyka" in btn.text]
        for add_button in add_buttons:
            add_button.click()
        self.driver.find_element(By.LINK_TEXT, "Podsumowanie").click()

        fill_payment_form(self.driver)
        self.driver.find_element(By.CSS_SELECTOR, 'button[type="submit"]').click()

        time.sleep(3)

        alert = Alert(self.driver)
        assert "Płatność zrealizowana!" in alert.text
        alert.accept()

        body_text = self.driver.find_element(By.TAG_NAME, "body").text
        assert "Wystąpił błąd podczas przetwarzania płatności." not in body_text

    def test_clear_cart_after_successful_payment(self):
        self.before_each()

        fill_payment_form(self.driver)
        self.driver.find_element(By.CSS_SELECTOR, 'button[type="submit"]').click()

        time.sleep(3)

        alert = Alert(self.driver)
        assert "Płatność zrealizowana!" in alert.text
        alert.accept()

        body_text = self.driver.find_element(By.TAG_NAME, "body").text
        assert "Wystąpił błąd podczas przetwarzania płatności." not in body_text

        self.driver.find_element(By.LINK_TEXT, "Koszyk").click()
        body_text = self.driver.find_element(By.TAG_NAME, "body").text
        assert "Koszyk jest pusty" in body_text

    def test_add_multiple_products_check_total(self):
        self.driver.get("http://localhost:3000/")
        add_buttons = [btn for btn in self.driver.find_elements(By.TAG_NAME, "button") if "Dodaj do koszyka" in btn.text]
        for add_button in add_buttons:
                add_button.click()
        self.driver.find_element(By.LINK_TEXT, "Podsumowanie").click()

        p_tags = self.driver.find_elements(By.TAG_NAME, "p")
        assert any("Do zapłaty: 60 PLN" in p.text for p in p_tags)