USE restaurant_project;
GO

ALTER TABLE suborders
    ADD deleted_at DATETIME NULL;

ALTER TABLE order_items
    ADD
        created_at DATETIME DEFAULT GETDATE(),
        updated_at DATETIME DEFAULT GETDATE(),
        deleted_at DATETIME NULL;

SELECT * FROM order_items;

UPDATE order_items
SET created_at = GETDATE(),
    updated_at = GETDATE();


-- Drop FK only if it exists
-- !!!!!!!!!!!!!!!!!!!!! - FK__order_ite__resta__2FCF1A8A is
--  a constraint name in my db, the name in yours will be different
IF EXISTS (
    SELECT 1
    FROM sys.foreign_keys
    WHERE name = 'FK__order_ite__resta__2FCF1A8A'
)
    BEGIN
        ALTER TABLE order_items
            DROP CONSTRAINT FK__order_ite__resta__2FCF1A8A;
    END
GO

-- Drop column only if it exists
IF EXISTS (
    SELECT 1
    FROM sys.columns
    WHERE Name = 'restaurant_branch_id'
      AND Object_ID = Object_ID('order_items')
)
    BEGIN
        ALTER TABLE order_items
            DROP COLUMN restaurant_branch_id;
    END
GO

/*
===========================================================
STEP 1. DROP OLD INDEXES (SAFE)
===========================================================
*/

IF EXISTS (SELECT 1 FROM sys.indexes WHERE name = 'idx_users_deleted_at')
    DROP INDEX idx_users_deleted_at ON users;

IF EXISTS (SELECT 1 FROM sys.indexes WHERE name = 'idx_restaurants_deleted_at')
    DROP INDEX idx_restaurants_deleted_at ON restaurants;

IF EXISTS (SELECT 1 FROM sys.indexes WHERE name = 'idx_branches_deleted_at')
    DROP INDEX idx_branches_deleted_at ON restaurant_branches;

IF EXISTS (SELECT 1 FROM sys.indexes WHERE name = 'idx_staff_deleted_at')
    DROP INDEX idx_staff_deleted_at ON restaurant_staffs;

IF EXISTS (SELECT 1 FROM sys.indexes WHERE name = 'idx_categories_deleted_at')
    DROP INDEX idx_categories_deleted_at ON categories;

IF EXISTS (SELECT 1 FROM sys.indexes WHERE name = 'idx_dishes_restaurant_name')
    DROP INDEX idx_dishes_restaurant_name ON dishes;

IF EXISTS (SELECT 1 FROM sys.indexes WHERE name = 'idx_dishes_category')
    DROP INDEX idx_dishes_category ON dishes;

IF EXISTS (SELECT 1 FROM sys.indexes WHERE name = 'idx_dishes_deleted_at')
    DROP INDEX idx_dishes_deleted_at ON dishes;

IF EXISTS (SELECT 1 FROM sys.indexes WHERE name = 'idx_orders_user')
    DROP INDEX idx_orders_user ON orders;

IF EXISTS (SELECT 1 FROM sys.indexes WHERE name = 'idx_orders_deleted_at')
    DROP INDEX idx_orders_deleted_at ON orders;

IF EXISTS (SELECT 1 FROM sys.indexes WHERE name = 'idx_suborders_order')
    DROP INDEX idx_suborders_order ON suborders;

IF EXISTS (SELECT 1 FROM sys.indexes WHERE name = 'idx_reviews_dish')
    DROP INDEX idx_reviews_dish ON dish_reviews;

GO