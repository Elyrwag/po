from selenium.webdriver.common.by import By
from base_test import BaseTest

# 4 test cases
# 16 asserts

class TestNavigation(BaseTest):
    def before_each(self):
        self.driver.get("http://localhost:3000/")

    def test_contain_navigation_links(self):
        self.before_each()

        links = self.driver.find_elements(By.TAG_NAME, "a")
        assert len(links) == 3

        body = self.driver.find_element(By.TAG_NAME, "body")
        assert "Produkty" in body.text
        assert "Koszyk" in body.text
        assert "Podsumowanie" in body.text

    def test_navigate_to_products_page(self):
        self.before_each()
        self.driver.find_element(By.LINK_TEXT, "Produkty").click()

        assert "/" in self.driver.current_url

        h1 = self.driver.find_element(By.TAG_NAME, "h1")
        assert "Produkty" in h1.text

        list_items = self.driver.find_elements(By.TAG_NAME, "li")
        assert len(list_items) == 3

        h2 = self.driver.find_elements(By.TAG_NAME, "h2")
        assert len(h2) == 3

        paragraphs = self.driver.find_elements(By.TAG_NAME, "p")
        assert len(paragraphs) == 3

        buttons = self.driver.find_elements(By.TAG_NAME, "button")
        assert len(buttons) == 3

    def test_navigate_to_cart_page(self):
        self.before_each()
        self.driver.find_element(By.LINK_TEXT, "Koszyk").click()

        assert "/cart" in self.driver.current_url

        h1 = self.driver.find_element(By.TAG_NAME, "h1")
        assert "Koszyk" in h1.text

        body = self.driver.find_element(By.TAG_NAME, "body")
        assert "Koszyk jest pusty" in body.text

    def test_navigate_to_payments_page(self):
        self.before_each()
        self.driver.find_element(By.LINK_TEXT, "Podsumowanie").click()

        assert "/payments" in self.driver.current_url

        h1 = self.driver.find_element(By.TAG_NAME, "h1")
        assert "Podsumowanie" in h1.text

        body = self.driver.find_element(By.TAG_NAME, "body")
        assert "Koszyk jest pusty" in body.text