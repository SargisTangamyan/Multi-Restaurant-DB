/*
===========================================================
STORED PROCEDURES (28)
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
CREATE OR ALTER PROCEDURE get_user_orders
    @user_id BIGINT
AS
BEGIN
    SET NOCOUNT ON;

    SELECT
        o.id,
        o.total_price,
        o.status,
        o.payment_method,
        o.delivery_address,
        o.contact_phone,
        o.delivery_fee,
        o.created_at
    FROM orders o
    WHERE o.user_id = @user_id
      AND o.deleted_at IS NULL
    ORDER BY o.created_at DESC;
END;
GO


/*
===========================================================
2. GET RESTAURANT MENU
===========================================================
*/
CREATE OR ALTER PROCEDURE get_restaurant_menu
    @restaurant_id BIGINT
AS
BEGIN
    SET NOCOUNT ON;

    SELECT
        d.id,
        d.slug,
        d.name,
        d.description,
        d.price,
        d.image,
        d.average_rating,
        d.reviews_count,
        c.name AS category_name
    FROM dishes d
    JOIN categories c ON d.category_id = c.id
    WHERE d.restaurant_id = @restaurant_id
      AND d.is_available = 1
      AND d.deleted_at IS NULL;
END;
GO


/*
===========================================================
3. ADD DISH
===========================================================
*/
CREATE OR ALTER PROCEDURE add_dish
    @restaurant_id BIGINT,
    @category_id   BIGINT,
    @name          VARCHAR(255),
    @price         DECIMAL(10,2)
AS
BEGIN
    SET NOCOUNT ON;

    DECLARE @slug VARCHAR(255) = LOWER(REPLACE(@name, ' ', '-'));

    -- Resolve slug collision by appending a uniquifier
    IF EXISTS (
        SELECT 1 FROM dishes
        WHERE restaurant_id = @restaurant_id AND slug = @slug
    )
    BEGIN
        SET @slug = LEFT(@slug + '-' + REPLACE(CAST(NEWID() AS VARCHAR(36)), '-', ''), 255);
    END;

    INSERT INTO dishes (slug, category_id, restaurant_id, name, price, image)
    VALUES (@slug, @category_id, @restaurant_id, @name, @price, 'default.jpg');
END;
GO


/*
===========================================================
4. UPDATE DISH AVAILABILITY
===========================================================
*/
CREATE OR ALTER PROCEDURE update_dish_availability
    @dish_id      BIGINT,
    @is_available BIT
AS
BEGIN
    SET NOCOUNT ON;

    UPDATE dishes
    SET is_available = @is_available,
        updated_at   = GETDATE()
    WHERE id = @dish_id;
END;
GO


/*
===========================================================
5. ADD TO CART
   Creates the cart if it does not exist.
   Increments quantity if the dish is already in the cart.
===========================================================
*/
CREATE OR ALTER PROCEDURE add_to_cart
    @user_id  BIGINT,
    @dish_id  BIGINT,
    @quantity INT
AS
BEGIN
    SET NOCOUNT ON;

    IF @quantity <= 0
    BEGIN
        RAISERROR('Quantity must be greater than zero.', 16, 1);
        RETURN;
    END;

    DECLARE @cart_id BIGINT;
    SELECT @cart_id = id FROM carts WHERE user_id = @user_id AND status = 'active';

    IF @cart_id IS NULL
    BEGIN
        INSERT INTO carts (user_id) VALUES (@user_id);
        SET @cart_id = SCOPE_IDENTITY();
    END;

    IF EXISTS (SELECT 1 FROM cart_items WHERE cart_id = @cart_id AND dish_id = @dish_id)
    BEGIN
        UPDATE cart_items
        SET quantity   = quantity + @quantity,
            updated_at = GETDATE()
        WHERE cart_id = @cart_id AND dish_id = @dish_id;
    END
    ELSE
    BEGIN
        INSERT INTO cart_items (cart_id, dish_id, quantity)
        VALUES (@cart_id, @dish_id, @quantity);
    END;
END;
GO


/*
===========================================================
6. REMOVE FROM CART
===========================================================
*/
CREATE OR ALTER PROCEDURE remove_from_cart
    @cart_id BIGINT,
    @dish_id BIGINT
AS
BEGIN
    SET NOCOUNT ON;

    DELETE FROM cart_items
    WHERE cart_id = @cart_id AND dish_id = @dish_id;
END;
GO


/*
===========================================================
7. CREATE ORDER
   Converts the user's active cart into a full order.
   Calculates total from cart, creates the order, one suborder
   per the supplied branch, moves cart items to order_items,
   and marks the cart as ordered — all within a transaction.
===========================================================
*/
CREATE OR ALTER PROCEDURE create_order
    @user_id              BIGINT,
    @payment_method       VARCHAR(10),
    @delivery_address     VARCHAR(255),
    @restaurant_branch_id BIGINT,
    @contact_phone        VARCHAR(30)    = NULL,
    @delivery_fee         DECIMAL(10,2)  = 0.00
AS
BEGIN
    SET NOCOUNT ON;

    DECLARE @cart_id      BIGINT;
    DECLARE @total_price  DECIMAL(10,2);
    DECLARE @order_id     BIGINT;
    DECLARE @suborder_id  BIGINT;

    SELECT @cart_id = id FROM carts WHERE user_id = @user_id AND status = 'active';

    IF @cart_id IS NULL
    BEGIN
        RAISERROR('No active cart found for this user.', 16, 1);
        RETURN;
    END;

    SELECT @total_price = SUM(ci.quantity * d.price)
    FROM cart_items ci
    JOIN dishes d ON ci.dish_id = d.id
    WHERE ci.cart_id = @cart_id;

    IF @total_price IS NULL OR @total_price = 0
    BEGIN
        RAISERROR('Cart is empty.', 16, 1);
        RETURN;
    END;

    SET @total_price = @total_price + ISNULL(@delivery_fee, 0);

    BEGIN TRY
        BEGIN TRANSACTION;

        INSERT INTO orders (user_id, total_price, payment_method, delivery_address, contact_phone, delivery_fee)
        VALUES (@user_id, @total_price, @payment_method, @delivery_address, @contact_phone, @delivery_fee);

        SET @order_id = SCOPE_IDENTITY();

        DECLARE @suborder_total DECIMAL(10,2);
        SELECT @suborder_total = SUM(ci.quantity * d.price)
        FROM cart_items ci
        JOIN dishes d ON ci.dish_id = d.id
        WHERE ci.cart_id = @cart_id;

        INSERT INTO suborders (order_id, restaurant_branch_id, total_price)
        VALUES (@order_id, @restaurant_branch_id, @suborder_total);

        SET @suborder_id = SCOPE_IDENTITY();

        INSERT INTO order_items (suborder_id, dish_id, quantity, price)
        SELECT @suborder_id, ci.dish_id, ci.quantity, d.price
        FROM cart_items ci
        JOIN dishes d ON ci.dish_id = d.id
        WHERE ci.cart_id = @cart_id;

        UPDATE carts
        SET status     = 'ordered',
            updated_at = GETDATE()
        WHERE id = @cart_id;

        COMMIT TRANSACTION;

        SELECT @order_id AS order_id;
    END TRY
    BEGIN CATCH
        ROLLBACK TRANSACTION;
        THROW;
    END CATCH;
END;
GO


/*
===========================================================
8. UPDATE ORDER STATUS
===========================================================
*/
CREATE OR ALTER PROCEDURE update_order_status
    @order_id BIGINT,
    @status   VARCHAR(20)
AS
BEGIN
    SET NOCOUNT ON;

    IF @status NOT IN ('pending', 'confirmed', 'preparing', 'completed', 'delivered', 'canceled')
    BEGIN
        RAISERROR('Invalid order status value.', 16, 1);
        RETURN;
    END;

    UPDATE orders
    SET status     = @status,
        updated_at = GETDATE()
    WHERE id = @order_id;
END;
GO


/*
===========================================================
9. GET RESTAURANT SUBORDERS
===========================================================
*/
CREATE OR ALTER PROCEDURE get_restaurant_suborders
    @restaurant_id BIGINT
AS
BEGIN
    SET NOCOUNT ON;

    SELECT
        s.id,
        s.order_id,
        s.restaurant_branch_id,
        s.status,
        s.total_price,
        s.created_at,
        rb.city    AS branch_city,
        rb.address AS branch_address
    FROM suborders s
    JOIN restaurant_branches rb ON s.restaurant_branch_id = rb.id
    WHERE rb.restaurant_id = @restaurant_id
      AND s.deleted_at IS NULL;
END;
GO


/*
===========================================================
10. UPDATE SUBORDER STATUS
===========================================================
*/
CREATE OR ALTER PROCEDURE update_suborder_status
    @suborder_id BIGINT,
    @status      VARCHAR(20)
AS
BEGIN
    SET NOCOUNT ON;

    IF @status NOT IN ('pending', 'confirmed', 'preparing', 'completed', 'delivered', 'canceled')
    BEGIN
        RAISERROR('Invalid suborder status value.', 16, 1);
        RETURN;
    END;

    UPDATE suborders
    SET status     = @status,
        updated_at = GETDATE()
    WHERE id = @suborder_id;
END;
GO


/*
===========================================================
11. ADD REVIEW
===========================================================
*/
CREATE OR ALTER PROCEDURE add_review
    @user_id BIGINT,
    @dish_id BIGINT,
    @rating  INT,
    @comment VARCHAR(MAX)
AS
BEGIN
    SET NOCOUNT ON;

    IF @rating NOT BETWEEN 1 AND 5
    BEGIN
        RAISERROR('Rating must be between 1 and 5.', 16, 1);
        RETURN;
    END;

    IF EXISTS (SELECT 1 FROM dish_reviews WHERE user_id = @user_id AND dish_id = @dish_id)
    BEGIN
        RAISERROR('User has already reviewed this dish.', 16, 1);
        RETURN;
    END;

    INSERT INTO dish_reviews (user_id, dish_id, rating, comment)
    VALUES (@user_id, @dish_id, @rating, @comment);
END;
GO


/*
===========================================================
12. GET DISH REVIEWS
===========================================================
*/
CREATE OR ALTER PROCEDURE get_dish_reviews
    @dish_id BIGINT
AS
BEGIN
    SET NOCOUNT ON;

    SELECT
        dr.id,
        dr.rating,
        dr.comment,
        dr.created_at,
        u.username,
        u.first_name,
        u.last_name
    FROM dish_reviews dr
    JOIN users u ON dr.user_id = u.id
    WHERE dr.dish_id = @dish_id
    ORDER BY dr.created_at DESC;
END;
GO


/*
===========================================================
13. CHECK ALLERGY RISK
===========================================================
*/
CREATE OR ALTER PROCEDURE check_allergy_risk
    @user_id BIGINT,
    @dish_id BIGINT
AS
BEGIN
    SET NOCOUNT ON;

    SELECT i.id, i.name
    FROM user_allergies ua
    JOIN dish_ingredients di ON ua.ingredient_id = di.ingredient_id
    JOIN ingredients i ON i.id = ua.ingredient_id
    WHERE ua.user_id = @user_id
      AND di.dish_id = @dish_id;
END;
GO


/*
===========================================================
14. ADD USER ALLERGY
===========================================================
*/
CREATE OR ALTER PROCEDURE add_user_allergy
    @user_id       BIGINT,
    @ingredient_id BIGINT
AS
BEGIN
    SET NOCOUNT ON;

    IF NOT EXISTS (
        SELECT 1 FROM user_allergies
        WHERE user_id = @user_id AND ingredient_id = @ingredient_id
    )
    BEGIN
        INSERT INTO user_allergies (user_id, ingredient_id)
        VALUES (@user_id, @ingredient_id);
    END;
END;
GO


/*
===========================================================
15. GET TOP DISHES
===========================================================
*/
CREATE OR ALTER PROCEDURE get_top_dishes
    @top_n INT = 10
AS
BEGIN
    SET NOCOUNT ON;

    SELECT TOP (@top_n)
        d.id,
        d.name,
        d.price,
        d.average_rating,
        d.reviews_count,
        r.name AS restaurant_name
    FROM dishes d
    JOIN restaurants r ON d.restaurant_id = r.id
    WHERE d.is_available = 1
      AND d.deleted_at IS NULL
    ORDER BY d.average_rating DESC, d.reviews_count DESC;
END;
GO


/*
===========================================================
16. GET RESTAURANT REVENUE
===========================================================
*/
CREATE OR ALTER PROCEDURE get_restaurant_revenue
    @restaurant_id BIGINT,
    @from_date     DATETIME = NULL,
    @to_date       DATETIME = NULL
AS
BEGIN
    SET NOCOUNT ON;

    SELECT ISNULL(SUM(s.total_price), 0) AS revenue
    FROM suborders s
    JOIN restaurant_branches rb ON s.restaurant_branch_id = rb.id
    WHERE rb.restaurant_id = @restaurant_id
      AND s.deleted_at IS NULL
      AND (@from_date IS NULL OR s.created_at >= @from_date)
      AND (@to_date   IS NULL OR s.created_at <= @to_date);
END;
GO


/*
===========================================================
17. GET ACTIVE USERS
===========================================================
*/
CREATE OR ALTER PROCEDURE get_active_users
AS
BEGIN
    SET NOCOUNT ON;

    SELECT
        u.id,
        u.username,
        u.email,
        COUNT(o.id) AS orders_count
    FROM orders o
    JOIN users u ON o.user_id = u.id
    GROUP BY u.id, u.username, u.email
    ORDER BY orders_count DESC;
END;
GO


/*
===========================================================
18. CLEAR CART
===========================================================
*/
CREATE OR ALTER PROCEDURE clear_cart
    @user_id BIGINT
AS
BEGIN
    SET NOCOUNT ON;

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
CREATE OR ALTER PROCEDURE add_to_wishlist
    @user_id BIGINT,
    @dish_id BIGINT
AS
BEGIN
    SET NOCOUNT ON;

    IF NOT EXISTS (SELECT 1 FROM wishlists WHERE user_id = @user_id AND dish_id = @dish_id)
    BEGIN
        INSERT INTO wishlists (user_id, dish_id)
        VALUES (@user_id, @dish_id);
    END;
END;
GO


/*
===========================================================
20. REMOVE FROM WISHLIST
===========================================================
*/
CREATE OR ALTER PROCEDURE remove_from_wishlist
    @user_id BIGINT,
    @dish_id BIGINT
AS
BEGIN
    SET NOCOUNT ON;

    DELETE FROM wishlists
    WHERE user_id = @user_id AND dish_id = @dish_id;
END;
GO


/*
===========================================================
21. GET FULL CART
===========================================================
*/
CREATE OR ALTER PROCEDURE get_full_cart
    @user_id BIGINT
AS
BEGIN
    SET NOCOUNT ON;

    SELECT
        d.id              AS dish_id,
        d.name            AS dish_name,
        d.image,
        ci.quantity,
        d.price           AS unit_price,
        ci.quantity * d.price AS line_total,
        r.name            AS restaurant_name
    FROM carts c
    JOIN cart_items ci ON c.id = ci.cart_id
    JOIN dishes d      ON ci.dish_id = d.id
    JOIN restaurants r ON d.restaurant_id = r.id
    WHERE c.user_id = @user_id
      AND c.status  = 'active';
END;
GO


/*
===========================================================
22. CHECK DISH AVAILABILITY
===========================================================
*/
CREATE OR ALTER PROCEDURE check_dish_availability
    @dish_id BIGINT
AS
BEGIN
    SET NOCOUNT ON;

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
CREATE OR ALTER PROCEDURE get_restaurant_stats
    @restaurant_id BIGINT,
    @from_date     DATETIME = NULL,
    @to_date       DATETIME = NULL
AS
BEGIN
    SET NOCOUNT ON;

    SELECT
        COUNT(DISTINCT s.id)          AS total_suborders,
        COUNT(DISTINCT s.order_id)    AS total_orders,
        ISNULL(SUM(s.total_price), 0) AS revenue
    FROM suborders s
    JOIN restaurant_branches rb ON s.restaurant_branch_id = rb.id
    WHERE rb.restaurant_id = @restaurant_id
      AND s.deleted_at IS NULL
      AND (@from_date IS NULL OR s.created_at >= @from_date)
      AND (@to_date   IS NULL OR s.created_at <= @to_date);
END;
GO


/*
===========================================================
24. GET POPULAR DISHES
===========================================================
*/
CREATE OR ALTER PROCEDURE get_popular_dishes
    @top_n INT = 10
AS
BEGIN
    SET NOCOUNT ON;

    SELECT TOP (@top_n)
        d.id,
        d.name,
        d.price,
        d.average_rating,
        COUNT(w.user_id) AS wishlist_count,
        r.name           AS restaurant_name
    FROM dishes d
    LEFT JOIN wishlists w ON d.id = w.dish_id
    JOIN restaurants r    ON d.restaurant_id = r.id
    WHERE d.deleted_at IS NULL
    GROUP BY d.id, d.name, d.price, d.average_rating, r.name
    ORDER BY wishlist_count DESC;
END;
GO


/*
===========================================================
25. GET ACTIVE ORDERS
===========================================================
*/
CREATE OR ALTER PROCEDURE get_active_orders
AS
BEGIN
    SET NOCOUNT ON;

    SELECT
        o.id,
        o.user_id,
        o.total_price,
        o.status,
        o.payment_method,
        o.delivery_address,
        o.created_at
    FROM orders o
    WHERE o.status IN ('pending', 'confirmed', 'preparing')
      AND o.deleted_at IS NULL
    ORDER BY o.created_at ASC;
END;
GO


/*
===========================================================
26. GET ORDERS BY RESTAURANT
===========================================================
*/
CREATE OR ALTER PROCEDURE get_orders_by_restaurant
    @restaurant_id BIGINT
AS
BEGIN
    SET NOCOUNT ON;

    SELECT DISTINCT
        o.id,
        o.user_id,
        o.total_price,
        o.status,
        o.payment_method,
        o.delivery_address,
        o.created_at
    FROM orders o
    JOIN suborders s ON o.id = s.order_id
    JOIN restaurant_branches rb ON s.restaurant_branch_id = rb.id
    WHERE rb.restaurant_id = @restaurant_id
      AND o.deleted_at IS NULL
    ORDER BY o.created_at DESC;
END;
GO


/*
===========================================================
27. CHECK USER EXISTS
===========================================================
*/
CREATE OR ALTER PROCEDURE check_user_exists
    @email VARCHAR(255)
AS
BEGIN
    SET NOCOUNT ON;

    SELECT CAST(COUNT(1) AS BIT) AS user_exists
    FROM users
    WHERE email = @email
      AND deleted_at IS NULL;
END;
GO


/*
===========================================================
28. GET DISH INGREDIENTS
===========================================================
*/
CREATE OR ALTER PROCEDURE get_dish_ingredients
    @dish_id BIGINT
AS
BEGIN
    SET NOCOUNT ON;

    SELECT
        i.id,
        i.name,
        i.unit,
        i.is_allergic,
        di.quantity
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
