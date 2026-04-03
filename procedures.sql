/*
===========================================================
STORED PROCEDURES (CORE 20)
Multi-Restaurant Food Ordering System
===========================================================

*/

USE restaurant_project;
GO


/*
===========================================================
1. GET USER ORDERS
===========================================================
*/
CREATE PROCEDURE get_user_orders
    @user_id BIGINT
AS
BEGIN
    SELECT *
    FROM orders
    WHERE user_id = @user_id
    ORDER BY created_at DESC;
END;
GO


/*
===========================================================
2. GET RESTAURANT MENU
===========================================================
*/
CREATE PROCEDURE get_restaurant_menu
    @restaurant_id BIGINT
AS
BEGIN
    SELECT *
    FROM dishes
    WHERE restaurant_id = @restaurant_id AND is_available = 1;
END;
GO


/*
===========================================================
3. ADD DISH
===========================================================
*/
CREATE PROCEDURE add_dish
    @restaurant_id BIGINT,
    @category_id BIGINT,
    @name VARCHAR(255),
    @price DECIMAL(10,2)
AS
BEGIN
    INSERT INTO dishes (slug, category_id, restaurant_id, name, price, image)
    VALUES (LOWER(REPLACE(@name, ' ', '-')), @category_id, @restaurant_id, @name, @price, 'default.jpg');
END;
GO


/*
===========================================================
4. UPDATE DISH AVAILABILITY
===========================================================
*/
CREATE PROCEDURE update_dish_availability
    @dish_id BIGINT,
    @is_available BIT
AS
BEGIN
    UPDATE dishes
    SET is_available = @is_available
    WHERE id = @dish_id;
END;
GO


/*
===========================================================
5. ADD TO CART
===========================================================
*/
CREATE PROCEDURE add_to_cart
    @user_id BIGINT,
    @dish_id BIGINT,
    @quantity INT
AS
BEGIN
    DECLARE @cart_id BIGINT;

    SELECT @cart_id = id FROM carts WHERE user_id = @user_id;

    INSERT INTO cart_items (cart_id, dish_id, quantity)
    VALUES (@cart_id, @dish_id, @quantity);
END;
GO


/*
===========================================================
6. REMOVE FROM CART
===========================================================
*/
CREATE PROCEDURE remove_from_cart
    @cart_id BIGINT,
    @dish_id BIGINT
AS
BEGIN
    DELETE FROM cart_items
    WHERE cart_id = @cart_id AND dish_id = @dish_id;
END;
GO


/*
===========================================================
7. CREATE ORDER
===========================================================
*/
CREATE PROCEDURE create_order
    @user_id BIGINT,
    @total_price DECIMAL(10,2),
    @payment_method VARCHAR(10),
    @delivery_address VARCHAR(255)
AS
BEGIN
    INSERT INTO orders (user_id, total_price, payment_method, delivery_address)
    VALUES (@user_id, @total_price, @payment_method, @delivery_address);
END;
GO


/*
===========================================================
8. UPDATE ORDER STATUS
===========================================================
*/
CREATE PROCEDURE update_order_status
    @order_id BIGINT,
    @status VARCHAR(20)
AS
BEGIN
    UPDATE orders
    SET status = @status
    WHERE id = @order_id;
END;
GO


/*
===========================================================
9. GET RESTAURANT SUBORDERS
===========================================================
*/
CREATE PROCEDURE get_restaurant_suborders
    @restaurant_id BIGINT
AS
BEGIN
    SELECT s.*
    FROM suborders s
    JOIN restaurant_branches rb ON s.restaurant_branch_id = rb.id
    WHERE rb.restaurant_id = @restaurant_id;
END;
GO


/*
===========================================================
10. UPDATE SUBORDER STATUS
===========================================================
*/
CREATE PROCEDURE update_suborder_status
    @suborder_id BIGINT,
    @status VARCHAR(20)
AS
BEGIN
    UPDATE suborders
    SET status = @status
    WHERE id = @suborder_id;
END;
GO


/*
===========================================================
11. ADD REVIEW
===========================================================
*/
CREATE PROCEDURE add_review
    @user_id BIGINT,
    @dish_id BIGINT,
    @rating INT,
    @comment VARCHAR(MAX)
AS
BEGIN
    INSERT INTO dish_reviews (user_id, dish_id, rating, comment)
    VALUES (@user_id, @dish_id, @rating, @comment);
END;
GO


/*
===========================================================
12. GET DISH REVIEWS
===========================================================
*/
CREATE PROCEDURE get_dish_reviews
    @dish_id BIGINT
AS
BEGIN
    SELECT *
    FROM dish_reviews
    WHERE dish_id = @dish_id;
END;
GO


/*
===========================================================
13. CHECK ALLERGY RISK
===========================================================
*/
CREATE PROCEDURE check_allergy_risk
    @user_id BIGINT,
    @dish_id BIGINT
AS
BEGIN
    SELECT i.name
    FROM user_allergies ua
    JOIN dish_ingredients di ON ua.ingredient_id = di.ingredient_id
    JOIN ingredients i ON i.id = ua.ingredient_id
    WHERE ua.user_id = @user_id AND di.dish_id = @dish_id;
END;
GO


/*
===========================================================
14. ADD USER ALLERGY
===========================================================
*/
CREATE PROCEDURE add_user_allergy
    @user_id BIGINT,
    @ingredient_id BIGINT
AS
BEGIN
    INSERT INTO user_allergies (user_id, ingredient_id)
    VALUES (@user_id, @ingredient_id);
END;
GO


/*
===========================================================
15. GET TOP DISHES
===========================================================
*/
CREATE PROCEDURE get_top_dishes
AS
BEGIN
    SELECT *
    FROM dishes
    ORDER BY average_rating DESC;
END;
GO


/*
===========================================================
16. GET RESTAURANT REVENUE
===========================================================
*/
CREATE PROCEDURE get_restaurant_revenue
    @restaurant_id BIGINT
AS
BEGIN
    SELECT SUM(s.total_price) AS revenue
    FROM suborders s
    JOIN restaurant_branches rb ON s.restaurant_branch_id = rb.id
    WHERE rb.restaurant_id = @restaurant_id;
END;
GO


/*
===========================================================
17. GET ACTIVE USERS
===========================================================
*/
CREATE PROCEDURE get_active_users
AS
BEGIN
    SELECT user_id, COUNT(*) AS orders_count
    FROM orders
    GROUP BY user_id
    ORDER BY orders_count DESC;
END;
GO


/*
===========================================================
18. CLEAR CART
===========================================================
*/
CREATE PROCEDURE clear_cart
    @user_id BIGINT
AS
BEGIN
    DELETE ci
    FROM cart_items ci
    JOIN carts c ON ci.cart_id = c.id
    WHERE c.user_id = @user_id;
END;
GO


/*
===========================================================
19. ADD TO WISHLIST
===========================================================
*/
CREATE PROCEDURE add_to_wishlist
    @user_id BIGINT,
    @dish_id BIGINT
AS
BEGIN
    INSERT INTO wishlists (user_id, dish_id)
    VALUES (@user_id, @dish_id);
END;
GO


/*
===========================================================
20. REMOVE FROM WISHLIST
===========================================================
*/
CREATE PROCEDURE remove_from_wishlist
    @user_id BIGINT,
    @dish_id BIGINT
AS
BEGIN
    DELETE FROM wishlists
    WHERE user_id = @user_id AND dish_id = @dish_id;
END;
GO

/*
===========================================================
21. GET FULL CART
===========================================================
*/
CREATE PROCEDURE get_full_cart
    @user_id BIGINT
AS
BEGIN
    SELECT
        d.name,
        ci.quantity,
        d.price,
        ci.quantity * d.price AS total
    FROM carts c
    JOIN cart_items ci ON c.id = ci.cart_id
    JOIN dishes d ON ci.dish_id = d.id
    WHERE c.user_id = @user_id;
END;
GO


/*
===========================================================
22. CHECK DISH AVAILABILITY
===========================================================
*/
CREATE PROCEDURE check_dish_availability
    @dish_id BIGINT
AS
BEGIN
    SELECT is_available
    FROM dishes
    WHERE id = @dish_id;
END;
GO



/*
===========================================================
23. GET RESTAURANT STATS
===========================================================
*/
CREATE PROCEDURE get_restaurant_stats
    @restaurant_id BIGINT
AS
BEGIN
    SELECT
        COUNT(DISTINCT s.id) AS total_orders,
        SUM(s.total_price) AS revenue
    FROM suborders s
    JOIN restaurant_branches rb ON s.restaurant_branch_id = rb.id
    WHERE rb.restaurant_id = @restaurant_id;
END;
GO


/*
===========================================================
24. GET POPULAR DISHES
===========================================================
*/
CREATE PROCEDURE get_popular_dishes
AS
BEGIN
    SELECT
        d.id,
        d.name,
        COUNT(w.user_id) AS wishlist_count
    FROM dishes d
    LEFT JOIN wishlists w ON d.id = w.dish_id
    GROUP BY d.id, d.name
    ORDER BY wishlist_count DESC;
END;
GO


/*
===========================================================
25. GET ACTIVE ORDERS
===========================================================
*/
CREATE PROCEDURE get_active_orders
AS
BEGIN
    SELECT *
    FROM orders
    WHERE status IN ('pending', 'confirmed', 'preparing');
END;
GO


/*
===========================================================
26. GET ORDERS BY RESTAURANT
===========================================================
*/
CREATE PROCEDURE get_orders_by_restaurant
    @restaurant_id BIGINT
AS
BEGIN
    SELECT o.*
    FROM orders o
    JOIN suborders s ON o.id = s.order_id
    JOIN restaurant_branches rb ON s.restaurant_branch_id = rb.id
    WHERE rb.restaurant_id = @restaurant_id;
END;
GO


/*
===========================================================
27. CHECK USER EXISTS
===========================================================
*/
CREATE PROCEDURE check_user_exists
    @email VARCHAR(255)
AS
BEGIN
    SELECT COUNT(*) AS user_exists
    FROM users
    WHERE email = @email;
END;
GO


/*
===========================================================
28. GET DISH INGREDIENTS
===========================================================
*/
CREATE PROCEDURE get_dish_ingredients
    @dish_id BIGINT
AS
BEGIN
    SELECT i.name, di.quantity
    FROM dish_ingredients di
    JOIN ingredients i ON di.ingredient_id = i.id
    WHERE di.dish_id = @dish_id;
END;
GO


/*
===========================================================
END OF STORED PROCEDURES
===========================================================
*/