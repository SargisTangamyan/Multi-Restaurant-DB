USE restaurant_project;

-- ========================================================
-- UPDATE updated_at TRIGGERS
-- ========================================================

CREATE TRIGGER trg_users_updated_at
    ON users
    AFTER UPDATE
    AS
BEGIN
    SET NOCOUNT ON;
    UPDATE users
    SET updated_at = GETDATE()
    FROM users u
             INNER JOIN inserted i ON u.id = i.id;
END;
GO

CREATE TRIGGER trg_restaurants_updated_at
    ON restaurants
    AFTER UPDATE
    AS
BEGIN
    SET NOCOUNT ON;
    UPDATE restaurants
    SET updated_at = GETDATE()
    FROM restaurants r
             INNER JOIN inserted i ON r.id = i.id;
END;
GO

CREATE TRIGGER trg_restaurant_branches_updated_at
    ON restaurant_branches
    AFTER UPDATE
    AS
BEGIN
    SET NOCOUNT ON;
    UPDATE restaurant_branches
    SET updated_at = GETDATE()
    FROM restaurant_branches r
             INNER JOIN inserted i ON r.id = i.id;
END;
GO

CREATE TRIGGER trg_restaurant_staffs_updated_at
    ON restaurant_staffs
    AFTER UPDATE
    AS
BEGIN
    SET NOCOUNT ON;
    UPDATE restaurant_staffs
    SET updated_at = GETDATE()
    FROM restaurant_staffs r
             INNER JOIN inserted i ON r.id = i.id;
END;
GO

CREATE TRIGGER trg_categories_updated_at
    ON categories
    AFTER UPDATE
    AS
BEGIN
    SET NOCOUNT ON;
    UPDATE categories
    SET updated_at = GETDATE()
    FROM categories c
             INNER JOIN inserted i ON c.id = i.id;
END;
GO

CREATE TRIGGER trg_dishes_updated_at
    ON dishes
    AFTER UPDATE
    AS
BEGIN
    SET NOCOUNT ON;
    UPDATE dishes
    SET updated_at = GETDATE()
    FROM dishes d
             INNER JOIN inserted i ON d.id = i.id;
END;
GO

CREATE TRIGGER trg_orders_updated_at
    ON orders
    AFTER UPDATE
    AS
BEGIN
    SET NOCOUNT ON;
    UPDATE orders
    SET updated_at = GETDATE()
    FROM orders o
             INNER JOIN inserted i ON o.id = i.id;
END;
GO

CREATE TRIGGER trg_suborders_updated_at
    ON suborders
    AFTER UPDATE
    AS
BEGIN
    SET NOCOUNT ON;
    UPDATE suborders
    SET updated_at = GETDATE()
    FROM suborders s
             INNER JOIN inserted i ON s.id = i.id;
END;
GO

CREATE TRIGGER trg_dish_reviews_updated_at
    ON dish_reviews
    AFTER UPDATE
    AS
BEGIN
    SET NOCOUNT ON;
    UPDATE dish_reviews
    SET updated_at = GETDATE()
    FROM dish_reviews d
             INNER JOIN inserted i ON d.id = i.id;
END;
GO

CREATE TRIGGER trg_carts_updated_at
    ON carts
    AFTER UPDATE
    AS
BEGIN
    SET NOCOUNT ON;
    UPDATE carts
    SET updated_at = GETDATE()
    FROM carts c
             INNER JOIN inserted i ON c.id = i.id;
END;
GO

CREATE TRIGGER trg_cart_items_updated_at
    ON cart_items
    AFTER UPDATE
    AS
BEGIN
    SET NOCOUNT ON;
    UPDATE cart_items
    SET updated_at = GETDATE()
    FROM cart_items c
             INNER JOIN inserted i ON c.id = i.id;
END;
GO

CREATE TRIGGER trg_ingredients_updated_at
    ON ingredients
    AFTER UPDATE
    AS
BEGIN
    SET NOCOUNT ON;
    UPDATE ingredients
    SET updated_at = GETDATE()
    FROM ingredients n
             INNER JOIN inserted i ON n.id = i.id;
END;
GO

-- ========================================================
-- SOFT DELETE TRIGGERS
-- ========================================================

-- Soft-delete restaurants, staff, and orders when user is soft-deleted
CREATE TRIGGER trg_softdelete_user
    ON users
    AFTER UPDATE
    AS
BEGIN
    SET NOCOUNT ON;
    IF EXISTS (SELECT 1 FROM inserted WHERE deleted_at IS NOT NULL)
        BEGIN
            -- Soft-delete restaurants owned by user
            UPDATE r
            SET deleted_at = GETDATE()
            FROM restaurants r
                     JOIN inserted i ON r.owner_id = i.id
            WHERE i.deleted_at IS NOT NULL
              AND r.deleted_at IS NULL;

            -- Soft-delete staff memberships of user
            UPDATE rs
            SET deleted_at = GETDATE()
            FROM restaurant_staffs rs
                     JOIN inserted i ON rs.user_id = i.id
            WHERE i.deleted_at IS NOT NULL
              AND rs.deleted_at IS NULL;

            -- Soft-delete orders
            UPDATE o
            SET deleted_at = GETDATE()
            FROM orders o
                     JOIN inserted i ON o.user_id = i.id
            WHERE i.deleted_at IS NOT NULL
              AND o.deleted_at IS NULL;
        END
END;
GO

-- Soft-delete restaurant branches, dishes, and staff when restaurant is soft-deleted
CREATE TRIGGER trg_softdelete_restaurant
    ON restaurants
    AFTER UPDATE
    AS
BEGIN
    SET NOCOUNT ON;
    IF EXISTS (SELECT 1 FROM inserted WHERE deleted_at IS NOT NULL)
        BEGIN
            -- Soft-delete branches
            UPDATE rb
            SET deleted_at = GETDATE()
            FROM restaurant_branches rb
                     JOIN inserted i ON rb.restaurant_id = i.id
            WHERE i.deleted_at IS NOT NULL
              AND rb.deleted_at IS NULL;

            -- Soft-delete dishes
            UPDATE d
            SET deleted_at = GETDATE()
            FROM dishes d
                     JOIN inserted i ON d.restaurant_id = i.id
            WHERE i.deleted_at IS NOT NULL
              AND d.deleted_at IS NULL;

            -- Soft-delete staff
            UPDATE rs
            SET deleted_at = GETDATE()
            FROM restaurant_staffs rs
                     JOIN inserted i ON rs.restaurant_id = i.id
            WHERE i.deleted_at IS NOT NULL
              AND rs.deleted_at IS NULL;
        END
END;
GO

-- Note: No soft-delete for branches as it doesn't have child tables with deleted_at.
-- Note: No soft-delete for suborders as it doesn't have deleted_at.
-- Note: No soft-delete for dishes child tables as they don't have deleted_at.

-- ========================================================
-- DISH AVAILABILITY TRIGGERS
-- ========================================================

-- Remove from active carts when a dish becomes unavailable (is_available = 0)
CREATE TRIGGER trg_dish_unavailable
    ON dishes
    AFTER UPDATE
    AS
BEGIN
    SET NOCOUNT ON;
    IF EXISTS (SELECT 1 FROM inserted WHERE is_available = 0)
        BEGIN
            DELETE ci
            FROM cart_items ci
                     JOIN inserted i ON ci.dish_id = i.id
            WHERE i.is_available = 0;
        END
END;
GO

-- Prevent adding unavailable dishes to cart
CREATE TRIGGER trg_cart_check
    ON cart_items
    INSTEAD OF INSERT
    AS
BEGIN
    SET NOCOUNT ON;
    IF EXISTS (SELECT 1
               FROM inserted i
                        JOIN dishes d ON i.dish_id = d.id
               WHERE d.is_available = 0)
        BEGIN
            RAISERROR ('Dish not available', 16, 1);
            RETURN;
        END;

    INSERT INTO cart_items(cart_id, dish_id, quantity)
    SELECT cart_id, dish_id, quantity
    FROM inserted;
END;
GO

-- ========================================================
-- CALCULATION TRIGGERS
-- ========================================================

-- Update dish average rating and reviews count
CREATE TRIGGER trg_update_rating
    ON dish_reviews
    AFTER INSERT, UPDATE, DELETE
    AS
BEGIN
    SET NOCOUNT ON;
    UPDATE d
    SET average_rating = ISNULL(
            (SELECT AVG(CAST(r.rating AS DECIMAL(2, 1)))
             FROM dish_reviews r
             WHERE r.dish_id = d.id), 0),
        reviews_count  = (SELECT COUNT(*)
                          FROM dish_reviews r
                          WHERE r.dish_id = d.id)
    FROM dishes d
    WHERE d.id IN (SELECT dish_id
                   FROM inserted
                   UNION
                   SELECT dish_id
                   FROM deleted);
END;
GO

-- Update suborder total price
CREATE TRIGGER trg_suborder_total
    ON order_items
    AFTER INSERT, UPDATE, DELETE
    AS
BEGIN
    SET NOCOUNT ON;
    UPDATE s
    SET total_price = (SELECT ISNULL(SUM(quantity * price), 0)
                       FROM order_items oi
                       WHERE oi.suborder_id = s.id)
    FROM suborders s
    WHERE s.id IN (SELECT suborder_id
                   FROM inserted
                   UNION
                   SELECT suborder_id
                   FROM deleted);
END;
GO

-- Update order total price when suborder price changes
CREATE TRIGGER trg_order_total
    ON suborders
    AFTER UPDATE
    AS
BEGIN
    SET NOCOUNT ON;
    UPDATE o
    SET total_price = (SELECT ISNULL(SUM(s.total_price), 0)
                       FROM suborders s
                       WHERE s.order_id = o.id)
    FROM orders o
    WHERE o.id IN (SELECT order_id
                   FROM inserted
                   UNION
                   SELECT order_id
                   FROM deleted);
END;
GO