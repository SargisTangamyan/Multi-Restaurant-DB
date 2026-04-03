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
STEP 2. CREATE OPTIMIZED INDEXES
===========================================================
*/


/*
-----------------------------------------------------------
USERS
-----------------------------------------------------------
*/

-- Filter active users
CREATE INDEX idx_users_active
    ON users (email, role)
    WHERE deleted_at IS NULL;

/*
-----------------------------------------------------------
RESTAURANTS
-----------------------------------------------------------
*/

-- Get restaurants owned by a user
CREATE INDEX idx_restaurants_owner
    ON restaurants (owner_id);

-- Search restaurants by name
CREATE INDEX idx_restaurants_name
    ON restaurants (name);

-- Filter active restaurants
CREATE INDEX idx_restaurants_active
    ON restaurants (owner_id, name)
    WHERE deleted_at IS NULL;

/*
-----------------------------------------------------------
RESTAURANT BRANCHES
-----------------------------------------------------------
*/

-- Retrieve branches of a restaurant
CREATE INDEX idx_branches_restaurant
    ON restaurant_branches (restaurant_id);

-- Search/filter branches by city
CREATE INDEX idx_branches_city
    ON restaurant_branches (city);

CREATE INDEX idx_branches_active
    ON restaurant_branches (restaurant_id, city)
    WHERE deleted_at IS NULL;

/*
-----------------------------------------------------------
RESTAURANT STAFF
-----------------------------------------------------------
*/

-- Find staff by restaurant
CREATE INDEX idx_staff_restaurant
    ON restaurant_staffs (restaurant_id);

-- Filter active staff with their roles
CREATE INDEX idx_staff_active
    ON restaurant_staffs (restaurant_id, role)
    WHERE deleted_at IS NULL;

-- Find restaurants assigned to a user
CREATE INDEX idx_staff_user
    ON restaurant_staffs (user_id);



/*
-----------------------------------------------------------
CATEGORIES
-----------------------------------------------------------
*/

-- Hierarchical queries (parent-child structure)
CREATE INDEX idx_categories_parent
    ON categories (parent_id);



/*
-----------------------------------------------------------
DISHES
-----------------------------------------------------------
*/

-- For Search Engine
CREATE INDEX idx_dishes_name ON dishes (name);

-- Filter dishes by category
CREATE INDEX idx_dishes_category
    ON dishes (category_id);

-- Get dishes of a specific restaurant
CREATE INDEX idx_dishes_restaurant
    ON dishes (restaurant_id);

-- Get popular dishes per restaurant (sorted)
CREATE INDEX idx_dishes_restaurant_rating
    ON dishes (restaurant_id, average_rating DESC);

-- Dishes with unique names per restaurant
CREATE UNIQUE INDEX idx_dishes_restaurant_name
    ON dishes (restaurant_id, name);

-- Filter dishes by id that are available and not soft-deleted
CREATE INDEX idx_dishes_restaurant_available
    ON dishes (restaurant_id, is_available)
    WHERE deleted_at IS NULL;

-- Filter dishes by category that are available and not soft-deleted
CREATE INDEX idx_dishes_category_available_deleted
    ON dishes (category_id, is_available)
    WHERE deleted_at IS NULL;

CREATE INDEX idx_dishes_slug ON dishes(slug);


/*
-----------------------------------------------------------
CART ITEMS
-----------------------------------------------------------
*/

-- Get items inside a cart
CREATE INDEX idx_cart_items_cart
    ON cart_items (cart_id);

-- Find carts containing specific dish
CREATE INDEX idx_cart_items_dish
    ON cart_items (dish_id);



/*
-----------------------------------------------------------
DISH INGREDIENTS
-----------------------------------------------------------
*/

-- Get ingredients of a dish
CREATE INDEX idx_dish_ingredients_dish
    ON dish_ingredients (dish_id);

-- Find dishes containing an ingredient
CREATE INDEX idx_dish_ingredients_ingredient
    ON dish_ingredients (ingredient_id);



/*
-----------------------------------------------------------
USER ALLERGIES
-----------------------------------------------------------
*/

-- Get allergies of a user
CREATE INDEX idx_user_allergies_user
    ON user_allergies (user_id);

-- Find users allergic to ingredient
CREATE INDEX idx_user_allergies_ingredient
    ON user_allergies (ingredient_id);



/*
-----------------------------------------------------------
ORDERS
-----------------------------------------------------------
*/

-- Filter active orders
CREATE INDEX idx_orders_active
    ON orders (user_id, status, created_at DESC)
    WHERE deleted_at IS NULL;

CREATE INDEX idx_orders_created
    ON orders (created_at DESC);

/*
-----------------------------------------------------------
SUBORDERS
-----------------------------------------------------------
*/

-- Get suborders of an order with the status
CREATE INDEX idx_suborders_order_status
    ON suborders (order_id, status);

-- Get suborders by branch
CREATE INDEX idx_suborders_branch
    ON suborders (restaurant_branch_id);

-- Filter suborders by branch and status, sorted by newest
CREATE INDEX idx_suborders_branch_status_created
    ON suborders (restaurant_branch_id, status, created_at DESC);

/*
-----------------------------------------------------------
ORDER ITEMS
-----------------------------------------------------------
*/

-- Search order items by dish
CREATE INDEX idx_order_items_dish
    ON order_items (dish_id);

-- Get items of a suborder and dish
CREATE INDEX idx_order_items_suborder_dish
    ON order_items (suborder_id, dish_id);

/*
-----------------------------------------------------------
DISH REVIEWS
-----------------------------------------------------------
*/

-- Get reviews for a dish
CREATE INDEX idx_reviews_dish
    ON dish_reviews (dish_id);



/*
-----------------------------------------------------------
WISHLISTS
-----------------------------------------------------------
*/

-- Get wishlist of a user
CREATE INDEX idx_wishlist_user
    ON wishlists (user_id);

-- Find popular dishes in wishlists
CREATE INDEX idx_wishlist_dish
    ON wishlists (dish_id);

/*
