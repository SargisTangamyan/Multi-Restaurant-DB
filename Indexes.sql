/*
===========================================================
INDEX OPTIMIZATION SCRIPT
Multi-Restaurant Food Ordering System
===========================================================

IMPORTANT:
Run this script after creating tables and inserting data.

===========================================================
*/

USE restaurant_project;
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


/*
===========================================================
STEP 2. CREATE OPTIMIZED INDEXES
===========================================================
*/


/*
-----------------------------------------------------------
USERS
-----------------------------------------------------------
*/

-- Fast lookup by email (login / authentication)
CREATE INDEX idx_users_email 
ON users(email);

-- Filter users by role (admin, customer, restaurant)
CREATE INDEX idx_users_role 
ON users(role);



/*
-----------------------------------------------------------
RESTAURANTS
-----------------------------------------------------------
*/

-- Get restaurants owned by a user
CREATE INDEX idx_restaurants_owner 
ON restaurants(owner_id);

-- Search restaurants by name
CREATE INDEX idx_restaurants_name 
ON restaurants(name);



/*
-----------------------------------------------------------
RESTAURANT BRANCHES
-----------------------------------------------------------
*/

-- Retrieve branches of a restaurant
CREATE INDEX idx_branches_restaurant 
ON restaurant_branches(restaurant_id);

-- Search/filter branches by city
CREATE INDEX idx_branches_city 
ON restaurant_branches(city);



/*
-----------------------------------------------------------
RESTAURANT STAFF
-----------------------------------------------------------
*/

-- Find staff by restaurant
CREATE INDEX idx_staff_restaurant 
ON restaurant_staffs(restaurant_id);

-- Find restaurants assigned to a user
CREATE INDEX idx_staff_user 
ON restaurant_staffs(user_id);



/*
-----------------------------------------------------------
CATEGORIES
-----------------------------------------------------------
*/

-- Hierarchical queries (parent-child structure)
CREATE INDEX idx_categories_parent 
ON categories(parent_id);



/*
-----------------------------------------------------------
DISHES
-----------------------------------------------------------
*/

-- Filter dishes by category
CREATE INDEX idx_dishes_category 
ON dishes(category_id);

-- Get dishes of a specific restaurant
CREATE INDEX idx_dishes_restaurant 
ON dishes(restaurant_id);

-- Get popular dishes per restaurant (sorted)
CREATE INDEX idx_dishes_restaurant_rating 
ON dishes(restaurant_id, average_rating DESC);

-- Filter only available dishes
CREATE INDEX idx_dishes_available 
ON dishes(is_available);



/*
-----------------------------------------------------------
CARTS
-----------------------------------------------------------
*/

-- Optimize joins with users
CREATE INDEX idx_carts_user 
ON carts(user_id);



/*
-----------------------------------------------------------
CART ITEMS
-----------------------------------------------------------
*/

-- Get items inside a cart
CREATE INDEX idx_cart_items_cart 
ON cart_items(cart_id);

-- Find carts containing specific dish
CREATE INDEX idx_cart_items_dish 
ON cart_items(dish_id);



/*
-----------------------------------------------------------
INGREDIENTS
-----------------------------------------------------------
*/

-- Filter allergenic ingredients
CREATE INDEX idx_ingredients_allergic 
ON ingredients(is_allergic);



/*
-----------------------------------------------------------
DISH INGREDIENTS
-----------------------------------------------------------
*/

-- Get ingredients of a dish
CREATE INDEX idx_dish_ingredients_dish 
ON dish_ingredients(dish_id);

-- Find dishes containing an ingredient
CREATE INDEX idx_dish_ingredients_ingredient 
ON dish_ingredients(ingredient_id);



/*
-----------------------------------------------------------
USER ALLERGIES
-----------------------------------------------------------
*/

-- Get allergies of a user
CREATE INDEX idx_user_allergies_user 
ON user_allergies(user_id);

-- Find users allergic to ingredient
CREATE INDEX idx_user_allergies_ingredient 
ON user_allergies(ingredient_id);



/*
-----------------------------------------------------------
ORDERS
-----------------------------------------------------------
*/

-- Get user orders sorted by newest
CREATE INDEX idx_orders_user_created 
ON orders(user_id, created_at DESC);

-- Filter orders by status
CREATE INDEX idx_orders_status 
ON orders(status);

-- Global sorting of recent orders
CREATE INDEX idx_orders_created 
ON orders(created_at DESC);



/*
-----------------------------------------------------------
SUBORDERS
-----------------------------------------------------------
*/

-- Get suborders of an order
CREATE INDEX idx_suborders_order 
ON suborders(order_id);

-- Get suborders by branch
CREATE INDEX idx_suborders_branch 
ON suborders(restaurant_branch_id);

-- Filter suborders by status
CREATE INDEX idx_suborders_status 
ON suborders(status);



/*
-----------------------------------------------------------
ORDER ITEMS
-----------------------------------------------------------
*/

-- Get items of a suborder
CREATE INDEX idx_order_items_suborder 
ON order_items(suborder_id);

-- Search order items by dish
CREATE INDEX idx_order_items_dish 
ON order_items(dish_id);

-- Join optimization with branches
-- CREATE INDEX idx_order_items_branch
-- ON order_items(restaurant_branch_id);



/*
-----------------------------------------------------------
DISH REVIEWS
-----------------------------------------------------------
*/

-- Get reviews for a dish
CREATE INDEX idx_reviews_dish 
ON dish_reviews(dish_id);

-- Get reviews written by a user
CREATE INDEX idx_reviews_user 
ON dish_reviews(user_id);

-- Sort/filter by rating
CREATE INDEX idx_reviews_rating 
ON dish_reviews(rating);



/*
-----------------------------------------------------------
WISHLISTS
-----------------------------------------------------------
*/

-- Get wishlist of a user
CREATE INDEX idx_wishlist_user 
ON wishlists(user_id);

-- Find popular dishes in wishlists
CREATE INDEX idx_wishlist_dish 
ON wishlists(dish_id);

/*
