INSERT INTO category (name) VALUES ('Category 1');
INSERT INTO category (name) VALUES ('Category 2');
INSERT INTO category (name) VALUES ('Category 3');
INSERT INTO category (name) VALUES ('Category 4');

INSERT INTO product (name, price, category_id) VALUES ('Product 1', 699.99, 1);
INSERT INTO product (name, price, category_id) VALUES ('Product 2', 19.99, 4);
INSERT INTO product (name, price, category_id) VALUES ('Product 3', 49.99, 3);

INSERT INTO review (product_id, rating) VALUES (1, 5);
INSERT INTO review (product_id, rating) VALUES (3, 1);