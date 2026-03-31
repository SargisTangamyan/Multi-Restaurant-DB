USE restaurant_project;
GO

-- 1. Get all users with role = 'admin'
SELECT *
FROM users
WHERE role = 'admin';

-- 2. Get all restaurants owned by user with id = 6
SELECT *
FROM restaurants
WHERE owner_id = 6;

-- 3. Get usernames and emails of all users
SELECT username, email
FROM users;

-- 4. Get all available dishes
SELECT *
FROM dishes
WHERE is_available = 1;

-- 5. Get all dishes with price greater than 10
SELECT *
FROM dishes
WHERE price > 10;

-- 6. Get names of all categories
SELECT name
FROM categories;

-- 7. Get all orders with status 'pending'
SELECT *
FROM orders
WHERE status = 'pending';

-- 8. Get all users who have verified emails
SELECT *
FROM users
WHERE email_verified_at IS NOT NULL;

-- 9. Get all dishes belonging to a specific restaurant (id = 2)
SELECT *
FROM dishes
WHERE restaurant_id = 2;

-- 10. Get all staff members working in the restaurant id = 3
SELECT u.first_name, u.last_name
FROM users u
         JOIN restaurant_staffs r
                   ON r.user_id = u.id
WHERE r.restaurant_id = 3;

-- 11. Get all orders of a specific user (id = 35)
SELECT *
FROM orders
WHERE user_id = 35;

-- 12. Get all cart items with quantity > 2
SELECT *
FROM cart_items
WHERE quantity > 2;

-- 13. List all dish names that contain ingredients marked as allergic.
SELECT DISTINCT d.name
FROM dishes d
         JOIN dish_ingredients di
                   ON d.id = di.dish_id
         JOIN ingredients i
                   ON di.ingredient_id = i.id
WHERE i.is_allergic = 1;

-- 14. Get all dishes with their category names
SELECT d.name, c.name AS category_name
FROM dishes d
         LEFT JOIN categories c
                   ON d.category_id = c.id;

-- 15. List the usernames of owners alongside the names of the restaurants and the
-- specific branch addresses they manage.
SELECT u.username, r.name, rb.address
FROM users u
         JOIN restaurants r
              ON u.id = r.owner_id
         JOIN restaurant_branches rb
              ON rb.restaurant_id = r.id;

-- 16. Get all branche addresses with restaurant names
SELECT rb.address, r.name
FROM restaurant_branches rb
         JOIN restaurants r
              ON rb.restaurant_id = r.id;

-- 17. Get the names of dishes and the usernames of the people who left a review for them.
SELECT d.name, u.username
FROM dishes d
         JOIN dish_reviews dr
                   ON dr.dish_id = d.id
         JOIN users u
                   ON dr.user_id = u.id;

-- 18. Get order IDs, the username of the customer, and the physical address of the branch
-- where the order was placed.
SELECT o.id, u.username, rb.address
FROM orders o
         JOIN users u
              ON o.user_id = u.id
         JOIN suborders so
              ON so.order_id = o.id
         JOIN restaurant_branches rb
              ON rb.id = so.restaurant_branch_id;

-- 19. Get all users who are either admins or restaurant owners
SELECT *
FROM users
WHERE role in ('admin', 'restaurant');

-- 20. Get all users who are not staff
SELECT u.id, u.username, u.role
FROM users u
         LEFT JOIN restaurant_staffs rs
                   ON rs.user_id = u.id
WHERE rs.user_id IS NULL;

-- 21. Get all dishes that are not in any cart
SELECT d.name
FROM dishes d
         LEFT JOIN cart_items ci
                   on d.id = ci.dish_id
WHERE ci.dish_id IS NULL;

-- 22. List all dishes that have been ordered at least once but have zero reviews.
SELECT DISTINCT d.name
FROM dishes d
         INNER JOIN order_items oi
                    ON oi.dish_id = d.id
         LEFT JOIN dish_reviews dr
                   ON dr.dish_id = d.id
WHERE dr.dish_id IS NULL;

-- 23. Get all ingredients that aren't used in any dish
SELECT i.name
FROM ingredients i
         LEFT JOIN dish_ingredients di
                   ON i.id = di.ingredient_id
WHERE di.ingredient_id IS NULL;

-- 24. Get the usernames of all users who have at least one dish in their wishlist, including the dish name.
SELECT u.username, d.name
FROM users u
         JOIN wishlists w
              ON u.id = w.user_id
         JOIN dishes d
              ON w.dish_id = d.id;

-- 25. Get all users who never placed orders
SELECT u.username
FROM users u
         LEFT JOIN orders o
                   ON u.id = o.user_id
WHERE o.user_id IS NULL;

-- 26. List the names of all ingredients that are currently used in dishes priced over 10 units.
SELECT DISTINCT i.name
FROM ingredients i
         JOIN dish_ingredients di
              ON i.id = di.ingredient_id
         JOIN dishes d
              ON di.dish_id = d.id
WHERE d.price > 10;

-- 27. Find the names of dishes that have been ordered in a quantity greater than 3 across all orders.
SELECT d.name
FROM dishes d
WHERE d.id IN (SELECT oi.dish_id
               FROM order_items oi
               GROUP BY oi.dish_id
               HAVING SUM(oi.quantity) > 3);

-- 28. Find usernames of users who have placed orders in more than one different restaurant branch.
SELECT u.username
FROM users u
         JOIN orders o ON u.id = o.user_id
         JOIN suborders so ON o.id = so.order_id
GROUP BY u.id, u.username
HAVING COUNT(DISTINCT so.restaurant_branch_id) > 1;

-- 29. Get all dishes that do not contain any ingredients marked as allergic
SELECT d.name
FROM dishes d
WHERE d.id NOT IN (SELECT di.dish_id
                   FROM dish_ingredients di
                            JOIN ingredients i
                                 ON di.ingredient_id = i.id
                   WHERE i.is_allergic = 1);

-- 30. Find users who have ordered the same dish more than once.
SELECT u.username, d.name AS dish_name, COUNT(*) AS order_count
FROM users u
         JOIN orders o ON u.id = o.user_id
         JOIN suborders so ON o.id = so.order_id
         JOIN order_items oi ON so.id = oi.suborder_id
         JOIN dishes d ON oi.dish_id = d.id
GROUP BY u.id, u.username, d.id, d.name
HAVING COUNT(*) > 1;
