# Tests

Simple tests in bash to check if everything is working.

## Controllers data overview:

Product:

```
{
  "id": int, // only in GET method
  "name": str, 
  "categoryID": int,
  "price": float
}
```

Category:

```
{
  "id": int, // only in GET method
  "name": str
}
```

Review:

```
{
  "id": int, // only in GET method
  "productID": int,
  "rating": int // from 1 to 5
}
```

## Test order:

1. Insert test data (four categories, three products and two reviews)
2. ProductController tests
3. CategoryController tests
4. ReviewController tests
5. Clear database (if user chooses 'y' option)

### ProductController tests

1. GET all products (default there are three products)
2. POST (add) product (so now there are four products)
3. GET product with **id=4** (product added in 2.)
4. PUT (update) product with **id=3**
5. DELETE product with **id=1** and check with GET all products

### CategoryController tests

1. GET all categories (default there are four categories)
2. POST (add) category
3. GET category with **id=5** (category added in 2.)
4. PUT (update) category with **id=3**
5. DELETE category with **id=1** and check with GET all categories

### ReviewController tests

1. GET all reviews (default there are two reviews)
2. POST (add) review
3. GET review with **id=3** (review added in 2.)
4. PUT (update) review with **id=2**
5. DELETE review with **id=1** and check with GET all reviews
