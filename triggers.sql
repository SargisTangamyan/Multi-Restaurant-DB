USE restaurant_project;
GO

-- ========================================================
-- UPDATE updated_at TRIGGERS
-- ========================================================

CREATE OR ALTER TRIGGER trg_users_updated_at
    ON users
    AFTER UPDATE
AS
BEGIN
    SET NOCOUNT ON;
    IF TRIGGER_NESTLEVEL() > 1 RETURN;

    UPDATE u
    SET updated_at = GETDATE()
    FROM users u
    INNER JOIN inserted i ON u.id = i.id;
END;
GO

CREATE OR ALTER TRIGGER trg_restaurants_updated_at
    ON restaurants
    AFTER UPDATE
AS
BEGIN
    SET NOCOUNT ON;
    IF TRIGGER_NESTLEVEL() > 1 RETURN;

    UPDATE r
    SET updated_at = GETDATE()
    FROM restaurants r
    INNER JOIN inserted i ON r.id = i.id;
END;
GO

CREATE OR ALTER TRIGGER trg_restaurant_branches_updated_at
    ON restaurant_branches
    AFTER UPDATE
AS
BEGIN
    SET NOCOUNT ON;
    IF TRIGGER_NESTLEVEL() > 1 RETURN;

    UPDATE rb
    SET updated_at = GETDATE()
    FROM restaurant_branches rb
    INNER JOIN inserted i ON rb.id = i.id;
END;
GO

CREATE OR ALTER TRIGGER trg_restaurant_staffs_updated_at
    ON restaurant_staffs
    AFTER UPDATE
AS
BEGIN
    SET NOCOUNT ON;
    IF TRIGGER_NESTLEVEL() > 1 RETURN;

    UPDATE rs
    SET updated_at = GETDATE()
    FROM restaurant_staffs rs
    INNER JOIN inserted i ON rs.id = i.id;
END;
GO

CREATE OR ALTER TRIGGER trg_categories_updated_at
    ON categories
    AFTER UPDATE
AS
BEGIN
    SET NOCOUNT ON;
    IF TRIGGER_NESTLEVEL() > 1 RETURN;

    UPDATE c
    SET updated_at = GETDATE()
    FROM categories c
    INNER JOIN inserted i ON c.id = i.id;
END;
GO

CREATE OR ALTER TRIGGER trg_dishes_updated_at
    ON dishes
    AFTER UPDATE
AS
BEGIN
    SET NOCOUNT ON;
    IF TRIGGER_NESTLEVEL() > 1 RETURN;

    UPDATE d
    SET updated_at = GETDATE()
    FROM dishes d
    INNER JOIN inserted i ON d.id = i.id;
END;
GO

CREATE OR ALTER TRIGGER trg_orders_updated_at
    ON orders
    AFTER UPDATE
AS
BEGIN
    SET NOCOUNT ON;
    IF TRIGGER_NESTLEVEL() > 1 RETURN;

    UPDATE o
    SET updated_at = GETDATE()
    FROM orders o
    INNER JOIN inserted i ON o.id = i.id;
END;
GO

CREATE OR ALTER TRIGGER trg_suborders_updated_at
    ON suborders
    AFTER UPDATE
AS
BEGIN
    SET NOCOUNT ON;
    IF TRIGGER_NESTLEVEL() > 1 RETURN;

    UPDATE s
    SET updated_at = GETDATE()
    FROM suborders s
    INNER JOIN inserted i ON s.id = i.id;
END;
GO

CREATE OR ALTER TRIGGER trg_order_items_updated_at
    ON order_items
    AFTER UPDATE
AS
BEGIN
    SET NOCOUNT ON;
    IF TRIGGER_NESTLEVEL() > 1 RETURN;

    UPDATE oi
    SET updated_at = GETDATE()
    FROM order_items oi
    INNER JOIN inserted i ON oi.id = i.id;
END;
GO

CREATE OR ALTER TRIGGER trg_dish_reviews_updated_at
    ON dish_reviews
    AFTER UPDATE
AS
BEGIN
    SET NOCOUNT ON;
    IF TRIGGER_NESTLEVEL() > 1 RETURN;

    UPDATE dr
    SET updated_at = GETDATE()
    FROM dish_reviews dr
    INNER JOIN inserted i ON dr.id = i.id;
END;
GO

CREATE OR ALTER TRIGGER trg_carts_updated_at
    ON carts
    AFTER UPDATE
AS
BEGIN
    SET NOCOUNT ON;
    IF TRIGGER_NESTLEVEL() > 1 RETURN;

    UPDATE c
    SET updated_at = GETDATE()
    FROM carts c
    INNER JOIN inserted i ON c.id = i.id;
END;
GO

CREATE OR ALTER TRIGGER trg_cart_items_updated_at
    ON cart_items
    AFTER UPDATE
AS
BEGIN
    SET NOCOUNT ON;
    IF TRIGGER_NESTLEVEL() > 1 RETURN;

    UPDATE ci
    SET updated_at = GETDATE()
    FROM cart_items ci
    INNER JOIN inserted i ON ci.id = i.id;
END;
GO

CREATE OR ALTER TRIGGER trg_ingredients_updated_at
    ON ingredients
    AFTER UPDATE
AS
BEGIN
    SET NOCOUNT ON;
    IF TRIGGER_NESTLEVEL() > 1 RETURN;

    UPDATE ing
    SET updated_at = GETDATE()
    FROM ingredients ing
    INNER JOIN inserted i ON ing.id = i.id;
END;
GO


-- ========================================================
-- SOFT DELETE TRIGGERS
-- ========================================================

CREATE OR ALTER TRIGGER trg_softdelete_user
    ON users
    AFTER UPDATE
AS
BEGIN
    SET NOCOUNT ON;

    IF NOT EXISTS (
        SELECT 1 FROM inserted i
        JOIN deleted d ON d.id = i.id
        WHERE d.deleted_at IS NULL AND i.deleted_at IS NOT NULL
    ) RETURN;

    UPDATE r
    SET deleted_at = GETDATE()
    FROM restaurants r
    JOIN inserted i ON r.owner_id = i.id
    WHERE i.deleted_at IS NOT NULL AND r.deleted_at IS NULL;

    UPDATE rs
    SET deleted_at = GETDATE()
    FROM restaurant_staffs rs
    JOIN inserted i ON rs.user_id = i.id
    WHERE i.deleted_at IS NOT NULL AND rs.deleted_at IS NULL;

    UPDATE o
    SET deleted_at = GETDATE()
    FROM orders o
    JOIN inserted i ON o.user_id = i.id
    WHERE i.deleted_at IS NOT NULL AND o.deleted_at IS NULL;

    UPDATE so
    SET deleted_at = GETDATE()
    FROM suborders so
    JOIN orders o ON so.order_id = o.id
    JOIN inserted i ON o.user_id = i.id
    WHERE i.deleted_at IS NOT NULL AND so.deleted_at IS NULL;

    UPDATE oi
    SET deleted_at = GETDATE()
    FROM order_items oi
    JOIN suborders so ON oi.suborder_id = so.id
    JOIN orders o ON so.order_id = o.id
    JOIN inserted i ON o.user_id = i.id
    WHERE i.deleted_at IS NOT NULL AND oi.deleted_at IS NULL;
END;
GO

CREATE OR ALTER TRIGGER trg_softdelete_restaurant
    ON restaurants
    AFTER UPDATE
AS
BEGIN
    SET NOCOUNT ON;

    IF NOT EXISTS (
        SELECT 1 FROM inserted i
        JOIN deleted d ON d.id = i.id
        WHERE d.deleted_at IS NULL AND i.deleted_at IS NOT NULL
    ) RETURN;

    UPDATE rb
    SET deleted_at = GETDATE()
    FROM restaurant_branches rb
    JOIN inserted i ON rb.restaurant_id = i.id
    WHERE i.deleted_at IS NOT NULL AND rb.deleted_at IS NULL;

    UPDATE d
    SET deleted_at = GETDATE()
    FROM dishes d
    JOIN inserted i ON d.restaurant_id = i.id
    WHERE i.deleted_at IS NOT NULL AND d.deleted_at IS NULL;

    UPDATE rs
    SET deleted_at = GETDATE()
    FROM restaurant_staffs rs
    JOIN inserted i ON rs.restaurant_id = i.id
    WHERE i.deleted_at IS NOT NULL AND rs.deleted_at IS NULL;

    UPDATE so
    SET deleted_at = GETDATE()
    FROM suborders so
    JOIN restaurant_branches rb ON so.restaurant_branch_id = rb.id
    JOIN inserted i ON rb.restaurant_id = i.id
    WHERE i.deleted_at IS NOT NULL AND so.deleted_at IS NULL;

    UPDATE oi
    SET deleted_at = GETDATE()
    FROM order_items oi
    JOIN suborders so ON oi.suborder_id = so.id
    JOIN restaurant_branches rb ON so.restaurant_branch_id = rb.id
    JOIN inserted i ON rb.restaurant_id = i.id
    WHERE i.deleted_at IS NOT NULL AND oi.deleted_at IS NULL;
END;
GO

CREATE OR ALTER TRIGGER trg_softdelete_restaurant_branch
    ON restaurant_branches
    AFTER UPDATE
AS
BEGIN
    SET NOCOUNT ON;

    IF NOT EXISTS (
        SELECT 1 FROM inserted i
        JOIN deleted d ON d.id = i.id
        WHERE d.deleted_at IS NULL AND i.deleted_at IS NOT NULL
    ) RETURN;

    UPDATE so
    SET deleted_at = GETDATE()
    FROM suborders so
    JOIN inserted i ON so.restaurant_branch_id = i.id
    WHERE i.deleted_at IS NOT NULL AND so.deleted_at IS NULL;

    UPDATE oi
    SET deleted_at = GETDATE()
    FROM order_items oi
    JOIN suborders so ON oi.suborder_id = so.id
    JOIN inserted i ON so.restaurant_branch_id = i.id
    WHERE i.deleted_at IS NOT NULL AND oi.deleted_at IS NULL;
END;
GO


-- ========================================================
-- DISH AVAILABILITY TRIGGERS
-- ========================================================

CREATE OR ALTER TRIGGER trg_dish_unavailable
    ON dishes
    AFTER UPDATE
AS
BEGIN
    SET NOCOUNT ON;

    -- Only act when availability or soft-delete status changed
    IF NOT (UPDATE(is_available) OR UPDATE(deleted_at)) RETURN;

    DELETE ci
    FROM cart_items ci
    JOIN inserted i ON ci.dish_id = i.id
    JOIN deleted d  ON d.id = i.id
    WHERE (d.is_available = 1 AND i.is_available = 0)
       OR (d.deleted_at IS NULL AND i.deleted_at IS NOT NULL);
END;
GO

CREATE OR ALTER TRIGGER trg_cart_check
    ON cart_items
    INSTEAD OF INSERT
AS
BEGIN
    SET NOCOUNT ON;

    IF EXISTS (
        SELECT 1
        FROM inserted i
        JOIN dishes d ON i.dish_id = d.id
        WHERE d.is_available = 0 OR d.deleted_at IS NOT NULL
    )
    BEGIN
        THROW 50001, 'One or more dishes are not available.', 1;
    END;

    INSERT INTO cart_items (cart_id, dish_id, quantity)
    SELECT cart_id, dish_id, quantity
    FROM inserted;
END;
GO


-- ========================================================
-- CALCULATION TRIGGERS
-- ========================================================

CREATE OR ALTER TRIGGER trg_update_rating
    ON dish_reviews
    AFTER INSERT, UPDATE, DELETE
AS
BEGIN
    SET NOCOUNT ON;

    WITH AffectedDishes AS (
        SELECT DISTINCT dish_id FROM inserted WHERE dish_id IS NOT NULL
        UNION
        SELECT DISTINCT dish_id FROM deleted  WHERE dish_id IS NOT NULL
    ),
    Aggregated AS (
        SELECT
            ad.dish_id,
            COALESCE(AVG(CAST(dr.rating AS DECIMAL(4,2))), 0) AS average_rating,
            COUNT(dr.id)                                       AS reviews_count
        FROM AffectedDishes ad
        LEFT JOIN dish_reviews dr ON dr.dish_id = ad.dish_id
        GROUP BY ad.dish_id
    )
    UPDATE d
    SET average_rating = a.average_rating,
        reviews_count  = a.reviews_count
    FROM dishes d
    INNER JOIN Aggregated a ON a.dish_id = d.id
    WHERE ISNULL(d.average_rating, 0) <> a.average_rating
       OR ISNULL(d.reviews_count,  0) <> a.reviews_count;
END;
GO

CREATE OR ALTER TRIGGER trg_suborder_total
    ON order_items
    AFTER INSERT, UPDATE, DELETE
AS
BEGIN
    SET NOCOUNT ON;

    -- Skip updates that don't affect the line total
    IF NOT (UPDATE(quantity) OR UPDATE(price) OR UPDATE(deleted_at)) RETURN;

    WITH AffectedSuborders AS (
        SELECT DISTINCT suborder_id FROM inserted WHERE suborder_id IS NOT NULL
        UNION
        SELECT DISTINCT suborder_id FROM deleted  WHERE suborder_id IS NOT NULL
    ),
    Totals AS (
        SELECT
            a.suborder_id,
            COALESCE(SUM(oi.quantity * oi.price), 0) AS total_price
        FROM AffectedSuborders a
        LEFT JOIN order_items oi ON oi.suborder_id = a.suborder_id
                                 AND oi.deleted_at IS NULL
        GROUP BY a.suborder_id
    )
    UPDATE s
    SET total_price = t.total_price
    FROM suborders s
    INNER JOIN Totals t ON t.suborder_id = s.id
    WHERE s.total_price <> t.total_price;
END;
GO

CREATE OR ALTER TRIGGER trg_order_total
    ON suborders
    AFTER INSERT, UPDATE, DELETE
AS
BEGIN
    SET NOCOUNT ON;

    -- Skip updates that don't affect the suborder total (e.g. updated_at only)
    IF NOT (UPDATE(total_price) OR UPDATE(deleted_at)) RETURN;

    WITH AffectedOrders AS (
        SELECT DISTINCT order_id FROM inserted WHERE order_id IS NOT NULL
        UNION
        SELECT DISTINCT order_id FROM deleted  WHERE order_id IS NOT NULL
    ),
    Totals AS (
        SELECT
            a.order_id,
            COALESCE(SUM(s.total_price), 0) AS total_price
        FROM AffectedOrders a
        LEFT JOIN suborders s ON s.order_id = a.order_id
                              AND s.deleted_at IS NULL
        GROUP BY a.order_id
    )
    UPDATE o
    SET total_price = t.total_price
    FROM orders o
    INNER JOIN Totals t ON t.order_id = o.id
    WHERE o.total_price <> t.total_price;
END;
GO
