# Restaurant Ordering System — SQL Server Database

A production-grade multi-restaurant food ordering platform built with T-SQL (SQL Server). The system supports multiple restaurants, branched locations, menu management, cart/order processing, allergen tracking, and role-based access control.

---

## Table of Contents

- [Project Overview](#project-overview)
- [Database Schema](#database-schema)
- [Files](#files)
- [Features](#features)
- [Setup & Installation](#setup--installation)
- [Stored Procedures](#stored-procedures)
- [Views](#views)
- [Indexes](#indexes)
- [Triggers](#triggers)
- [Database Users & Roles](#database-users--roles)
- [Tech Stack](#tech-stack)

---

## Project Overview

**EATO** is a multi-tenant restaurant ordering platform modeled after services like Uber Eats or DoorDash. Key capabilities:

- Multiple restaurants, each with multiple branch locations
- Menu management with hierarchical categories and ingredients
- Cart and multi-restaurant order processing (orders split into sub-orders per restaurant)
- Allergen tracking per user
- Customer reviews and wishlists
- Stripe payment integration hooks
- Soft-delete and full audit trail (created_at, updated_at, deleted_at)

---

## Database Schema

The database contains **19 tables** organized into logical groups:

### User Management

| Table | Description |
|---|---|
| `users` | System users with roles: `user`, `admin`, `restaurant` |
| `restaurant_staffs` | Staff assignments (manager, chef, cashier) per branch |

### Restaurant Management

| Table | Description |
|---|---|
| `restaurants` | Restaurant entities owned by a user |
| `restaurant_branches` | Individual branch locations (city, address, phone) |

### Menu & Ingredients

| Table | Description |
|---|---|
| `categories` | Hierarchical dish categories (self-referencing `parent_id`) |
| `dishes` | Menu items with price, availability, and average rating |
| `ingredients` | Recipe components with unit and allergy flag |
| `dish_ingredients` | Many-to-many: dishes ↔ ingredients with quantity |
| `user_allergies` | Per-user allergen tracking |

### Shopping & Orders

| Table | Description |
|---|---|
| `carts` | User shopping carts (status: `active` / `ordered`) |
| `cart_items` | Line items inside a cart |
| `orders` | Top-level customer orders (status: pending → delivered / canceled) |
| `suborders` | Orders split per restaurant branch |
| `order_items` | Line items inside a sub-order |

### Social

| Table | Description |
|---|---|
| `dish_reviews` | Star ratings (0–5) and text reviews per dish |
| `wishlists` | User-saved favourite dishes |

### Key Relationships

```
users ──< restaurants ──< restaurant_branches
                      └──< dishes ──< dish_ingredients >── ingredients
                                  └──< order_items
users ──< orders ──< suborders ──< order_items
users ──< carts ──< cart_items
users ──< user_allergies >── ingredients
dishes ──< dish_reviews
dishes ──< wishlists
categories ──< categories (self-ref parent_id)
```

---

## Files

| File | Description |
|---|---|
| `create_project.sql` | Full schema: all 19 tables, constraints, and cascade rules |
| `procedures.sql` | 28 stored procedures for all business logic |
| `dql_queries.sql` | 24+ SELECT queries for data retrieval and reporting |
| `views.sql` | Reusable views (active users, restaurant overviews, staff) |
| `Indexes.sql` | 35+ performance indexes including composite, unique, and partial |
| `triggers.sql` | AFTER UPDATE triggers for automatic `updated_at` maintenance |
| `users_creation.sql` | Database login/user creation with role-based access |
| `restaurant_database_data_insertion.sql` | Sample seed data |
| `EATO.erdplus` | Entity-Relationship Diagram source file |

---

## Features

- **Multi-tenant architecture** — multiple restaurants share the same schema, each isolated by foreign keys
- **Hierarchical categories** — unlimited depth via self-referencing `parent_id`
- **Split orders** — a single customer order fans out into sub-orders per restaurant branch
- **Allergen safety** — ingredient allergy flags + per-user allergy profiles
- **Audit trail** — `created_at`, `updated_at` (auto-maintained by triggers), `deleted_at` for soft deletes
- **Soft deletes** — records are never physically removed; filtered indexes exclude soft-deleted rows
- **Payment-ready** — `stripe_id` and `pm_type` columns on `users` and `orders`
- **CHECK constraints** — prices ≥ 0, ratings in [0, 5], valid ENUM-style statuses
- **Cascade deletes** — removing a restaurant cascades to branches, dishes, and related items

---

## Setup & Installation

### Prerequisites

- SQL Server 2019+ (or Azure SQL Database)
- A SQL client (SSMS, Azure Data Studio, or DataGrip)

### Steps

1. **Create the database** (optional — edit the target database name in the scripts as needed):
   ```sql
   CREATE DATABASE restaurant_project;
   USE restaurant_project;
   ```

2. **Create schema and tables:**
   ```sql
   -- Run create_project.sql
   ```

3. **Create database users and roles:**
   ```sql
   -- Run users_creation.sql
   ```

4. **Create views, procedures, triggers, and indexes:**
   ```sql
   -- Run views.sql
   -- Run procedures.sql
   -- Run triggers.sql
   -- Run rollback_triggers.sql
   -- Run Indexes.sql
   ```

5. **Load sample data:**
   ```sql
   -- Run restaurant_database_data_insertion.sql
   ```

---

## Stored Procedures

The `procedures.sql` file defines 28 stored procedures covering:

| Category | Examples |
|---|---|
| Menu | `get_restaurant_menu`, `add_dish`, `update_dish_availability` |
| Cart | `add_to_cart`, cart management operations |
| Orders | `get_user_orders`, order placement and status updates |
| Reviews | Review creation and retrieval |
| Wishlist | Add/remove/list wishlist items |

All procedures use parameterized inputs, `RAISERROR` for validation, and `SCOPE_IDENTITY()` for retrieving new record IDs.

---

## Views

| View                      | Description                                          |
|---------------------------|------------------------------------------------------|
| `vw_active_users`         | Users without a `deleted_at` timestamp               |
| `vw_restaurants_overview` | Restaurants joined with branch counts and owner info |
| `vw_restaurant_staff`     | Staff assignments with user and restaurant details   |
| `...`                     | ...                                                  |
---

## Indexes

35+ indexes optimize common query patterns:

- **Composite indexes** on frequently joined columns (e.g., `restaurant_id + is_available` on `dishes`)
- **Unique indexes** on slugs and email fields
- **Partial (filtered) indexes** with `WHERE deleted_at IS NULL` to exclude soft-deleted rows
- **Foreign key indexes** on all FK columns to speed up JOINs and cascade operations

---

## Triggers

The database contains 23 AFTER triggers organised into four functional groups (update timestamp automotation, soft deletes, dish availability, dish review calculations). Each trigger uses SET NOCOUNT ON to suppress row-count messages and checks TRIGGER_NESTLEVEL() where necessary to prevent recursive firing.

---

## Database Users & Roles

Three SQL Server logins are created in `users_creation.sql`:

| Login / User | Role | Permissions |
|---|---|---|
| `app_reader` | Read-only | SELECT on all tables and views |
| `app_developer` | Read/write | SELECT, INSERT, UPDATE, DELETE; EXECUTE procedures |
| `app_admin` | Full access | All of the above + DDL permissions |

---

## Tech Stack

| Component | Technology |
|---|---|
| Database engine | SQL Server (T-SQL) |
| Schema design | Normalized relational model (3NF+) |
| Business logic | Stored procedures |
| Automation | AFTER UPDATE triggers |
| Query abstraction | Views |
| Performance | Composite, unique, and partial indexes |
| Access control | Role-based SQL Server logins |
| ER diagram | ERDPlus |
