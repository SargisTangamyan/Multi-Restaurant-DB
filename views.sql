USE restaurant_project;
GO

/*
==========================================================
VIEWS TEMPLATE
Restaurant Project
==========================================================
*/

/*----------------------------------------------------------
ACTIVE USERS
----------------------------------------------------------*/
CREATE OR ALTER VIEW vw_active_users
AS
SELECT
    u.id,
    u.username,
    u.profile_image,
    u.first_name,
    u.last_name,
    u.city,
    u.phone_number,
    u.address,
    u.email,
    u.email_verified_at,
    u.role,
    u.stripe_id,
    u.pm_type,
    u.pm_last_four,
    u.trial_ends_at,
    u.created_at,
    u.updated_at
FROM users u
WHERE u.deleted_at IS NULL;
GO


/*----------------------------------------------------------
RESTAURANT OVERVIEW
----------------------------------------------------------*/
CREATE OR ALTER VIEW vw_restaurants_overview
AS
SELECT
    r.id,
    r.owner_id,
    u.username AS owner_username,
    u.first_name AS owner_first_name,
    u.last_name AS owner_last_name,
    r.name,
    r.description,
    r.phone_number,
    r.image,
    r.created_at,
    r.updated_at
FROM restaurants r
         INNER JOIN users u
                    ON u.id = r.owner_id
WHERE r.deleted_at IS NULL
  AND u.deleted_at IS NULL;
GO


/*----------------------------------------------------------
RESTAURANT BRANCHES OVERVIEW
----------------------------------------------------------*/
CREATE OR ALTER VIEW vw_restaurant_branches_overview
AS
SELECT
    rb.id,
    rb.restaurant_id,
    r.name AS restaurant_name,
    rb.city,
    rb.address,
    rb.phone_number,
    rb.created_at,
    rb.updated_at
FROM restaurant_branches rb
         INNER JOIN restaurants r
                    ON r.id = rb.restaurant_id
WHERE rb.deleted_at IS NULL
  AND r.deleted_at IS NULL;
GO


/*----------------------------------------------------------
RESTAURANT STAFF OVERVIEW
----------------------------------------------------------*/
CREATE OR ALTER VIEW vw_restaurant_staff_overview
AS
SELECT
    rs.id,
    rs.user_id,
    u.username,
    u.first_name,
    u.last_name,
    u.email,
    rs.restaurant_id,
    r.name AS restaurant_name,
    rs.role,
    rs.created_at,
    rs.updated_at
FROM restaurant_staffs rs
         INNER JOIN users u
                    ON u.id = rs.user_id
         INNER JOIN restaurants r
                    ON r.id = rs.restaurant_id
WHERE rs.deleted_at IS NULL
  AND u.deleted_at IS NULL
  AND r.deleted_at IS NULL;
GO


/*----------------------------------------------------------
CATEGORIES WITH PARENT
----------------------------------------------------------*/
CREATE OR ALTER VIEW vw_categories_hierarchy
AS
SELECT
    c.id,
    c.name,
    c.slug,
    c.parent_id,
    p.name AS parent_name,
    p.slug AS parent_slug,
    c.created_at,
    c.updated_at
FROM categories c
         LEFT JOIN categories p
                   ON p.id = c.parent_id
WHERE c.deleted_at IS NULL;
GO


/*----------------------------------------------------------
DISH CATALOG
----------------------------------------------------------*/
CREATE OR ALTER VIEW vw_dish_catalog
AS
SELECT
    d.id,
    d.slug,
    d.category_id,
    c.name AS category_name,
    c.slug AS category_slug,
    d.restaurant_id,
    r.name AS restaurant_name,
    d.name AS dish_name,
    d.description,
    d.price,
    d.image,
    d.thumbnail,
    d.average_rating,
    d.reviews_count,
    d.is_available,
    d.created_at,
    d.updated_at
FROM dishes d
         INNER JOIN categories c
                    ON c.id = d.category_id
         INNER JOIN restaurants r
                    ON r.id = d.restaurant_id
WHERE d.deleted_at IS NULL
  AND c.deleted_at IS NULL
  AND r.deleted_at IS NULL;
GO


/*----------------------------------------------------------
AVAILABLE DISHES ONLY
----------------------------------------------------------*/
CREATE OR ALTER VIEW vw_available_dishes
AS
SELECT
    d.id,
    d.slug,
    d.category_id,
    c.name AS category_name,
    d.restaurant_id,
    r.name AS restaurant_name,
    d.name AS dish_name,
    d.price,
    d.image,
    d.thumbnail,
    d.average_rating,
    d.reviews_count,
    d.created_at
FROM dishes d
         INNER JOIN categories c
                    ON c.id = d.category_id
         INNER JOIN restaurants r
                    ON r.id = d.restaurant_id
WHERE d.deleted_at IS NULL
  AND c.deleted_at IS NULL
  AND r.deleted_at IS NULL
  AND d.is_available = 1;
GO


/*----------------------------------------------------------
INGREDIENTS
----------------------------------------------------------*/
CREATE OR ALTER VIEW vw_ingredients
AS
SELECT
    i.id,
    i.name,
    i.slug,
    i.unit,
    i.is_allergic,
    i.created_at,
    i.updated_at
FROM ingredients i;
GO


/*----------------------------------------------------------
DISH INGREDIENTS DETAIL
----------------------------------------------------------*/
CREATE OR ALTER VIEW vw_dish_ingredients_detail
AS
SELECT
    di.dish_id,
    d.name AS dish_name,
    di.ingredient_id,
    i.name AS ingredient_name,
    i.slug AS ingredient_slug,
    i.unit,
    i.is_allergic,
    di.quantity
FROM dish_ingredients di
         INNER JOIN dishes d
                    ON d.id = di.dish_id
         INNER JOIN ingredients i
                    ON i.id = di.ingredient_id
WHERE d.deleted_at IS NULL;
GO


/*----------------------------------------------------------
USER ALLERGIES DETAIL
----------------------------------------------------------*/
CREATE OR ALTER VIEW vw_user_allergies_detail
AS
SELECT
    ua.user_id,
    u.username,
    u.first_name,
    u.last_name,
    ua.ingredient_id,
    i.name AS ingredient_name,
    i.slug AS ingredient_slug,
    i.unit,
    i.is_allergic
FROM user_allergies ua
         INNER JOIN users u
                    ON u.id = ua.user_id
         INNER JOIN ingredients i
                    ON i.id = ua.ingredient_id
WHERE u.deleted_at IS NULL;
GO


/*----------------------------------------------------------
CART ITEMS DETAIL
----------------------------------------------------------*/
CREATE OR ALTER VIEW vw_cart_items_detail
AS
SELECT
    ci.id AS cart_item_id,
    ci.cart_id,
    c.user_id,
    u.username,
    ci.dish_id,
    d.name AS dish_name,
    d.price AS dish_price,
    ci.quantity,
    (ci.quantity * d.price) AS line_total,
    ci.created_at,
    ci.updated_at
FROM cart_items ci
         INNER JOIN carts c
                    ON c.id = ci.cart_id
         INNER JOIN users u
                    ON u.id = c.user_id
         INNER JOIN dishes d
                    ON d.id = ci.dish_id
WHERE u.deleted_at IS NULL
  AND d.deleted_at IS NULL;
GO


/*----------------------------------------------------------
ORDERS SUMMARY
----------------------------------------------------------*/
CREATE OR ALTER VIEW vw_orders_summary
AS
SELECT
    o.id,
    o.user_id,
    u.username,
    u.first_name,
    u.last_name,
    o.total_price,
    o.status,
    o.payment_method,
    o.delivery_address,
    o.contact_phone,
    o.delivery_fee,
    o.created_at,
    o.updated_at
FROM orders o
         INNER JOIN users u
                    ON u.id = o.user_id
WHERE o.deleted_at IS NULL
  AND u.deleted_at IS NULL;
GO


/*----------------------------------------------------------
SUBORDERS SUMMARY
----------------------------------------------------------*/
CREATE OR ALTER VIEW vw_suborders_summary
AS
SELECT
    so.id,
    so.order_id,
    o.user_id,
    u.username,
    so.restaurant_branch_id,
    rb.address AS branch_address,
    rb.city AS branch_city,
    r.id AS restaurant_id,
    r.name AS restaurant_name,
    so.status,
    so.total_price,
    so.created_at,
    so.updated_at
FROM suborders so
         INNER JOIN orders o
                    ON o.id = so.order_id
         INNER JOIN users u
                    ON u.id = o.user_id
         INNER JOIN restaurant_branches rb
                    ON rb.id = so.restaurant_branch_id
         INNER JOIN restaurants r
                    ON r.id = rb.restaurant_id
WHERE so.deleted_at IS NULL
  AND o.deleted_at IS NULL
  AND u.deleted_at IS NULL
  AND rb.deleted_at IS NULL
  AND r.deleted_at IS NULL;
GO


/*----------------------------------------------------------
ORDER ITEMS DETAIL
----------------------------------------------------------*/
CREATE OR ALTER VIEW vw_order_items_detail
AS
SELECT
    oi.id AS order_item_id,
    oi.suborder_id,
    so.order_id,
    so.restaurant_branch_id,
    rb.address AS branch_address,
    rb.city AS branch_city,
    oi.dish_id,
    d.name AS dish_name,
    d.price AS current_dish_price,
    oi.quantity,
    oi.price AS item_price_at_order_time,
    (oi.quantity * oi.price) AS line_total,
    oi.created_at,
    oi.updated_at
FROM order_items oi
         INNER JOIN suborders so
                    ON so.id = oi.suborder_id
         INNER JOIN restaurant_branches rb
                    ON rb.id = so.restaurant_branch_id
         INNER JOIN dishes d
                    ON d.id = oi.dish_id
WHERE oi.deleted_at IS NULL
  AND so.deleted_at IS NULL
  AND rb.deleted_at IS NULL
  AND d.deleted_at IS NULL;
GO


/*----------------------------------------------------------
DISH REVIEWS DETAIL
----------------------------------------------------------*/
CREATE OR ALTER VIEW vw_dish_reviews_detail
AS
SELECT
    dr.id,
    dr.user_id,
    u.username,
    u.first_name,
    u.last_name,
    dr.dish_id,
    d.name AS dish_name,
    d.restaurant_id,
    r.name AS restaurant_name,
    dr.rating,
    dr.comment,
    dr.created_at,
    dr.updated_at
FROM dish_reviews dr
         INNER JOIN users u
                    ON u.id = dr.user_id
         INNER JOIN dishes d
                    ON d.id = dr.dish_id
         INNER JOIN restaurants r
                    ON r.id = d.restaurant_id
WHERE u.deleted_at IS NULL
  AND d.deleted_at IS NULL
  AND r.deleted_at IS NULL;
GO


/*----------------------------------------------------------
WISHLISTS DETAIL
----------------------------------------------------------*/
CREATE OR ALTER VIEW vw_wishlists_detail
AS
SELECT
    w.user_id,
    u.username,
    u.first_name,
    u.last_name,
    w.dish_id,
    d.name AS dish_name,
    d.slug AS dish_slug,
    d.price,
    d.is_available,
    d.restaurant_id,
    r.name AS restaurant_name
FROM wishlists w
         INNER JOIN users u
                    ON u.id = w.user_id
         INNER JOIN dishes d
                    ON d.id = w.dish_id
         INNER JOIN restaurants r
                    ON r.id = d.restaurant_id
WHERE u.deleted_at IS NULL
  AND d.deleted_at IS NULL
  AND r.deleted_at IS NULL;
GO


/*----------------------------------------------------------
DISH PERFORMANCE SUMMARY
----------------------------------------------------------*/
CREATE OR ALTER VIEW vw_dish_performance_summary
AS
SELECT
    d.id,
    d.name AS dish_name,
    d.restaurant_id,
    r.name AS restaurant_name,
    d.category_id,
    c.name AS category_name,
    d.price,
    d.average_rating,
    d.reviews_count,
    d.is_available,
    COUNT(DISTINCT oi.id) AS total_order_items,
    SUM(oi.quantity) AS total_quantity_sold,
    COUNT(DISTINCT dr.id) AS total_reviews
FROM dishes d
         INNER JOIN restaurants r
                    ON r.id = d.restaurant_id
         INNER JOIN categories c
                    ON c.id = d.category_id
         LEFT JOIN order_items oi
                   ON oi.dish_id = d.id
                       AND oi.deleted_at IS NULL
         LEFT JOIN dish_reviews dr
                   ON dr.dish_id = d.id
WHERE d.deleted_at IS NULL
  AND r.deleted_at IS NULL
  AND c.deleted_at IS NULL
GROUP BY
    d.id,
    d.name,
    d.restaurant_id,
    r.name,
    d.category_id,
    c.name,
    d.price,
    d.average_rating,
    d.reviews_count,
    d.is_available;
GO