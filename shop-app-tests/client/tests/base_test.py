import pytest

@pytest.mark.usefixtures("setup_and_teardown")
class BaseTest:
    def some_method(self):
        pass