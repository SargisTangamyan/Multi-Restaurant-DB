/*
===========================================================
DATABASE PROJECT: Multi-Restaurant Food Ordering System
===========================================================

This database represents a multi-restaurant online food 
ordering platform. It includes users, restaurants, menus, 
orders, and all related entities required for a fully 
functional system.

-----------------------------------------------------------
IMPORTANT NOTICE
-----------------------------------------------------------

If you have multiple databases in your SQL Server environment,
please make sure to select the correct database before running
the script.

Run the following command first:

USE restaurant_project;

After that, execute the full script.

-----------------------------------------------------------
DATABASE OVERVIEW
-----------------------------------------------------------

1. USERS
Stores all system users including customers, restaurant 
owners, staff, and administrators.

SELECT * FROM users;

2. RESTAURANTS
Represents restaurants created and managed by owners.

SELECT * FROM restaurants;

3. RESTAURANT_BRANCHES
Each restaurant can have multiple branches with different 
locations.

SELECT * FROM restaurant_branches;

4. RESTAURANT_STAFFS
Assigns staff members (manager, chef, cashier) to restaurants.

SELECT * FROM restaurant_staffs;

5. CATEGORIES
Hierarchical structure of food categories (parent-child).

SELECT * FROM categories;

6. INGREDIENTS
List of all ingredients used in dishes, including allergen flags.

SELECT * FROM ingredients;

7. DISHES
Menu items offered by restaurants, linked to categories.

SELECT * FROM dishes;

8. DISH_INGREDIENTS
Many-to-many relationship between dishes and ingredients.

SELECT * FROM dish_ingredients;

9. USER_ALLERGIES
Tracks which ingredients each user is allergic to.

SELECT * FROM user_allergies;

10. CARTS
Each user has exactly one cart for managing selected items.

SELECT * FROM carts;

11. CART_ITEMS
Items added to carts with quantity.

SELECT * FROM cart_items;

12. WISHLISTS
User favorite dishes.

SELECT * FROM wishlists;

13. ORDERS
Represents customer orders.

SELECT * FROM orders;

14. SUBORDERS
Orders are split into suborders per restaurant branch.

SELECT * FROM suborders;

15. ORDER_ITEMS
Detailed items within each suborder.

SELECT * FROM order_items;

16. DISH_REVIEWS
User reviews and ratings for dishes.

SELECT * FROM dish_reviews;

-----------------------------------------------------------
HOW TO USE
-----------------------------------------------------------

To inspect any table, simply uncomment and run:

SELECT * FROM table_name;

-----------------------------------------------------------
END OF DOCUMENTATION
-----------------------------------------------------------
*/
Use restaurant_project;

INSERT INTO users (
    username,
    profile_image,
    first_name,
    last_name,
    city,
    phone_number,
    address,
    email,
    email_verified_at,
    password,
    role,
    stripe_id,
    pm_type,
    pm_last_four,
    trial_ends_at
)
VALUES
-- Admins (1-5)
('john_smith', 'profiles/john_smith.jpg', 'John', 'Smith', 'New York', '1000000001', '12 Madison Ave', 'john.smith@mail.com', GETDATE(), 'password123', 'admin', 10001, 'visa', '1111', DATEADD(DAY, 30, GETDATE())),
('emma_johnson', 'profiles/emma_johnson.jpg', 'Emma', 'Johnson', 'Los Angeles', '1000000002', '45 Sunset Blvd', 'emma.johnson@mail.com', GETDATE(), 'password123', 'admin', 10002, 'mastercard', '2222', DATEADD(DAY, 30, GETDATE())),
('michael_brown', 'profiles/michael_brown.jpg', 'Michael', 'Brown', 'Chicago', '1000000003', '78 Lake Shore Dr', 'michael.brown@mail.com', GETDATE(), 'password123', 'admin', 10003, 'visa', '3333', DATEADD(DAY, 30, GETDATE())),
('olivia_davis', 'profiles/olivia_davis.jpg', 'Olivia', 'Davis', 'Houston', '1000000004', '23 Westheimer Rd', 'olivia.davis@mail.com', GETDATE(), 'password123', 'admin', 10004, 'amex', '4444', DATEADD(DAY, 30, GETDATE())),
('daniel_miller', 'profiles/daniel_miller.jpg', 'Daniel', 'Miller', 'Phoenix', '1000000005', '90 Camelback Rd', 'daniel.miller@mail.com', GETDATE(), 'password123', 'admin', 10005, 'visa', '5555', DATEADD(DAY, 30, GETDATE())),

-- Restaurant owners (6-15)
('max_wilson', 'profiles/max_wilson.jpg', 'Max', 'Wilson', 'Philadelphia', '1000000006', '14 Market St', 'max.wilson@mail.com', GETDATE(), 'password123', 'restaurant', 10006, 'visa', '1006', DATEADD(DAY, 30, GETDATE())),
('sophia_moore', 'profiles/sophia_moore.jpg', 'Sophia', 'Moore', 'San Antonio', '1000000007', '67 River Walk', 'sophia.moore@mail.com', GETDATE(), 'password123', 'restaurant', 10007, 'mastercard', '1007', DATEADD(DAY, 30, GETDATE())),
('james_taylor', 'profiles/james_taylor.jpg', 'James', 'Taylor', 'San Diego', '1000000008', '31 Harbor Dr', 'james.taylor@mail.com', GETDATE(), 'password123', 'restaurant', 10008, 'visa', '1008', DATEADD(DAY, 30, GETDATE())),
('isabella_anderson', 'profiles/isabella_anderson.jpg', 'Isabella', 'Anderson', 'Dallas', '1000000009', '55 Elm St', 'isabella.anderson@mail.com', GETDATE(), 'password123', 'restaurant', 10009, 'visa', '1009', DATEADD(DAY, 30, GETDATE())),
('william_thomas', 'profiles/william_thomas.jpg', 'William', 'Thomas', 'San Jose', '1000000010', '88 Santa Clara St', 'william.thomas@mail.com', GETDATE(), 'password123', 'restaurant', 10010, 'amex', '1010', DATEADD(DAY, 30, GETDATE())),
('mia_jackson', 'profiles/mia_jackson.jpg', 'Mia', 'Jackson', 'Austin', '1000000011', '21 Congress Ave', 'mia.jackson@mail.com', GETDATE(), 'password123', 'restaurant', 10011, 'visa', '1011', DATEADD(DAY, 30, GETDATE())),
('alex_white', 'profiles/alex_white.jpg', 'Alex', 'White', 'Jacksonville', '1000000012', '49 Bay St', 'alex.white@mail.com', GETDATE(), 'password123', 'restaurant', 10012, 'mastercard', '1012', DATEADD(DAY, 30, GETDATE())),
('charlotte_harris', 'profiles/charlotte_harris.jpg', 'Charlotte', 'Harris', 'Fort Worth', '1000000013', '73 Magnolia Ave', 'charlotte.harris@mail.com', GETDATE(), 'password123', 'restaurant', 10013, 'visa', '1013', DATEADD(DAY, 30, GETDATE())),
('ben_martin', 'profiles/ben_martin.jpg', 'Ben', 'Martin', 'Columbus', '1000000014', '62 High St', 'ben.martin@mail.com', GETDATE(), 'password123', 'restaurant', 10014, 'visa', '1014', DATEADD(DAY, 30, GETDATE())),
('amelia_thompson', 'profiles/amelia_thompson.jpg', 'Amelia', 'Thompson', 'Charlotte', '1000000015', '11 Queens Rd', 'amelia.thompson@mail.com', GETDATE(), 'password123', 'restaurant', 10015, 'amex', '1015', DATEADD(DAY, 30, GETDATE())),

-- Restaurant staff (16-25)
('lucas_garcia', 'profiles/lucas_garcia.jpg', 'Lucas', 'Garcia', 'San Francisco', '1000000016', '5 Market St', 'lucas.garcia@mail.com', GETDATE(), 'password123', 'restaurant', 10016, 'visa', '1016', DATEADD(DAY, 30, GETDATE())),
('evelyn_martinez', 'profiles/evelyn_martinez.jpg', 'Evelyn', 'Martinez', 'Indianapolis', '1000000017', '39 Meridian St', 'evelyn.martinez@mail.com', GETDATE(), 'password123', 'restaurant', 10017, 'mastercard', '1017', DATEADD(DAY, 30, GETDATE())),
('henry_robinson', 'profiles/henry_robinson.jpg', 'Henry', 'Robinson', 'Seattle', '1000000018', '84 Pine St', 'henry.robinson@mail.com', GETDATE(), 'password123', 'restaurant', 10018, 'visa', '1018', DATEADD(DAY, 30, GETDATE())),
('abigail_clark', 'profiles/abigail_clark.jpg', 'Abigail', 'Clark', 'Denver', '1000000019', '16 Colfax Ave', 'abigail.clark@mail.com', GETDATE(), 'password123', 'restaurant', 10019, 'visa', '1019', DATEADD(DAY, 30, GETDATE())),
('jack_lewis', 'profiles/jack_lewis.jpg', 'Jack', 'Lewis', 'Boston', '1000000020', '44 Beacon St', 'jack.lewis@mail.com', GETDATE(), 'password123', 'restaurant', 10020, 'amex', '1020', DATEADD(DAY, 30, GETDATE())),
('grace_walker', 'profiles/grace_walker.jpg', 'Grace', 'Walker', 'Nashville', '1000000021', '29 Broadway', 'grace.walker@mail.com', GETDATE(), 'password123', 'restaurant', 10021, 'visa', '1021', DATEADD(DAY, 30, GETDATE())),
('leo_hall', 'profiles/leo_hall.jpg', 'Leo', 'Hall', 'Portland', '1000000022', '61 Burnside St', 'leo.hall@mail.com', GETDATE(), 'password123', 'restaurant', 10022, 'mastercard', '1022', DATEADD(DAY, 30, GETDATE())),
('chloe_allen', 'profiles/chloe_allen.jpg', 'Chloe', 'Allen', 'Las Vegas', '1000000023', '77 Fremont St', 'chloe.allen@mail.com', GETDATE(), 'password123', 'restaurant', 10023, 'visa', '1023', DATEADD(DAY, 30, GETDATE())),
('nathan_young', 'profiles/nathan_young.jpg', 'Nathan', 'Young', 'Baltimore', '1000000024', '18 Pratt St', 'nathan.young@mail.com', GETDATE(), 'password123', 'restaurant', 10024, 'visa', '1024', DATEADD(DAY, 30, GETDATE())),
('lily_king', 'profiles/lily_king.jpg', 'Lily', 'King', 'Louisville', '1000000025', '53 Main St', 'lily.king@mail.com', GETDATE(), 'password123', 'restaurant', 10025, 'amex', '1025', DATEADD(DAY, 30, GETDATE())),

-- Customers (26-50)
('david_scott', 'profiles/david_scott.jpg', 'David', 'Scott', 'Miami', '1000000026', '102 Ocean Dr', 'david.scott@mail.com', GETDATE(), 'password123', 'user', 10026, 'visa', '1026', DATEADD(DAY, 30, GETDATE())),
('ella_green', 'profiles/ella_green.jpg', 'Ella', 'Green', 'Atlanta', '1000000027', '35 Peachtree St', 'ella.green@mail.com', GETDATE(), 'password123', 'user', 10027, 'mastercard', '1027', DATEADD(DAY, 30, GETDATE())),
('sam_adams', 'profiles/sam_adams.jpg', 'Sam', 'Adams', 'Orlando', '1000000028', '47 Orange Ave', 'sam.adams@mail.com', GETDATE(), 'password123', 'user', 10028, 'visa', '1028', DATEADD(DAY, 30, GETDATE())),
('zoe_baker', 'profiles/zoe_baker.jpg', 'Zoe', 'Baker', 'Tampa', '1000000029', '28 Kennedy Blvd', 'zoe.baker@mail.com', GETDATE(), 'password123', 'user', 10029, 'visa', '1029', DATEADD(DAY, 30, GETDATE())),
('owen_nelson', 'profiles/owen_nelson.jpg', 'Owen', 'Nelson', 'Cleveland', '1000000030', '64 Euclid Ave', 'owen.nelson@mail.com', GETDATE(), 'password123', 'user', 10030, 'amex', '1030', DATEADD(DAY, 30, GETDATE())),
('scarlett_carter', 'profiles/scarlett_carter.jpg', 'Scarlett', 'Carter', 'Cincinnati', '1000000031', '15 Vine St', 'scarlett.carter@mail.com', GETDATE(), 'password123', 'user', 10031, 'visa', '1031', DATEADD(DAY, 30, GETDATE())),
('gabriel_mitchell', 'profiles/gabriel_mitchell.jpg', 'Gabriel', 'Mitchell', 'Kansas City', '1000000032', '72 Walnut St', 'gabriel.mitchell@mail.com', GETDATE(), 'password123', 'user', 10032, 'mastercard', '1032', DATEADD(DAY, 30, GETDATE())),
('hannah_perez', 'profiles/hannah_perez.jpg', 'Hannah', 'Perez', 'Sacramento', '1000000033', '91 Capitol Ave', 'hannah.perez@mail.com', GETDATE(), 'password123', 'user', 10033, 'visa', '1033', DATEADD(DAY, 30, GETDATE())),
('julian_roberts', 'profiles/julian_roberts.jpg', 'Julian', 'Roberts', 'Raleigh', '1000000034', '24 Hillsborough St', 'julian.roberts@mail.com', GETDATE(), 'password123', 'user', 10034, 'visa', '1034', DATEADD(DAY, 30, GETDATE())),
('victoria_turner', 'profiles/victoria_turner.jpg', 'Victoria', 'Turner', 'Omaha', '1000000035', '68 Dodge St', 'victoria.turner@mail.com', GETDATE(), 'password123', 'user', 10035, 'amex', '1035', DATEADD(DAY, 30, GETDATE())),
('carter_phillips', 'profiles/carter_phillips.jpg', 'Carter', 'Phillips', 'Minneapolis', '1000000036', '37 Hennepin Ave', 'carter.phillips@mail.com', GETDATE(), 'password123', 'user', 10036, 'visa', '1036', DATEADD(DAY, 30, GETDATE())),
('aurora_campbell', 'profiles/aurora_campbell.jpg', 'Aurora', 'Campbell', 'Tulsa', '1000000037', '58 Boulder Ave', 'aurora.campbell@mail.com', GETDATE(), 'password123', 'user', 10037, 'mastercard', '1037', DATEADD(DAY, 30, GETDATE())),
('isaac_parker', 'profiles/isaac_parker.jpg', 'Isaac', 'Parker', 'Arlington', '1000000038', '83 Cooper St', 'isaac.parker@mail.com', GETDATE(), 'password123', 'user', 10038, 'visa', '1038', DATEADD(DAY, 30, GETDATE())),
('nora_evans', 'profiles/nora_evans.jpg', 'Nora', 'Evans', 'New Orleans', '1000000039', '22 Bourbon St', 'nora.evans@mail.com', GETDATE(), 'password123', 'user', 10039, 'visa', '1039', DATEADD(DAY, 30, GETDATE())),
('andrew_edwards', 'profiles/andrew_edwards.jpg', 'Andrew', 'Edwards', 'Wichita', '1000000040', '74 Douglas Ave', 'andrew.edwards@mail.com', GETDATE(), 'password123', 'user', 10040, 'amex', '1040', DATEADD(DAY, 30, GETDATE())),
('layla_collins', 'profiles/layla_collins.jpg', 'Layla', 'Collins', 'Bakersfield', '1000000041', '19 Chester Ave', 'layla.collins@mail.com', GETDATE(), 'password123', 'user', 10041, 'visa', '1041', DATEADD(DAY, 30, GETDATE())),
('christopher_stewart', 'profiles/christopher_stewart.jpg', 'Christopher', 'Stewart', 'Aurora', '1000000042', '51 Fox Valley Rd', 'christopher.stewart@mail.com', GETDATE(), 'password123', 'user', 10042, 'mastercard', '1042', DATEADD(DAY, 30, GETDATE())),
('penelope_sanchez', 'profiles/penelope_sanchez.jpg', 'Penelope', 'Sanchez', 'Anaheim', '1000000043', '46 Katella Ave', 'penelope.sanchez@mail.com', GETDATE(), 'password123', 'user', 10043, 'visa', '1043', DATEADD(DAY, 30, GETDATE())),
('wyatt_morris', 'profiles/wyatt_morris.jpg', 'Wyatt', 'Morris', 'Honolulu', '1000000044', '87 Ala Moana Blvd', 'wyatt.morris@mail.com', GETDATE(), 'password123', 'user', 10044, 'visa', '1044', DATEADD(DAY, 30, GETDATE())),
('stella_rogers', 'profiles/stella_rogers.jpg', 'Stella', 'Rogers', 'Santa Ana', '1000000045', '27 Main St', 'stella.rogers@mail.com', GETDATE(), 'password123', 'user', 10045, 'amex', '1045', DATEADD(DAY, 30, GETDATE())),
('ryan_reed', 'profiles/ryan_reed.jpg', 'Ryan', 'Reed', 'Riverside', '1000000046', '63 Magnolia Ave', 'ryan.reed@mail.com', GETDATE(), 'password123', 'user', 10046, 'visa', '1046', DATEADD(DAY, 30, GETDATE())),
('brooklyn_cook', 'profiles/brooklyn_cook.jpg', 'Brooklyn', 'Cook', 'Corpus Christi', '1000000047', '14 Shoreline Blvd', 'brooklyn.cook@mail.com', GETDATE(), 'password123', 'user', 10047, 'mastercard', '1047', DATEADD(DAY, 30, GETDATE())),
('ezra_morgan', 'profiles/ezra_morgan.jpg', 'Ezra', 'Morgan', 'Lexington', '1000000048', '59 Broadway', 'ezra.morgan@mail.com', GETDATE(), 'password123', 'user', 10048, 'visa', '1048', DATEADD(DAY, 30, GETDATE())),
('violet_bell', 'profiles/violet_bell.jpg', 'Violet', 'Bell', 'Stockton', '1000000049', '33 Pacific Ave', 'violet.bell@mail.com', GETDATE(), 'password123', 'user', 10049, 'visa', '1049', DATEADD(DAY, 30, GETDATE())),
('thomas_murphy', 'profiles/thomas_murphy.jpg', 'Thomas', 'Murphy', 'St. Louis', '1000000050', '70 Olive St', 'thomas.murphy@mail.com', GETDATE(), 'password123', 'user', 10050, 'amex', '1050', DATEADD(DAY, 30, GETDATE()));

INSERT INTO restaurants (
    owner_id,
    name,
    description,
    phone_number,
    image
)
VALUES
(6, 'Bella Napoli', 'Authentic Italian restaurant specializing in Neapolitan pizza, fresh pasta, and traditional desserts.', '2000000001', 'restaurants/bella_napoli.jpg'),
(7, 'Sushi Master', 'Modern Japanese restaurant offering sushi sets, sashimi, ramen, and signature seafood dishes.', '2000000002', 'restaurants/sushi_master.jpg'),
(8, 'Burger House', 'American-style burger restaurant with grilled beef burgers, fries, and craft sauces.', '2000000003', 'restaurants/burger_house.jpg'),
(9, 'Green Garden', 'Healthy food restaurant focused on salads, bowls, vegetarian meals, and fresh juices.', '2000000004', 'restaurants/green_garden.jpg'),
(10, 'Spice Route', 'Indian fusion restaurant serving curries, biryani, naan, and spicy street food.', '2000000005', 'restaurants/spice_route.jpg'),
(11, 'Ocean Catch', 'Seafood restaurant known for grilled salmon, shrimp platters, and coastal specialties.', '2000000006', 'restaurants/ocean_catch.jpg'),
(12, 'Taco Fiesta', 'Mexican restaurant with tacos, burritos, quesadillas, and homemade salsa.', '2000000007', 'restaurants/taco_fiesta.jpg'),
(13, 'French Corner', 'Classic French bistro offering soups, pastries, steak dishes, and elegant desserts.', '2000000008', 'restaurants/french_corner.jpg'),
(14, 'Dragon Wok', 'Asian restaurant serving wok noodles, fried rice, dumplings, and spicy chicken dishes.', '2000000009', 'restaurants/dragon_wok.jpg'),
(15, 'Sweet Bakery', 'Bakery and cafe featuring cakes, croissants, coffee, cheesecakes, and breakfast sets.', '2000000010', 'restaurants/sweet_bakery.jpg');

INSERT INTO restaurant_branches (
    restaurant_id,
    city,
    address,
    phone_number
)
VALUES
-- Bella Napoli (restaurant_id = 1)
(1, 'New York', '120 Broadway, Manhattan, New York', '3000000001'),
(1, 'Brooklyn', '45 Bedford Ave, Brooklyn, New York', '3000000002'),

-- Sushi Master (restaurant_id = 2)
(2, 'Los Angeles', '88 Sunset Blvd, Los Angeles', '3000000003'),
(2, 'Santa Monica', '15 Ocean Ave, Santa Monica', '3000000004'),

-- Burger House (restaurant_id = 3)
(3, 'Chicago', '210 Michigan Ave, Chicago', '3000000005'),
(3, 'Naperville', '50 Jefferson Ave, Naperville', '3000000006'),

-- Green Garden (restaurant_id = 4)
(4, 'Houston', '95 Westheimer Rd, Houston', '3000000007'),
(4, 'Sugar Land', '12 City Walk, Sugar Land', '3000000008'),

-- Spice Route (restaurant_id = 5)
(5, 'Phoenix', '77 Camelback Rd, Phoenix', '3000000009'),
(5, 'Tempe', '19 Mill Ave, Tempe', '3000000010'),

-- Ocean Catch (restaurant_id = 6)
(6, 'San Diego', '300 Harbor Dr, San Diego', '3000000011'),
(6, 'La Jolla', '25 Coast Blvd, La Jolla', '3000000012'),

-- Taco Fiesta (restaurant_id = 7)
(7, 'Austin', '41 Congress Ave, Austin', '3000000013'),
(7, 'Round Rock', '9 Main St, Round Rock', '3000000014'),

-- French Corner (restaurant_id = 8)
(8, 'Dallas', '60 Elm St, Dallas', '3000000015'),
(8, 'Plano', '17 Legacy Dr, Plano', '3000000016'),

-- Dragon Wok (restaurant_id = 9)
(9, 'San Francisco', '145 Market St, San Francisco', '3000000017'),
(9, 'Oakland', '28 Broadway, Oakland', '3000000018'),

-- Sweet Bakery (restaurant_id = 10)
(10, 'Seattle', '33 Pine St, Seattle', '3000000019'),
(10, 'Bellevue', '14 Lake Hills Blvd, Bellevue', '3000000020');


INSERT INTO restaurant_staffs (
    user_id,
    restaurant_id,
    role
)
VALUES
(16, 1, 'manager'),
(17, 2, 'chef'),
(18, 3, 'cashier'),
(19, 4, 'manager'),
(20, 5, 'chef'),
(21, 6, 'cashier'),
(22, 7, 'manager'),
(23, 8, 'chef'),
(24, 9, 'cashier'),
(25, 10, 'manager');

INSERT INTO categories (
    name,
    slug,
    parent_id
)
VALUES
('Pizza', 'pizza', NULL),
('Burgers', 'burgers', NULL),
('Sushi', 'sushi', NULL),
('Salads', 'salads', NULL),
('Indian Food', 'indian-food', NULL),
('Seafood', 'seafood', NULL),
('Mexican Food', 'mexican-food', NULL),
('French Cuisine', 'french-cuisine', NULL),
('Asian Wok', 'asian-wok', NULL),
('Bakery & Desserts', 'bakery-desserts', NULL);

INSERT INTO categories (
    name,
    slug,
    parent_id
)
VALUES
('Vegetarian Pizza', 'vegetarian-pizza', 1),
('Meat Pizza', 'meat-pizza', 1),

('Beef Burgers', 'beef-burgers', 2),
('Chicken Burgers', 'chicken-burgers', 2),

('Maki Rolls', 'maki-rolls', 3),
('Nigiri', 'nigiri', 3),

('Healthy Salads', 'healthy-salads', 4),
('Protein Bowls', 'protein-bowls', 4),

('Cakes', 'cakes', 10),
('Pastries', 'pastries', 10);

INSERT INTO ingredients (
    name,
    slug,
    unit,
    is_allergic
)
VALUES
('Tomato', 'tomato', 'grams', 0),
('Mozzarella', 'mozzarella', 'grams', 1),
('Basil', 'basil', 'grams', 0),
('Olive Oil', 'olive-oil', 'ml', 0),
('Pizza Dough', 'pizza-dough', 'grams', 1),
('Pepperoni', 'pepperoni', 'grams', 0),
('Chicken Breast', 'chicken-breast', 'grams', 0),
('Beef Patty', 'beef-patty', 'grams', 0),
('Burger Bun', 'burger-bun', 'pieces', 1),
('Cheddar Cheese', 'cheddar-cheese', 'grams', 1),

('Lettuce', 'lettuce', 'grams', 0),
('Cucumber', 'cucumber', 'grams', 0),
('Avocado', 'avocado', 'grams', 0),
('Rice', 'rice', 'grams', 0),
('Nori', 'nori', 'sheets', 0),
('Salmon', 'salmon', 'grams', 1),
('Tuna', 'tuna', 'grams', 1),
('Shrimp', 'shrimp', 'grams', 1),
('Soy Sauce', 'soy-sauce', 'ml', 1),
('Cream Cheese', 'cream-cheese', 'grams', 1),

('Onion', 'onion', 'grams', 0),
('Garlic', 'garlic', 'grams', 0),
('Chili Pepper', 'chili-pepper', 'grams', 0),
('Curry Sauce', 'curry-sauce', 'ml', 0),
('Naan Bread', 'naan-bread', 'pieces', 1),
('Potato', 'potato', 'grams', 0),
('French Fries', 'french-fries', 'grams', 0),
('Mushrooms', 'mushrooms', 'grams', 0),
('Parmesan', 'parmesan', 'grams', 1),
('Caesar Dressing', 'caesar-dressing', 'ml', 1),

('Flour', 'flour', 'grams', 1),
('Sugar', 'sugar', 'grams', 0),
('Butter', 'butter', 'grams', 1),
('Egg', 'egg', 'pieces', 1),
('Milk', 'milk', 'ml', 1),
('Dark Chocolate', 'dark-chocolate', 'grams', 0),
('Strawberry', 'strawberry', 'grams', 0),
('Vanilla Cream', 'vanilla-cream', 'grams', 1),
('Peanuts', 'peanuts', 'grams', 1),
('Lemon Juice', 'lemon-juice', 'ml', 0);


INSERT INTO dishes (
    slug,
    category_id,
    restaurant_id,
    name,
    description,
    price,
    image,
    thumbnail,
    average_rating,
    reviews_count,
    is_available
)
VALUES
-- Bella Napoli (restaurant_id = 1)
('margherita-pizza', 11, 1, 'Margherita Pizza', 'Classic pizza with tomato sauce, mozzarella, and fresh basil.', 12.99, 'dishes/margherita_pizza.jpg', 'dishes/thumb_margherita_pizza.jpg', 4.7, 18, 1),
('pepperoni-pizza', 12, 1, 'Pepperoni Pizza', 'Traditional pizza topped with mozzarella and spicy pepperoni.', 14.49, 'dishes/pepperoni_pizza.jpg', 'dishes/thumb_pepperoni_pizza.jpg', 4.8, 24, 1),
('mushroom-pizza', 11, 1, 'Mushroom Pizza', 'Vegetarian pizza with mushrooms, mozzarella, and herbs.', 13.79, 'dishes/mushroom_pizza.jpg', 'dishes/thumb_mushroom_pizza.jpg', 4.5, 11, 1),
('four-cheese-pizza', 11, 1, 'Four Cheese Pizza', 'Rich pizza with mozzarella, parmesan, cheddar, and cream cheese.', 15.25, 'dishes/four_cheese_pizza.jpg', 'dishes/thumb_four_cheese_pizza.jpg', 4.9, 27, 1),

-- Sushi Master (restaurant_id = 2)
('salmon-maki-roll', 15, 2, 'Salmon Maki Roll', 'Fresh salmon roll with rice and nori.', 11.50, 'dishes/salmon_maki_roll.jpg', 'dishes/thumb_salmon_maki_roll.jpg', 4.6, 15, 1),
('tuna-maki-roll', 15, 2, 'Tuna Maki Roll', 'Classic tuna maki with premium sushi rice.', 12.20, 'dishes/tuna_maki_roll.jpg', 'dishes/thumb_tuna_maki_roll.jpg', 4.5, 12, 1),
('shrimp-nigiri', 16, 2, 'Shrimp Nigiri', 'Nigiri sushi topped with seasoned shrimp.', 13.40, 'dishes/shrimp_nigiri.jpg', 'dishes/thumb_shrimp_nigiri.jpg', 4.7, 14, 1),
('salmon-nigiri', 16, 2, 'Salmon Nigiri', 'Nigiri with sliced fresh salmon over sushi rice.', 13.80, 'dishes/salmon_nigiri.jpg', 'dishes/thumb_salmon_nigiri.jpg', 4.8, 21, 1),

-- Burger House (restaurant_id = 3)
('classic-beef-burger', 13, 3, 'Classic Beef Burger', 'Juicy grilled beef burger with lettuce, onion, and cheddar.', 10.99, 'dishes/classic_beef_burger.jpg', 'dishes/thumb_classic_beef_burger.jpg', 4.4, 19, 1),
('double-cheese-burger', 13, 3, 'Double Cheese Burger', 'Double beef patty burger with melted cheddar cheese.', 13.49, 'dishes/double_cheese_burger.jpg', 'dishes/thumb_double_cheese_burger.jpg', 4.7, 26, 1),
('crispy-chicken-burger', 14, 3, 'Crispy Chicken Burger', 'Crispy chicken breast burger with lettuce and sauce.', 11.75, 'dishes/crispy_chicken_burger.jpg', 'dishes/thumb_crispy_chicken_burger.jpg', 4.5, 17, 1),
('bbq-beef-burger', 13, 3, 'BBQ Beef Burger', 'Beef burger served with smoky BBQ sauce and onion.', 12.95, 'dishes/bbq_beef_burger.jpg', 'dishes/thumb_bbq_beef_burger.jpg', 4.6, 13, 1),

-- Green Garden (restaurant_id = 4)
('caesar-salad', 17, 4, 'Caesar Salad', 'Fresh romaine lettuce with parmesan and Caesar dressing.', 9.80, 'dishes/caesar_salad.jpg', 'dishes/thumb_caesar_salad.jpg', 4.3, 9, 1),
('avocado-salad', 17, 4, 'Avocado Salad', 'Light salad with avocado, cucumber, and greens.', 10.25, 'dishes/avocado_salad.jpg', 'dishes/thumb_avocado_salad.jpg', 4.5, 10, 1),
('chicken-protein-bowl', 18, 4, 'Chicken Protein Bowl', 'Protein bowl with grilled chicken, rice, and vegetables.', 12.60, 'dishes/chicken_protein_bowl.jpg', 'dishes/thumb_chicken_protein_bowl.jpg', 4.7, 16, 1),
('veggie-protein-bowl', 18, 4, 'Veggie Protein Bowl', 'Healthy bowl with rice, avocado, cucumber, and lettuce.', 11.90, 'dishes/veggie_protein_bowl.jpg', 'dishes/thumb_veggie_protein_bowl.jpg', 4.4, 8, 1),

-- Spice Route (restaurant_id = 5)
('chicken-curry', 5, 5, 'Chicken Curry', 'Traditional chicken curry with rich spices and creamy sauce.', 13.99, 'dishes/chicken_curry.jpg', 'dishes/thumb_chicken_curry.jpg', 4.8, 20, 1),
('butter-chicken', 5, 5, 'Butter Chicken', 'Tender chicken in a buttery tomato-based curry sauce.', 14.50, 'dishes/butter_chicken.jpg', 'dishes/thumb_butter_chicken.jpg', 4.9, 25, 1),
('naan-bread-set', 5, 5, 'Naan Bread Set', 'Fresh naan bread served warm with garlic butter.', 5.99, 'dishes/naan_bread_set.jpg', 'dishes/thumb_naan_bread_set.jpg', 4.4, 7, 1),
('spicy-vegetable-curry', 5, 5, 'Spicy Vegetable Curry', 'Mixed vegetables cooked in a spicy curry sauce.', 12.30, 'dishes/spicy_vegetable_curry.jpg', 'dishes/thumb_spicy_vegetable_curry.jpg', 4.5, 11, 1),

-- Ocean Catch (restaurant_id = 6)
('grilled-salmon', 6, 6, 'Grilled Salmon', 'Fresh salmon fillet grilled and served with lemon.', 17.99, 'dishes/grilled_salmon.jpg', 'dishes/thumb_grilled_salmon.jpg', 4.8, 22, 1),
('shrimp-platter', 6, 6, 'Shrimp Platter', 'Seasoned shrimp platter with dipping sauce.', 16.75, 'dishes/shrimp_platter.jpg', 'dishes/thumb_shrimp_platter.jpg', 4.6, 14, 1),
('seafood-rice-bowl', 6, 6, 'Seafood Rice Bowl', 'Rice bowl with salmon, shrimp, and fresh vegetables.', 15.90, 'dishes/seafood_rice_bowl.jpg', 'dishes/thumb_seafood_rice_bowl.jpg', 4.7, 18, 1),
('lemon-butter-fish', 6, 6, 'Lemon Butter Fish', 'White fish cooked in lemon butter sauce.', 16.20, 'dishes/lemon_butter_fish.jpg', 'dishes/thumb_lemon_butter_fish.jpg', 4.5, 12, 1),

-- Taco Fiesta (restaurant_id = 7)
('beef-taco', 7, 7, 'Beef Taco', 'Mexican taco with seasoned beef, onion, and salsa.', 8.99, 'dishes/beef_taco.jpg', 'dishes/thumb_beef_taco.jpg', 4.4, 13, 1),
('chicken-burrito', 7, 7, 'Chicken Burrito', 'Soft burrito filled with chicken, rice, and vegetables.', 10.75, 'dishes/chicken_burrito.jpg', 'dishes/thumb_chicken_burrito.jpg', 4.6, 17, 1),
('cheese-quesadilla', 7, 7, 'Cheese Quesadilla', 'Grilled tortilla filled with melted cheese.', 9.50, 'dishes/cheese_quesadilla.jpg', 'dishes/thumb_cheese_quesadilla.jpg', 4.3, 9, 1),
('shrimp-taco', 7, 7, 'Shrimp Taco', 'Taco with shrimp, lettuce, and lime dressing.', 9.95, 'dishes/shrimp_taco.jpg', 'dishes/thumb_shrimp_taco.jpg', 4.5, 10, 1),

-- French Corner (restaurant_id = 8)
('onion-soup', 8, 8, 'Onion Soup', 'Classic French onion soup with rich broth and cheese.', 8.80, 'dishes/onion_soup.jpg', 'dishes/thumb_onion_soup.jpg', 4.4, 8, 1),
('mushroom-crepe', 8, 8, 'Mushroom Crepe', 'Savory crepe filled with mushrooms and cream.', 11.20, 'dishes/mushroom_crepe.jpg', 'dishes/thumb_mushroom_crepe.jpg', 4.5, 10, 1),
('steak-with-butter-sauce', 8, 8, 'Steak with Butter Sauce', 'Tender steak served with a creamy butter sauce.', 18.50, 'dishes/steak_with_butter_sauce.jpg', 'dishes/thumb_steak_with_butter_sauce.jpg', 4.8, 15, 1),
('vanilla-eclair', 20, 8, 'Vanilla Eclair', 'Traditional French pastry with vanilla cream filling.', 6.40, 'dishes/vanilla_eclair.jpg', 'dishes/thumb_vanilla_eclair.jpg', 4.7, 19, 1),

-- Dragon Wok (restaurant_id = 9)
('chicken-noodles', 9, 9, 'Chicken Noodles', 'Wok-fried noodles with chicken and vegetables.', 12.70, 'dishes/chicken_noodles.jpg', 'dishes/thumb_chicken_noodles.jpg', 4.5, 13, 1),
('beef-fried-rice', 9, 9, 'Beef Fried Rice', 'Fried rice with beef, onion, and soy sauce.', 12.40, 'dishes/beef_fried_rice.jpg', 'dishes/thumb_beef_fried_rice.jpg', 4.6, 16, 1),
('shrimp-wok', 9, 9, 'Shrimp Wok', 'Stir-fried shrimp with vegetables and savory sauce.', 14.60, 'dishes/shrimp_wok.jpg', 'dishes/thumb_shrimp_wok.jpg', 4.7, 14, 1),
('spicy-chicken-rice', 9, 9, 'Spicy Chicken Rice', 'Rice with spicy chicken, garlic, and chili pepper.', 11.95, 'dishes/spicy_chicken_rice.jpg', 'dishes/thumb_spicy_chicken_rice.jpg', 4.4, 9, 1),

-- Sweet Bakery (restaurant_id = 10)
('strawberry-cheesecake', 19, 10, 'Strawberry Cheesecake', 'Creamy cheesecake topped with fresh strawberries.', 7.80, 'dishes/strawberry_cheesecake.jpg', 'dishes/thumb_strawberry_cheesecake.jpg', 4.9, 28, 1),
('chocolate-cake', 19, 10, 'Chocolate Cake', 'Soft layered cake with dark chocolate cream.', 7.20, 'dishes/chocolate_cake.jpg', 'dishes/thumb_chocolate_cake.jpg', 4.8, 24, 1),
('butter-croissant', 20, 10, 'Butter Croissant', 'Flaky French-style croissant made with butter.', 4.50, 'dishes/butter_croissant.jpg', 'dishes/thumb_butter_croissant.jpg', 4.6, 12, 1),
('vanilla-cupcake', 19, 10, 'Vanilla Cupcake', 'Cupcake with soft vanilla cream topping.', 5.20, 'dishes/vanilla_cupcake.jpg', 'dishes/thumb_vanilla_cupcake.jpg', 4.5, 11, 1);

INSERT INTO carts (
    user_id,
    status
)
VALUES
(1, 'ordered'),
(2, 'ordered'),
(3, 'active'),
(4, 'active'),
(5, 'ordered'),
(6, 'active'),
(7, 'ordered'),
(8, 'active'),
(9, 'ordered'),
(10, 'active'),

(11, 'ordered'),
(12, 'active'),
(13, 'ordered'),
(14, 'active'),
(15, 'ordered'),
(16, 'active'),
(17, 'ordered'),
(18, 'active'),
(19, 'ordered'),
(20, 'active'),

(21, 'ordered'),
(22, 'active'),
(23, 'ordered'),
(24, 'active'),
(25, 'ordered'),
(26, 'active'),
(27, 'ordered'),
(28, 'active'),
(29, 'ordered'),
(30, 'active'),

(31, 'ordered'),
(32, 'active'),
(33, 'ordered'),
(34, 'active'),
(35, 'ordered'),
(36, 'active'),
(37, 'ordered'),
(38, 'active'),
(39, 'ordered'),
(40, 'active'),

(41, 'ordered'),
(42, 'active'),
(43, 'ordered'),
(44, 'active'),
(45, 'ordered'),
(46, 'active'),
(47, 'ordered'),
(48, 'active'),
(49, 'ordered'),
(50, 'active');

INSERT INTO cart_items (
    cart_id,
    dish_id,
    quantity
)
VALUES
(1, 1, 2),
(1, 5, 1),

(2, 2, 1),
(2, 6, 2),

(3, 3, 1),
(3, 7, 1),

(4, 4, 2),
(4, 8, 1),

(5, 9, 1),
(5, 13, 2),

(6, 10, 1),
(6, 14, 1),

(7, 11, 2),
(7, 15, 1),

(8, 12, 1),
(8, 16, 2),

(9, 17, 1),
(9, 21, 1),

(10, 18, 2),
(10, 22, 1),

(11, 19, 1),
(11, 23, 2),

(12, 20, 1),
(12, 24, 1),

(13, 25, 2),
(13, 29, 1),

(14, 26, 1),
(14, 30, 2),

(15, 27, 1),
(15, 31, 1),

(16, 28, 2),
(16, 32, 1),

(17, 33, 1),
(17, 37, 2),

(18, 34, 1),
(18, 38, 1),

(19, 35, 2),
(19, 39, 1),

(20, 36, 1),
(20, 40, 2),

(21, 1, 1),
(21, 9, 2),

(22, 2, 2),
(22, 10, 1),

(23, 3, 1),
(23, 11, 1),

(24, 4, 1),
(24, 12, 2),

(25, 5, 2),
(25, 17, 1),

(26, 6, 1),
(26, 18, 1),

(27, 7, 2),
(27, 19, 1),

(28, 8, 1),
(28, 20, 2),

(29, 13, 1),
(29, 25, 1),

(30, 14, 2),
(30, 26, 1),

(31, 15, 1),
(31, 27, 2),

(32, 16, 1),
(32, 28, 1),

(33, 21, 2),
(33, 33, 1),

(34, 22, 1),
(34, 34, 2),

(35, 23, 1),
(35, 35, 1),

(36, 24, 2),
(36, 36, 1),

(37, 29, 1),
(37, 37, 2),

(38, 30, 1),
(38, 38, 1),

(39, 31, 2),
(39, 39, 1),

(40, 32, 1),
(40, 40, 2),

(41, 1, 1),
(41, 21, 2),

(42, 2, 2),
(42, 22, 1),

(43, 3, 1),
(43, 23, 1),

(44, 4, 1),
(44, 24, 2),

(45, 5, 2),
(45, 29, 1),

(46, 6, 1),
(46, 30, 1),

(47, 7, 2),
(47, 31, 1),

(48, 8, 1),
(48, 32, 2),

(49, 9, 1),
(49, 33, 1),

(50, 10, 2),
(50, 34, 1);

INSERT INTO wishlists (
    user_id,
    dish_id
)
VALUES
(26, 1),
(26, 10),

(27, 2),
(27, 18),

(28, 5),
(28, 21),

(29, 7),
(29, 33),

(30, 9),
(30, 38),

(31, 11),
(31, 40),

(32, 13),
(32, 19),

(33, 15),
(33, 37),

(34, 17),
(34, 22),

(35, 20),
(35, 35),

(36, 3),
(36, 24),

(37, 4),
(37, 28),

(38, 6),
(38, 31),

(39, 8),
(39, 39),

(40, 12),
(40, 36),

(41, 14),
(41, 25),

(42, 16),
(42, 34),

(43, 18),
(43, 29),

(44, 21),
(44, 30),

(45, 23),
(45, 32),

(46, 26),
(46, 1),

(47, 27),
(47, 6),

(48, 35),
(48, 9),

(49, 37),
(49, 12),

(50, 40),
(50, 15);

INSERT INTO dish_ingredients (
    dish_id,
    ingredient_id,
    quantity
)
VALUES
-- 1 Margherita Pizza
(1, 1, 120.00),
(1, 2, 100.00),
(1, 3, 10.00),
(1, 5, 250.00),

-- 2 Pepperoni Pizza
(2, 1, 120.00),
(2, 2, 100.00),
(2, 5, 250.00),
(2, 6, 80.00),

-- 3 Mushroom Pizza
(3, 1, 120.00),
(3, 2, 100.00),
(3, 5, 250.00),
(3, 28, 70.00),

-- 4 Four Cheese Pizza
(4, 2, 90.00),
(4, 5, 250.00),
(4, 10, 60.00),
(4, 29, 40.00),

-- 5 Salmon Maki Roll
(5, 14, 100.00),
(5, 15, 2.00),
(5, 16, 80.00),
(5, 19, 15.00),

-- 6 Tuna Maki Roll
(6, 14, 100.00),
(6, 15, 2.00),
(6, 17, 80.00),
(6, 19, 15.00),

-- 7 Shrimp Nigiri
(7, 14, 90.00),
(7, 18, 70.00),
(7, 19, 10.00),
(7, 40, 5.00),

-- 8 Salmon Nigiri
(8, 14, 90.00),
(8, 16, 70.00),
(8, 19, 10.00),
(8, 40, 5.00),

-- 9 Classic Beef Burger
(9, 8, 150.00),
(9, 9, 1.00),
(9, 11, 20.00),
(9, 21, 15.00),

-- 10 Double Cheese Burger
(10, 8, 200.00),
(10, 9, 1.00),
(10, 10, 50.00),
(10, 21, 15.00),

-- 11 Crispy Chicken Burger
(11, 7, 150.00),
(11, 9, 1.00),
(11, 11, 20.00),
(11, 21, 15.00),

-- 12 BBQ Beef Burger
(12, 8, 150.00),
(12, 9, 1.00),
(12, 21, 15.00),
(12, 22, 10.00),

-- 13 Caesar Salad
(13, 11, 70.00),
(13, 29, 20.00),
(13, 30, 25.00),
(13, 7, 80.00),

-- 14 Avocado Salad
(14, 11, 60.00),
(14, 12, 50.00),
(14, 13, 70.00),
(14, 40, 10.00),

-- 15 Chicken Protein Bowl
(15, 7, 120.00),
(15, 14, 100.00),
(15, 11, 40.00),
(15, 13, 50.00),

-- 16 Veggie Protein Bowl
(16, 14, 100.00),
(16, 11, 50.00),
(16, 12, 40.00),
(16, 13, 60.00),

-- 17 Chicken Curry
(17, 7, 130.00),
(17, 24, 80.00),
(17, 21, 20.00),
(17, 22, 10.00),

-- 18 Butter Chicken
(18, 7, 130.00),
(18, 24, 80.00),
(18, 33, 25.00),
(18, 1, 60.00),

-- 19 Naan Bread Set
(19, 25, 2.00),
(19, 33, 20.00),
(19, 31, 100.00),
(19, 35, 50.00),

-- 20 Spicy Vegetable Curry
(20, 24, 80.00),
(20, 21, 20.00),
(20, 22, 10.00),
(20, 23, 8.00),

-- 21 Grilled Salmon
(21, 16, 160.00),
(21, 40, 12.00),
(21, 4, 10.00),
(21, 22, 8.00),

-- 22 Shrimp Platter
(22, 18, 150.00),
(22, 40, 12.00),
(22, 4, 10.00),
(22, 22, 8.00),

-- 23 Seafood Rice Bowl
(23, 14, 110.00),
(23, 16, 60.00),
(23, 18, 60.00),
(23, 11, 30.00),

-- 24 Lemon Butter Fish
(24, 40, 12.00),
(24, 33, 20.00),
(24, 4, 10.00),
(24, 22, 8.00),

-- 25 Beef Taco
(25, 8, 100.00),
(25, 21, 15.00),
(25, 11, 20.00),
(25, 23, 5.00),

-- 26 Chicken Burrito
(26, 7, 120.00),
(26, 14, 90.00),
(26, 11, 20.00),
(26, 21, 15.00),

-- 27 Cheese Quesadilla
(27, 2, 80.00),
(27, 10, 50.00),
(27, 33, 15.00),
(27, 31, 90.00),

-- 28 Shrimp Taco
(28, 18, 90.00),
(28, 11, 20.00),
(28, 21, 15.00),
(28, 40, 8.00),

-- 29 Onion Soup
(29, 21, 70.00),
(29, 33, 20.00),
(29, 29, 20.00),
(29, 22, 8.00),

-- 30 Mushroom Crepe
(30, 28, 60.00),
(30, 35, 40.00),
(30, 34, 1.00),
(30, 31, 80.00),

-- 31 Steak with Butter Sauce
(31, 8, 180.00),
(31, 33, 20.00),
(31, 22, 8.00),
(31, 40, 10.00),

-- 32 Vanilla Eclair
(32, 31, 90.00),
(32, 38, 50.00),
(32, 34, 1.00),
(32, 32, 20.00),

-- 33 Chicken Noodles
(33, 7, 120.00),
(33, 21, 15.00),
(33, 22, 10.00),
(33, 19, 15.00),

-- 34 Beef Fried Rice
(34, 8, 120.00),
(34, 14, 100.00),
(34, 21, 15.00),
(34, 19, 15.00),

-- 35 Shrimp Wok
(35, 18, 100.00),
(35, 21, 15.00),
(35, 22, 10.00),
(35, 19, 15.00),

-- 36 Spicy Chicken Rice
(36, 7, 120.00),
(36, 14, 100.00),
(36, 23, 8.00),
(36, 22, 10.00),

-- 37 Strawberry Cheesecake
(37, 35, 60.00),
(37, 2, 70.00),
(37, 37, 40.00),
(37, 32, 20.00),

-- 38 Chocolate Cake
(38, 31, 100.00),
(38, 36, 50.00),
(38, 34, 2.00),
(38, 32, 25.00),

-- 39 Butter Croissant
(39, 31, 90.00),
(39, 33, 30.00),
(39, 35, 40.00),
(39, 34, 1.00),

-- 40 Vanilla Cupcake
(40, 31, 80.00),
(40, 38, 40.00),
(40, 34, 1.00),
(40, 32, 20.00);


INSERT INTO user_allergies (
    user_id,
    ingredient_id
)
VALUES
(26, 18),
(26, 19),

(27, 35),
(27, 34),

(28, 39),

(29, 16),
(29, 17),

(30, 2),
(30, 29),

(31, 31),
(31, 34),

(32, 10),

(33, 20),
(33, 35),

(34, 18),

(35, 19),
(35, 39),

(36, 16),

(37, 33),
(37, 35),

(38, 9),
(38, 31),

(39, 25),

(40, 30),

(41, 17),
(41, 19),

(42, 34),
(42, 35),
(42, 38),

(43, 2),

(44, 18),
(44, 19),

(45, 39),

(46, 5),
(46, 31),

(47, 20),
(47, 38),

(48, 16),
(48, 18),

(49, 29),

(50, 35),
(50, 34);

INSERT INTO orders (
    user_id,
    total_price,
    status,
    payment_method,
    delivery_address,
    contact_phone,
    delivery_fee
)
VALUES
(26, 28.48, 'delivered', 'card', '102 Ocean Dr, Miami', '1000000026', 3.50),
(27, 24.90, 'completed', 'cash', '35 Peachtree St, Atlanta', '1000000027', 2.50),
(28, 31.20, 'delivered', 'card', '47 Orange Ave, Orlando', '1000000028', 3.00),
(29, 18.75, 'confirmed', 'card', '28 Kennedy Blvd, Tampa', '1000000029', 2.00),
(30, 22.40, 'pending', 'cash', '64 Euclid Ave, Cleveland', '1000000030', 2.50),

(31, 35.60, 'preparing', 'card', '15 Vine St, Cincinnati', '1000000031', 3.50),
(32, 27.90, 'delivered', 'card', '72 Walnut St, Kansas City', '1000000032', 2.90),
(33, 19.80, 'canceled', 'cash', '91 Capitol Ave, Sacramento', '1000000033', 2.00),
(34, 41.25, 'completed', 'card', '24 Hillsborough St, Raleigh', '1000000034', 4.00),
(35, 16.70, 'pending', 'cash', '68 Dodge St, Omaha', '1000000035', 2.20),

(36, 29.95, 'confirmed', 'card', '37 Hennepin Ave, Minneapolis', '1000000036', 3.00),
(37, 21.50, 'delivered', 'cash', '58 Boulder Ave, Tulsa', '1000000037', 2.50),
(38, 26.40, 'completed', 'card', '83 Cooper St, Arlington', '1000000038', 3.10),
(39, 33.80, 'preparing', 'card', '22 Bourbon St, New Orleans', '1000000039', 3.50),
(40, 14.99, 'pending', 'cash', '74 Douglas Ave, Wichita', '1000000040', 2.00),

(41, 38.60, 'delivered', 'card', '19 Chester Ave, Bakersfield', '1000000041', 4.20),
(42, 25.30, 'confirmed', 'cash', '51 Fox Valley Rd, Aurora', '1000000042', 2.50),
(43, 17.85, 'completed', 'card', '46 Katella Ave, Anaheim', '1000000043', 2.00),
(44, 30.10, 'delivered', 'card', '87 Ala Moana Blvd, Honolulu', '1000000044', 3.30),
(45, 23.45, 'pending', 'cash', '27 Main St, Santa Ana', '1000000045', 2.40),

(46, 27.75, 'completed', 'card', '63 Magnolia Ave, Riverside', '1000000046', 2.75),
(47, 34.20, 'confirmed', 'card', '14 Shoreline Blvd, Corpus Christi', '1000000047', 3.60),
(48, 20.60, 'delivered', 'cash', '59 Broadway, Lexington', '1000000048', 2.30),
(49, 45.50, 'preparing', 'card', '33 Pacific Ave, Stockton', '1000000049', 4.50),
(50, 18.20, 'canceled', 'cash', '70 Olive St, St. Louis', '1000000050', 2.00),

(26, 16.90, 'completed', 'cash', '102 Ocean Dr, Miami', '1000000026', 2.00),
(27, 37.80, 'delivered', 'card', '35 Peachtree St, Atlanta', '1000000027', 3.80),
(28, 22.75, 'confirmed', 'cash', '47 Orange Ave, Orlando', '1000000028', 2.40),
(29, 26.10, 'pending', 'card', '28 Kennedy Blvd, Tampa', '1000000029', 2.60),
(30, 31.45, 'completed', 'card', '64 Euclid Ave, Cleveland', '1000000030', 3.20),

(31, 19.30, 'delivered', 'cash', '15 Vine St, Cincinnati', '1000000031', 2.10),
(32, 24.85, 'confirmed', 'card', '72 Walnut St, Kansas City', '1000000032', 2.70),
(33, 28.90, 'preparing', 'card', '91 Capitol Ave, Sacramento', '1000000033', 3.00),
(34, 17.60, 'completed', 'cash', '24 Hillsborough St, Raleigh', '1000000034', 2.00),
(35, 39.70, 'delivered', 'card', '68 Dodge St, Omaha', '1000000035', 4.00),

(36, 21.80, 'pending', 'cash', '37 Hennepin Ave, Minneapolis', '1000000036', 2.20),
(37, 29.40, 'confirmed', 'card', '58 Boulder Ave, Tulsa', '1000000037', 3.10),
(38, 32.60, 'completed', 'card', '83 Cooper St, Arlington', '1000000038', 3.40),
(39, 18.95, 'delivered', 'cash', '22 Bourbon St, New Orleans', '1000000039', 2.00),
(40, 26.75, 'preparing', 'card', '74 Douglas Ave, Wichita', '1000000040', 2.80),

(41, 15.90, 'pending', 'cash', '19 Chester Ave, Bakersfield', '1000000041', 2.00),
(42, 34.50, 'completed', 'card', '51 Fox Valley Rd, Aurora', '1000000042', 3.70),
(43, 20.40, 'confirmed', 'cash', '46 Katella Ave, Anaheim', '1000000043', 2.30),
(44, 27.95, 'delivered', 'card', '87 Ala Moana Blvd, Honolulu', '1000000044', 3.00),
(45, 36.20, 'completed', 'card', '27 Main St, Santa Ana', '1000000045', 3.80),

(46, 19.75, 'pending', 'cash', '63 Magnolia Ave, Riverside', '1000000046', 2.10),
(47, 28.60, 'confirmed', 'card', '14 Shoreline Blvd, Corpus Christi', '1000000047', 3.00),
(48, 24.30, 'delivered', 'cash', '59 Broadway, Lexington', '1000000048', 2.50),
(49, 31.80, 'completed', 'card', '33 Pacific Ave, Stockton', '1000000049', 3.30),
(50, 22.55, 'pending', 'cash', '70 Olive St, St. Louis', '1000000050', 2.40);

INSERT INTO suborders (
    order_id,
    restaurant_branch_id,
    status,
    total_price
)
VALUES
(1, 1, 'delivered', 24.98),
(2, 3, 'completed', 22.40),
(3, 5, 'delivered', 28.20),
(4, 7, 'confirmed', 16.75),
(5, 9, 'pending', 19.90),

(6, 11, 'preparing', 32.10),
(7, 13, 'delivered', 25.00),
(8, 15, 'canceled', 17.80),
(9, 17, 'completed', 37.25),
(10, 19, 'pending', 14.50),

(11, 2, 'confirmed', 26.95),
(12, 4, 'delivered', 19.00),
(13, 6, 'completed', 23.30),
(14, 8, 'preparing', 30.80),
(15, 10, 'pending', 12.99),

(16, 12, 'delivered', 34.40),
(17, 14, 'confirmed', 22.80),
(18, 16, 'completed', 15.85),
(19, 18, 'delivered', 26.80),
(20, 20, 'pending', 20.45),

(21, 1, 'completed', 25.00),
(22, 3, 'confirmed', 30.60),
(23, 5, 'delivered', 18.30),
(24, 7, 'preparing', 41.00),
(25, 9, 'canceled', 16.20),

(26, 2, 'completed', 14.90),
(27, 4, 'delivered', 34.00),
(28, 6, 'confirmed', 20.35),
(29, 8, 'pending', 23.50),
(30, 10, 'completed', 28.25),

(31, 12, 'delivered', 17.20),
(32, 14, 'confirmed', 22.15),
(33, 16, 'preparing', 25.90),
(34, 18, 'completed', 15.60),
(35, 20, 'delivered', 35.70),

(36, 11, 'pending', 19.60),
(37, 13, 'confirmed', 26.30),
(38, 15, 'completed', 29.20),
(39, 17, 'delivered', 16.95),
(40, 19, 'preparing', 24.10),

(41, 1, 'pending', 13.90),
(42, 3, 'completed', 30.80),
(43, 5, 'confirmed', 18.10),
(44, 7, 'delivered', 24.95),
(45, 9, 'completed', 32.40),

(46, 11, 'pending', 17.65),
(47, 13, 'confirmed', 25.60),
(48, 15, 'delivered', 21.80),
(49, 17, 'completed', 28.50),
(50, 19, 'pending', 20.15);

INSERT INTO order_items (
    suborder_id,
    dish_id,
    restaurant_branch_id,
    quantity,
    price
)
VALUES
-- suborders for restaurant 1 (branches 1,2 -> dishes 1-4)
(1, 1, 1, 1, 12.99),
(1, 2, 1, 1, 14.49),

(11, 3, 2, 1, 13.79),
(11, 4, 2, 1, 15.25),

(21, 1, 1, 1, 12.99),
(21, 4, 1, 1, 15.25),

(26, 2, 2, 1, 14.49),
(26, 3, 2, 1, 13.79),

(41, 1, 1, 1, 12.99),
(41, 3, 1, 1, 13.79),

-- suborders for restaurant 2 (branches 3,4 -> dishes 5-8)
(2, 5, 3, 1, 11.50),
(2, 7, 3, 1, 13.40),

(12, 6, 4, 1, 12.20),
(12, 8, 4, 1, 13.80),

(22, 5, 3, 1, 11.50),
(22, 8, 3, 1, 13.80),

(27, 6, 4, 1, 12.20),
(27, 7, 4, 2, 13.40),

(42, 5, 3, 1, 11.50),
(42, 6, 3, 1, 12.20),

-- suborders for restaurant 3 (branches 5,6 -> dishes 9-12)
(3, 9, 5, 1, 10.99),
(3, 10, 5, 1, 13.49),

(13, 11, 6, 1, 11.75),
(13, 12, 6, 1, 12.95),

(23, 9, 5, 1, 10.99),
(23, 11, 5, 1, 11.75),

(28, 10, 6, 1, 13.49),
(28, 12, 6, 1, 12.95),

(43, 9, 5, 1, 10.99),
(43, 10, 5, 1, 13.49),

-- suborders for restaurant 4 (branches 7,8 -> dishes 13-16)
(4, 13, 7, 1, 9.80),
(4, 15, 7, 1, 12.60),

(14, 14, 8, 1, 10.25),
(14, 16, 8, 2, 11.90),

(24, 15, 7, 2, 12.60),
(24, 16, 7, 1, 11.90),

(29, 13, 8, 1, 9.80),
(29, 14, 8, 1, 10.25),

(44, 13, 7, 1, 9.80),
(44, 15, 7, 1, 12.60),

-- suborders for restaurant 5 (branches 9,10 -> dishes 17-20)
(5, 17, 9, 1, 13.99),
(5, 19, 9, 1, 5.99),

(15, 18, 10, 1, 14.50),
(15, 19, 10, 1, 5.99),

(25, 19, 9, 1, 5.99),
(25, 20, 9, 1, 12.30),

(30, 17, 10, 1, 13.99),
(30, 18, 10, 1, 14.50),

(45, 18, 9, 1, 14.50),
(45, 20, 9, 1, 12.30),

-- suborders for restaurant 6 (branches 11,12 -> dishes 21-24)
(6, 21, 11, 1, 17.99),
(6, 22, 11, 1, 16.75),

(16, 23, 12, 1, 15.90),
(16, 24, 12, 1, 16.20),

(31, 21, 12, 1, 17.99),
(31, 24, 12, 1, 16.20),

(36, 22, 11, 1, 16.75),
(36, 23, 11, 1, 15.90),

(46, 21, 11, 1, 17.99),
(46, 24, 11, 1, 16.20),

-- suborders for restaurant 7 (branches 13,14 -> dishes 25-28)
(7, 25, 13, 1, 8.99),
(7, 26, 13, 1, 10.75),

(17, 27, 14, 1, 9.50),
(17, 28, 14, 1, 9.95),

(32, 25, 14, 1, 8.99),
(32, 28, 14, 1, 9.95),

(37, 26, 13, 1, 10.75),
(37, 27, 13, 1, 9.50),

(47, 25, 13, 1, 8.99),
(47, 26, 13, 1, 10.75),

-- suborders for restaurant 8 (branches 15,16 -> dishes 29-32)
(8, 29, 15, 1, 8.80),
(8, 32, 15, 1, 6.40),

(18, 30, 16, 1, 11.20),
(18, 32, 16, 1, 6.40),

(33, 29, 16, 1, 8.80),
(33, 31, 16, 1, 18.50),

(38, 30, 15, 1, 11.20),
(38, 31, 15, 1, 18.50),

(48, 29, 15, 1, 8.80),
(48, 32, 15, 2, 6.40),

-- suborders for restaurant 9 (branches 17,18 -> dishes 33-36)
(9, 33, 17, 1, 12.70),
(9, 35, 17, 1, 14.60),

(19, 34, 18, 1, 12.40),
(19, 36, 18, 1, 11.95),

(34, 33, 18, 1, 12.70),
(34, 36, 18, 1, 11.95),

(39, 34, 17, 1, 12.40),
(39, 35, 17, 1, 14.60),

(49, 33, 17, 1, 12.70),
(49, 34, 17, 1, 12.40),

-- suborders for restaurant 10 (branches 19,20 -> dishes 37-40)
(10, 37, 19, 1, 7.80),
(10, 40, 19, 1, 5.20),

(20, 38, 20, 1, 7.20),
(20, 39, 20, 1, 4.50),

(35, 37, 20, 2, 7.80),
(35, 38, 20, 1, 7.20),

(40, 39, 19, 1, 4.50),
(40, 40, 19, 1, 5.20),

(50, 37, 19, 1, 7.80),
(50, 38, 19, 1, 7.20);

INSERT INTO dish_reviews (
    user_id,
    dish_id,
    rating,
    comment
)
VALUES
(26, 1, 5, 'Excellent pizza, fresh ingredients and perfect crust.'),
(26, 21, 4, 'Fresh salmon and good portion size.'),

(27, 5, 5, 'Very tasty sushi roll, would order again.'),
(27, 37, 5, 'Cheesecake was amazing and very fresh.'),

(28, 10, 4, 'Burger was juicy and flavorful.'),
(28, 25, 4, 'Taco was delicious and well seasoned.'),

(29, 17, 5, 'Chicken curry had rich flavor and great spices.'),
(29, 33, 4, 'Noodles were good, a little spicy but enjoyable.'),

(30, 13, 4, 'Fresh salad and nice dressing.'),
(30, 39, 5, 'Croissant was buttery and soft.'),

(31, 2, 5, 'Pepperoni pizza was excellent and full of flavor.'),
(31, 29, 4, 'Onion soup was warm and comforting.'),

(32, 6, 4, 'Tuna maki tasted fresh and well prepared.'),
(32, 38, 5, 'Chocolate cake was rich and moist.'),

(33, 11, 4, 'Chicken burger was crispy and satisfying.'),
(33, 18, 5, 'Butter chicken was outstanding.'),

(34, 15, 5, 'Protein bowl was healthy and delicious.'),
(34, 31, 4, 'Steak was tender and sauce was very good.'),

(35, 7, 4, 'Shrimp nigiri was fresh and nicely presented.'),
(35, 40, 5, 'Cupcake was soft and the cream was perfect.'),

(36, 3, 4, 'Mushroom pizza had great texture and flavor.'),
(36, 22, 4, 'Shrimp platter was tasty and well cooked.'),

(37, 8, 5, 'Salmon nigiri was one of the best I have tried.'),
(37, 26, 4, 'Burrito was filling and flavorful.'),

(38, 14, 5, 'Avocado salad was fresh and light.'),
(38, 35, 4, 'Shrimp wok had great seasoning.'),

(39, 19, 4, 'Naan bread was warm and buttery.'),
(39, 34, 5, 'Beef fried rice was excellent and balanced.'),

(40, 4, 5, 'Four cheese pizza was rich and delicious.'),
(40, 30, 4, 'Crepe was soft and creamy.'),

(41, 9, 4, 'Classic beef burger was solid and satisfying.'),
(41, 24, 4, 'Fish had a nice lemon butter flavor.'),

(42, 12, 4, 'BBQ burger had a very good smoky taste.'),
(42, 32, 5, 'Vanilla eclair was fresh and beautifully made.'),

(43, 16, 5, 'Veggie bowl was healthy and surprisingly filling.'),
(43, 27, 4, 'Quesadilla was cheesy and crispy.'),

(44, 20, 4, 'Vegetable curry had a nice spicy kick.'),
(44, 36, 4, 'Chicken rice was tasty and well cooked.'),

(45, 23, 5, 'Seafood rice bowl was fresh and flavorful.'),
(45, 37, 5, 'Cheesecake was easily the best dessert I ordered.'),

(46, 28, 4, 'Shrimp taco was light and very tasty.'),
(46, 38, 5, 'Chocolate cake was excellent and not too sweet.'),

(47, 1, 4, 'Pizza was very good and arrived warm.'),
(47, 25, 5, 'Beef taco had perfect seasoning and texture.'),

(48, 6, 4, 'Tuna maki was fresh and nicely rolled.'),
(48, 39, 4, 'Croissant was flaky and buttery.'),

(49, 18, 5, 'Butter chicken was creamy and flavorful.'),
(49, 33, 4, 'Chicken noodles were delicious and satisfying.'),

(50, 21, 5, 'Grilled salmon was fresh and perfectly cooked.'),
(50, 40, 4, 'Vanilla cupcake was soft and tasty.');

