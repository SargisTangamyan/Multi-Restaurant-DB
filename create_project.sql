IF NOT EXISTS (SELECT name
               FROM sys.databases
               WHERE name = 'restaurant_project')
    BEGIN
        CREATE DATABASE restaurant_project;
    END

USE restaurant_project;

-- =======================
-- ENUM replacements
-- =======================

-- role_type
-- user, admin, restaurant

-- staff_role
-- manager, chef, cashier

-- order_status
-- pending, confirmed, preparing, completed, delivered, canceled

-- payment_enum
-- cash, card


-- =======================
-- USERS
-- =======================
CREATE TABLE users
(
    id                BIGINT IDENTITY PRIMARY KEY,
    username          VARCHAR(255) UNIQUE,
    profile_image     VARCHAR(255),
    first_name        VARCHAR(255),
    last_name         VARCHAR(255),
    city              VARCHAR(255),
    phone_number      VARCHAR(30) UNIQUE,
    address           VARCHAR(255),
    email             VARCHAR(255) NOT NULL UNIQUE,
    email_verified_at DATETIME,
    password          VARCHAR(255) NOT NULL,

    role              VARCHAR(20)  NOT NULL DEFAULT 'user'
        CHECK (role IN ('user', 'admin', 'restaurant')),

    stripe_id         BIGINT,
    pm_type           VARCHAR(255),
    pm_last_four      CHAR(4),
    trial_ends_at     DATETIME,

    created_at        DATETIME              DEFAULT GETDATE(),
    updated_at        DATETIME              DEFAULT GETDATE(),
    deleted_at        DATETIME
);

CREATE INDEX idx_users_deleted_at ON users (deleted_at);


-- =======================
-- RESTAURANTS
-- =======================
CREATE TABLE restaurants
(
    id           BIGINT IDENTITY PRIMARY KEY,
    owner_id     BIGINT       NOT NULL,
    name         VARCHAR(255) NOT NULL,
    description  VARCHAR(max),
    phone_number VARCHAR(30),
    image        VARCHAR(255),

    created_at   DATETIME DEFAULT GETDATE(),
    updated_at   DATETIME DEFAULT GETDATE(),
    deleted_at   DATETIME,

    CONSTRAINT uq_owner_name UNIQUE (owner_id, name),

    FOREIGN KEY (owner_id) REFERENCES users (id)
);

CREATE INDEX idx_restaurants_deleted_at ON restaurants (deleted_at);


-- =======================
-- RESTAURANT BRANCHES
-- =======================
CREATE TABLE restaurant_branches
(
    id            BIGINT IDENTITY PRIMARY KEY,
    restaurant_id BIGINT       NOT NULL,
    city          VARCHAR(255) NOT NULL,
    address       VARCHAR(255) NOT NULL,
    phone_number  VARCHAR(30),

    created_at    DATETIME DEFAULT GETDATE(),
    updated_at    DATETIME DEFAULT GETDATE(),
    deleted_at    DATETIME,

    CONSTRAINT uq_restaurant_address UNIQUE (restaurant_id, address),

    FOREIGN KEY (restaurant_id)
        REFERENCES restaurants (id)
        ON DELETE CASCADE
);

CREATE INDEX idx_branches_deleted_at ON restaurant_branches (deleted_at);


-- =======================
-- RESTAURANT STAFF
-- =======================
CREATE TABLE restaurant_staffs
(
    id            BIGINT IDENTITY PRIMARY KEY,
    user_id       BIGINT      NOT NULL,
    restaurant_id BIGINT      NOT NULL,

    role          VARCHAR(20) NOT NULL
        CHECK (role IN ('manager', 'chef', 'cashier')),

    created_at    DATETIME DEFAULT GETDATE(),
    updated_at    DATETIME DEFAULT GETDATE(),
    deleted_at    DATETIME,

    CONSTRAINT uq_staff UNIQUE (user_id, restaurant_id),

    FOREIGN KEY (user_id) REFERENCES users (id) ON DELETE CASCADE,
    FOREIGN KEY (restaurant_id) REFERENCES restaurants (id) ON DELETE CASCADE
);

CREATE INDEX idx_staff_deleted_at ON restaurant_staffs (deleted_at);


-- =======================
-- CATEGORIES
-- =======================
CREATE TABLE categories
(
    id         BIGINT IDENTITY PRIMARY KEY,
    name       VARCHAR(255) NOT NULL UNIQUE,
    slug       VARCHAR(255) NOT NULL UNIQUE,
    parent_id  BIGINT,

    created_at DATETIME DEFAULT GETDATE(),
    updated_at DATETIME DEFAULT GETDATE(),
    deleted_at DATETIME,

    FOREIGN KEY (parent_id) REFERENCES categories (id)
);

CREATE INDEX idx_categories_deleted_at ON categories (deleted_at);


-- =======================
-- DISHES
-- =======================
CREATE TABLE dishes
(
    id             BIGINT IDENTITY PRIMARY KEY,
    slug           VARCHAR(255)  NOT NULL,
    category_id    BIGINT        NOT NULL,
    restaurant_id  BIGINT        NOT NULL,
    name           VARCHAR(255)  NOT NULL,
    description    varchar(max),
    price          DECIMAL(10, 2) NOT NULL CHECK (price >= 0),
    image          VARCHAR(255)  NOT NULL,
    thumbnail      VARCHAR(255),

    average_rating DECIMAL(2, 1)          DEFAULT 0 CHECK (average_rating >= 0 AND average_rating <= 5),
    reviews_count  INT                    DEFAULT 0 CHECK (reviews_count >= 0),
    is_available   BIT           NOT NULL DEFAULT 1,

    created_at     DATETIME               DEFAULT GETDATE(),
    updated_at     DATETIME               DEFAULT GETDATE(),
    deleted_at     DATETIME,

    UNIQUE (restaurant_id, slug),

    FOREIGN KEY (category_id) REFERENCES categories (id),
    FOREIGN KEY (restaurant_id) REFERENCES restaurants (id) ON DELETE CASCADE
);

CREATE UNIQUE INDEX idx_dishes_restaurant_name ON dishes (restaurant_id, name);
CREATE INDEX idx_dishes_category ON dishes (category_id);
CREATE INDEX idx_dishes_deleted_at ON dishes (deleted_at);


-- =======================
-- CARTS
-- =======================
CREATE TABLE carts
(
    id         BIGINT IDENTITY PRIMARY KEY,
    user_id    BIGINT NOT NULL UNIQUE,

    status     VARCHAR(10) DEFAULT 'active'
        CHECK (status IN ('active', 'ordered')),

    created_at DATETIME    DEFAULT GETDATE(),
    updated_at DATETIME    DEFAULT GETDATE(),

    FOREIGN KEY (user_id)
        REFERENCES users (id)
        ON DELETE CASCADE
);


-- =======================
-- CART ITEMS
-- =======================
CREATE TABLE cart_items
(
    id       BIGINT IDENTITY PRIMARY KEY,
    cart_id  BIGINT NOT NULL,
    dish_id  BIGINT NOT NULL,
    quantity INT    NOT NULL DEFAULT 1 CHECK (quantity > 0),

    created_at DATETIME DEFAULT GETDATE(),
    updated_at DATETIME DEFAULT GETDATE(),

    CONSTRAINT uq_cart_dish UNIQUE (cart_id, dish_id),

    FOREIGN KEY (cart_id)
        REFERENCES carts (id)
        ON DELETE CASCADE,

    FOREIGN KEY (dish_id)
        REFERENCES dishes (id)
        ON DELETE CASCADE
);


-- =======================
-- INGREDIENTS
-- =======================
CREATE TABLE ingredients
(
    id          BIGINT IDENTITY PRIMARY KEY,
    name        VARCHAR(255) NOT NULL UNIQUE,
    slug        VARCHAR(255) NOT NULL UNIQUE,
    unit        VARCHAR(255) NOT NULL,
    is_allergic BIT          NOT NULL DEFAULT 0,

    created_at  DATETIME              DEFAULT GETDATE(),
    updated_at  DATETIME              DEFAULT GETDATE()
);


-- =======================
-- USER ALLERGIES
-- =======================
CREATE TABLE user_allergies
(
    user_id       BIGINT NOT NULL,
    ingredient_id BIGINT NOT NULL,

    CONSTRAINT pk_user_allergies PRIMARY KEY (user_id, ingredient_id),

    FOREIGN KEY (user_id) REFERENCES users (id) ON DELETE CASCADE,
    FOREIGN KEY (ingredient_id) REFERENCES ingredients (id)
);


-- =======================
-- DISH INGREDIENTS
-- =======================
CREATE TABLE dish_ingredients
(
    dish_id       BIGINT        NOT NULL,
    ingredient_id BIGINT        NOT NULL,
    quantity      DECIMAL(10, 2) NOT NULL,

    CONSTRAINT pk_dish_ingredients PRIMARY KEY (dish_id, ingredient_id),

    FOREIGN KEY (dish_id)
        REFERENCES dishes (id)
        ON DELETE CASCADE,

    FOREIGN KEY (ingredient_id)
        REFERENCES ingredients (id)
);


-- =======================
-- ORDERS
-- =======================
CREATE TABLE orders
(
    id               BIGINT IDENTITY PRIMARY KEY,
    user_id          BIGINT        NOT NULL,
    total_price      DECIMAL(10, 2) NOT NULL CHECK (total_price >= 0),

    status           VARCHAR(20)   NOT NULL DEFAULT 'pending'
        CHECK (status IN ('pending', 'confirmed', 'preparing', 'completed', 'delivered', 'canceled')),

    payment_method   VARCHAR(10)   NOT NULL
        CHECK (payment_method IN ('cash', 'card')),

    delivery_address VARCHAR(255)  NOT NULL,
    contact_phone    VARCHAR(30),
    delivery_fee     DECIMAL(10, 2) CHECK (delivery_fee >= 0),

    created_at       DATETIME               DEFAULT GETDATE(),
    updated_at       DATETIME               DEFAULT GETDATE(),
    deleted_at       DATETIME,

    FOREIGN KEY (user_id) REFERENCES users (id) ON DELETE CASCADE
);

CREATE INDEX idx_orders_user ON orders (user_id);
CREATE INDEX idx_orders_deleted_at ON orders (deleted_at);


-- =======================
-- SUBORDERS
-- =======================
CREATE TABLE suborders
(
    id                   BIGINT IDENTITY PRIMARY KEY,
    order_id             BIGINT      NOT NULL,
    restaurant_branch_id BIGINT      NOT NULL,

    status               VARCHAR(20) NOT NULL DEFAULT 'pending'
        CHECK (status IN ('pending', 'confirmed', 'preparing', 'completed', 'delivered', 'canceled')),

    total_price          DECIMAL(10, 2) NOT NULL DEFAULT 0.0 CHECK (total_price >= 0),

    created_at           DATETIME             DEFAULT GETDATE(),
    updated_at           DATETIME             DEFAULT GETDATE(),

    FOREIGN KEY (order_id)
        REFERENCES orders (id)
        ON DELETE CASCADE,

    FOREIGN KEY (restaurant_branch_id)
        REFERENCES restaurant_branches (id)
);

CREATE INDEX idx_suborders_order ON suborders (order_id);


-- =======================
-- ORDER ITEMS
-- =======================
CREATE TABLE order_items
(
    id          BIGINT IDENTITY PRIMARY KEY,
    suborder_id BIGINT        NOT NULL,
    dish_id     BIGINT        NOT NULL,
    restaurant_branch_id BIGINT NOT NULL,

    quantity    INT           NOT NULL CHECK (quantity > 0),
    price       DECIMAL(10, 2) NOT NULL CHECK (price >= 0),

    CONSTRAINT uq_suborder_dish UNIQUE (suborder_id, dish_id),

    FOREIGN KEY (suborder_id)
        REFERENCES suborders (id)
        ON DELETE CASCADE,

    FOREIGN KEY (dish_id)
        REFERENCES dishes (id),

    FOREIGN KEY (restaurant_branch_id)
        REFERENCES restaurant_branches (id)
);


-- =======================
-- WISHLISTS
-- =======================
CREATE TABLE wishlists
(
    user_id BIGINT NOT NULL,
    dish_id BIGINT NOT NULL,

    CONSTRAINT pk_wishlists PRIMARY KEY (user_id, dish_id),

    FOREIGN KEY (user_id) REFERENCES users (id) ON DELETE CASCADE,
    FOREIGN KEY (dish_id) REFERENCES dishes (id) ON DELETE CASCADE
);


-- =======================
-- DISH REVIEWS
-- =======================
CREATE TABLE dish_reviews
(
    id         BIGINT IDENTITY PRIMARY KEY,
    user_id    BIGINT   NOT NULL,
    dish_id    BIGINT   NOT NULL,

    rating     SMALLINT NOT NULL CHECK (rating BETWEEN 1 AND 5),
    comment    varchar(max),

    created_at DATETIME DEFAULT GETDATE(),
    updated_at DATETIME DEFAULT GETDATE(),

    CONSTRAINT uq_user_review UNIQUE (user_id, dish_id),

    FOREIGN KEY (user_id) REFERENCES users (id) ON DELETE CASCADE,
    FOREIGN KEY (dish_id) REFERENCES dishes (id) ON DELETE CASCADE
);

CREATE INDEX idx_reviews_dish ON dish_reviews (dish_id);