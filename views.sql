/*
===========================================================
CORE & ADVANCED VIEWS
Multi-Restaurant Food Ordering System
===========================================================

*/

USE restaurant_project;
GO


/*
===========================================================
1. USER ORDERS
===========================================================
*/
CREATE VIEW user_orders_view AS
SELECT
    o.id AS order_id,
    o.user_id,
    o.total_price,
    o.status,
    o.created_at
FROM orders o;


/*
===========================================================
2. FULL ORDER DETAILS (MAIN JOIN)
===========================================================
*/
CREATE VIEW order_full_details_view AS
SELECT
    o.id AS order_id,
    u.first_name,
    u.last_name,
    r.name AS restaurant_name,
    d.name AS dish_name,
    oi.quantity,
    oi.price,
    s.status AS suborder_status
FROM orders o
JOIN users u ON o.user_id = u.id
JOIN suborders s ON s.order_id = o.id
JOIN order_items oi ON oi.suborder_id = s.id
JOIN dishes d ON oi.dish_id = d.id
JOIN restaurant_branches rb ON s.restaurant_branch_id = rb.id
JOIN restaurants r ON rb.restaurant_id = r.id;


/*
===========================================================
3. RESTAURANT MENU
===========================================================
*/
CREATE VIEW restaurant_menu_view AS
SELECT
    r.id AS restaurant_id,
    r.name AS restaurant_name,
    d.id AS dish_id,
    d.name,
    d.price,
    d.average_rating,
    d.is_available
FROM restaurants r
JOIN dishes d ON r.id = d.restaurant_id;


/*
===========================================================
4. AVAILABLE DISHES ONLY
===========================================================
*/
CREATE VIEW available_dishes_view AS
SELECT *
FROM dishes
WHERE is_available = 1;


/*
===========================================================
5. TOP RATED DISHES
===========================================================
*/
CREATE VIEW top_rated_dishes_view AS
SELECT *
FROM dishes
WHERE average_rating >= 4.5;


/*
===========================================================
6. USER CART DETAILS
===========================================================
*/
CREATE VIEW user_cart_view AS
SELECT
    c.user_id,
    d.name AS dish_name,
    ci.quantity,
    d.price,
    ci.quantity * d.price AS total_price
FROM carts c
JOIN cart_items ci ON c.id = ci.cart_id
JOIN dishes d ON ci.dish_id = d.id;


/*
===========================================================
7. WISHLIST DETAILS
===========================================================
*/
CREATE VIEW wishlist_details_view AS
SELECT
    w.user_id,
    d.name AS dish_name
FROM wishlists w
JOIN dishes d ON w.dish_id = d.id;


/*
===========================================================
8. MOST WISHLISTED DISHES
===========================================================
*/
CREATE VIEW most_wishlisted_dishes_view AS
SELECT
    d.id,
    d.name,
    COUNT(*) AS times_added
FROM wishlists w
JOIN dishes d ON w.dish_id = d.id
GROUP BY d.id, d.name;


/*
===========================================================
9. ALLERGENIC DISHES
===========================================================
*/
CREATE VIEW allergenic_dishes_view AS
SELECT DISTINCT
    d.id,
    d.name,
    i.name AS ingredient
FROM dishes d
JOIN dish_ingredients di ON d.id = di.dish_id
JOIN ingredients i ON di.ingredient_id = i.id
WHERE i.is_allergic = 1;


/*
===========================================================
10. USER ALLERGY MATCH (IMPORTANT)
===========================================================
*/
CREATE VIEW user_allergy_risk_view AS
SELECT
    ua.user_id,
    d.name AS dish_name,
    i.name AS allergen
FROM user_allergies ua
JOIN ingredients i ON ua.ingredient_id = i.id
JOIN dish_ingredients di ON di.ingredient_id = i.id
JOIN dishes d ON d.id = di.dish_id;


/*
===========================================================
11. RESTAURANT ORDERS (SUBORDERS)
===========================================================
*/
CREATE VIEW restaurant_orders_view AS
SELECT
    r.name AS restaurant_name,
    rb.city,
    s.id AS suborder_id,
    s.status,
    s.total_price
FROM suborders s
JOIN restaurant_branches rb ON s.restaurant_branch_id = rb.id
JOIN restaurants r ON rb.restaurant_id = r.id;


/*
===========================================================
12. ORDERS BY STATUS
===========================================================
*/
CREATE VIEW orders_by_status_view AS
SELECT
    status,
    COUNT(*) AS total_orders
FROM orders
GROUP BY status;


/*
===========================================================
13. DAILY ORDERS
===========================================================
*/
CREATE VIEW daily_orders_view AS
SELECT
    CAST(created_at AS DATE) AS order_date,
    COUNT(*) AS total_orders
FROM orders
GROUP BY CAST(created_at AS DATE);


/*
===========================================================
14. REVENUE BY USER
===========================================================
*/
CREATE VIEW revenue_per_user_view AS
SELECT
    user_id,
    SUM(total_price) AS total_spent
FROM orders
GROUP BY user_id;


/*
===========================================================
15. REVENUE BY RESTAURANT
===========================================================
*/
CREATE VIEW revenue_per_restaurant_view AS
SELECT
    r.name,
    SUM(s.total_price) AS revenue
FROM suborders s
JOIN restaurant_branches rb ON s.restaurant_branch_id = rb.id
JOIN restaurants r ON rb.restaurant_id = r.id
GROUP BY r.name;


/*
===========================================================
16. DISH RATING SUMMARY
===========================================================
*/
CREATE VIEW dish_rating_summary_view AS
SELECT
    d.id,
    d.name,
    AVG(dr.rating) AS avg_rating,
    COUNT(dr.id) AS review_count
FROM dishes d
LEFT JOIN dish_reviews dr ON d.id = dr.dish_id
GROUP BY d.id, d.name;


/*
===========================================================
17. MOST ORDERED DISHES
===========================================================
*/
CREATE VIEW most_ordered_dishes_view AS
SELECT
    d.id,
    d.name,
    SUM(oi.quantity) AS total_ordered
FROM order_items oi
JOIN dishes d ON oi.dish_id = d.id
GROUP BY d.id, d.name;


/*
===========================================================
18. STAFF WORKLOAD
===========================================================
*/
CREATE VIEW staff_workload_view AS
SELECT
    rs.user_id,
    rs.restaurant_id,
    COUNT(s.id) AS total_suborders
FROM restaurant_staffs rs
JOIN restaurant_branches rb ON rs.restaurant_id = rb.restaurant_id
JOIN suborders s ON rb.id = s.restaurant_branch_id
GROUP BY rs.user_id, rs.restaurant_id;


/*
===========================================================
19. ACTIVE ORDERS
===========================================================
*/
CREATE VIEW active_orders_view AS
SELECT *
FROM orders
WHERE status IN ('pending', 'confirmed', 'preparing');


/*
===========================================================
20. COMPLETED ORDERS
===========================================================
*/
CREATE VIEW completed_orders_view AS
SELECT *
FROM orders
WHERE status IN ('completed', 'delivered');

