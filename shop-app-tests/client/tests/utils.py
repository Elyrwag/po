from selenium.webdriver.common.by import By

def fill_payment_form(driver, data=None):
    data = data or {}
    name = data.get("name", "Test")
    surname = data.get("surname", "Testman")
    email = data.get("email", "ttest@example.com")
    card_number = data.get("cardNumber", "1234567890123456")

    if name:
        driver.find_element(By.NAME, "name").send_keys(name)
    if surname:
        driver.find_element(By.NAME, "surname").send_keys(surname)
    if email:
        driver.find_element(By.NAME, "email").send_keys(email)
    if card_number:
        driver.find_element(By.NAME, "cardNumber").send_keys(card_number)
