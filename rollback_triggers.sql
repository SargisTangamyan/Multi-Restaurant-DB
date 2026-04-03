/*
===========================================================
ROLLBACK: Drop all triggers before re-running triggers.sql
Run this script first, then run triggers.sql
===========================================================
*/

USE restaurant_project;
GO

-- updated_at triggers
DROP TRIGGER IF EXISTS trg_users_updated_at;
DROP TRIGGER IF EXISTS trg_restaurants_updated_at;
DROP TRIGGER IF EXISTS trg_restaurant_branches_updated_at;
DROP TRIGGER IF EXISTS trg_restaurant_staffs_updated_at;
DROP TRIGGER IF EXISTS trg_categories_updated_at;
DROP TRIGGER IF EXISTS trg_dishes_updated_at;
DROP TRIGGER IF EXISTS trg_orders_updated_at;
DROP TRIGGER IF EXISTS trg_suborders_updated_at;
DROP TRIGGER IF EXISTS trg_order_items_updated_at;
DROP TRIGGER IF EXISTS trg_dish_reviews_updated_at;
DROP TRIGGER IF EXISTS trg_carts_updated_at;
DROP TRIGGER IF EXISTS trg_cart_items_updated_at;
DROP TRIGGER IF EXISTS trg_ingredients_updated_at;

-- soft delete triggers
DROP TRIGGER IF EXISTS trg_softdelete_user;
DROP TRIGGER IF EXISTS trg_softdelete_restaurant;
DROP TRIGGER IF EXISTS trg_softdelete_restaurant_branch;

-- availability triggers
DROP TRIGGER IF EXISTS trg_dish_unavailable;
DROP TRIGGER IF EXISTS trg_cart_check;

-- calculation triggers
DROP TRIGGER IF EXISTS trg_update_rating;
DROP TRIGGER IF EXISTS trg_suborder_total;
DROP TRIGGER IF EXISTS trg_order_total;
GO
