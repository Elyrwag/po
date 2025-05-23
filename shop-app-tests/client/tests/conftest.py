import pytest
from selenium import webdriver

@pytest.fixture()
def setup_and_teardown(request):
    options = webdriver.ChromeOptions()
    options.add_argument('--headless=new')

    driver = webdriver.Chrome(options=options)
    # driver.maximize_window()
    driver.get("http://localhost:3000/")

    if request.cls is not None:
        request.cls.driver = driver

    yield driver

    driver.quit()