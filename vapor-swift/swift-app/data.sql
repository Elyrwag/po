INSERT INTO brands (name) VALUES ('Brand 1');
INSERT INTO brands (name) VALUES ('Brand 2');
INSERT INTO brands (name) VALUES ('Brand 3');

INSERT INTO categories (name) VALUES ('Category 1');
INSERT INTO categories (name) VALUES ('Category 2');

INSERT INTO products (name, price, category_id, brand_id) VALUES ('Product 1', 100.00, 1, 1);
INSERT INTO products (name, price, category_id, brand_id) VALUES ('Product 2', 59.99, 1, 2);
INSERT INTO products (name, price, category_id, brand_id) VALUES ('Product 3', 123.12, 2, 1);
INSERT INTO products (name, price, category_id, brand_id) VALUES ('Product 4', 9.99, 2, 3);
