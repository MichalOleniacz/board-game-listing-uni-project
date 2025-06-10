CREATE EXTENSION IF NOT EXISTS "pgcrypto";

CREATE TABLE IF NOT EXISTS users (
                                     id UUID PRIMARY KEY,
                                     username VARCHAR(50) NOT NULL UNIQUE,
                                     email VARCHAR(255) NOT NULL UNIQUE,
                                     password_hash VARCHAR(255) NOT NULL,
                                     role VARCHAR(20) NOT NULL
);

CREATE TABLE IF NOT EXISTS categories (
                                           id SERIAL PRIMARY KEY,
                                           category_name VARCHAR(50)
);

CREATE TABLE IF NOT EXISTS user_preference (
                                               userId UUID NOT NULL,
                                               preferenceId INT NOT NULL,
                                               PRIMARY KEY (userId, preferenceId),
                                               FOREIGN KEY (userId) REFERENCES users(id) ON DELETE CASCADE,
                                               FOREIGN KEY (preferenceId) REFERENCES categories(id) ON DELETE CASCADE
);

INSERT INTO users (id, username, email, password_hash, role)
VALUES
    (gen_random_uuid(), 'dummy-1', 'dummy-1@example.com', 'e961696cafc92ed32672ab803f92ecb2412067caa5f07e900f59c68f7663c244', 'USER'),
    (gen_random_uuid(), 'dummy-2', 'dummy-2@example.com', 'e961696cafc92ed32672ab803f92ecb2412067caa5f07e900f59c68f7663c244', 'USER'),
    (gen_random_uuid(), 'dummy-3', 'dummy-3@example.com', 'e961696cafc92ed32672ab803f92ecb2412067caa5f07e900f59c68f7663c244', 'USER'),
    (gen_random_uuid(), 'dummy-4', 'dummy-4@example.com', 'e961696cafc92ed32672ab803f92ecb2412067caa5f07e900f59c68f7663c244', 'USER'),
    (gen_random_uuid(), 'dummy-5', 'dummy-5@example.com', 'e961696cafc92ed32672ab803f92ecb2412067caa5f07e900f59c68f7663c244', 'USER');

CREATE TABLE IF NOT EXISTS games (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    title VARCHAR(100) NOT NULL,
    description TEXT,
    min_players INT,
    max_players INT,
    playtime_minutes INT,
    publisher VARCHAR(100),
    year_published INT,
    image_url TEXT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE IF NOT EXISTS game_category (
    game_id UUID NOT NULL,
    category_id INT NOT NULL,
    PRIMARY KEY (game_id, category_id),
    FOREIGN KEY (game_id) REFERENCES games(id) ON DELETE CASCADE,
    FOREIGN KEY (category_id) REFERENCES categories(id) ON DELETE CASCADE
);

CREATE TABLE IF NOT EXISTS reviews (
    id SERIAL PRIMARY KEY,
    user_id UUID NOT NULL,
    game_id UUID NOT NULL,
    rating INT CHECK (rating BETWEEN 1 AND 5),
    comment TEXT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE,
    FOREIGN KEY (game_id) REFERENCES games(id) ON DELETE CASCADE
);

CREATE VIEW game_ranking AS
    SELECT
        g.*,
        AVG(rating) AS avg_rating
    FROM reviews r
        LEFT JOIN games g ON r.game_id = g.id
    GROUP BY g.id, g.title, g.description, g.min_players, g.max_players, g.playtime_minutes, g.publisher, g.year_published, g.image_url, g.created_at ORDER BY avg_rating DESC;

SELECT * FROM users;

-- USERS
INSERT INTO users (id, username, email, password_hash, role) VALUES ('39186206-a1d6-4dd9-b1fd-d87e0246da38', 'user-1', 'user-1@dummy.com', 'e961696cafc92ed32672ab803f92ecb2412067caa5f07e900f59c68f7663c244', 'USER');
INSERT INTO users (id, username, email, password_hash, role) VALUES ('62263b94-9883-4258-9687-25e156ca979d', 'user-2', 'user-2@dummy.com', 'e961696cafc92ed32672ab803f92ecb2412067caa5f07e900f59c68f7663c244', 'USER');
INSERT INTO users (id, username, email, password_hash, role) VALUES ('dd174a9e-5695-4e56-95d2-673cb68f4b22', 'user-3', 'user-3@dummy.com', 'e961696cafc92ed32672ab803f92ecb2412067caa5f07e900f59c68f7663c244', 'USER');
INSERT INTO users (id, username, email, password_hash, role) VALUES ('3b1fae75-06bf-4866-8a92-5eb50f2ae19e', 'user-4', 'user-4@dummy.com', 'e961696cafc92ed32672ab803f92ecb2412067caa5f07e900f59c68f7663c244', 'USER');
INSERT INTO users (id, username, email, password_hash, role) VALUES ('805fe1c3-bb4d-42b8-92da-76296354feff', 'user-5', 'user-5@dummy.com', 'e961696cafc92ed32672ab803f92ecb2412067caa5f07e900f59c68f7663c244', 'USER');
INSERT INTO users (id, username, email, password_hash, role) VALUES ('b8c7fa17-e9ae-4ed5-af9c-d2c9b70ffa83', 'user-6', 'user-6@dummy.com', 'e961696cafc92ed32672ab803f92ecb2412067caa5f07e900f59c68f7663c244', 'USER');
INSERT INTO users (id, username, email, password_hash, role) VALUES ('5067482c-067b-4f1e-a022-8a5dcce96000', 'user-7', 'user-7@dummy.com', 'e961696cafc92ed32672ab803f92ecb2412067caa5f07e900f59c68f7663c244', 'USER');
INSERT INTO users (id, username, email, password_hash, role) VALUES ('8bc6d8f4-c51c-41c0-abb6-5ff9e91cc873', 'user-8', 'user-8@dummy.com', 'e961696cafc92ed32672ab803f92ecb2412067caa5f07e900f59c68f7663c244', 'USER');
INSERT INTO users (id, username, email, password_hash, role) VALUES ('23890d04-cb1a-44bf-b120-d2fbea08302e', 'user-9', 'user-9@dummy.com', 'e961696cafc92ed32672ab803f92ecb2412067caa5f07e900f59c68f7663c244', 'USER');
INSERT INTO users (id, username, email, password_hash, role) VALUES ('aa6af5a0-e364-4b14-bf64-15daa22d79f4', 'user-10', 'user-10@dummy.com', 'e961696cafc92ed32672ab803f92ecb2412067caa5f07e900f59c68f7663c244', 'USER');
INSERT INTO users (id, username, email, password_hash, role) VALUES ('feed9ce3-4cf7-4317-9c54-aa5508a1eb61', 'user-11', 'user-11@dummy.com', 'e961696cafc92ed32672ab803f92ecb2412067caa5f07e900f59c68f7663c244', 'USER');
INSERT INTO users (id, username, email, password_hash, role) VALUES ('d150bb63-fbe0-4edc-9ba3-26f6faea7281', 'user-12', 'user-12@dummy.com', 'e961696cafc92ed32672ab803f92ecb2412067caa5f07e900f59c68f7663c244', 'USER');
INSERT INTO users (id, username, email, password_hash, role) VALUES ('1509d701-f954-4338-9b00-25acc7137710', 'user-13', 'user-13@dummy.com', 'e961696cafc92ed32672ab803f92ecb2412067caa5f07e900f59c68f7663c244', 'USER');
INSERT INTO users (id, username, email, password_hash, role) VALUES ('d249d5f7-af23-462c-a36c-c9c6c0691564', 'user-14', 'user-14@dummy.com', 'e961696cafc92ed32672ab803f92ecb2412067caa5f07e900f59c68f7663c244', 'USER');
INSERT INTO users (id, username, email, password_hash, role) VALUES ('43bd33ef-2afe-4907-aaa2-8702985e7048', 'user-15', 'user-15@dummy.com', 'e961696cafc92ed32672ab803f92ecb2412067caa5f07e900f59c68f7663c244', 'USER');
INSERT INTO users (id, username, email, password_hash, role) VALUES ('2ed6bf69-6ded-4ac6-a54c-b65202c152b3', 'user-16', 'user-16@dummy.com', 'e961696cafc92ed32672ab803f92ecb2412067caa5f07e900f59c68f7663c244', 'USER');
INSERT INTO users (id, username, email, password_hash, role) VALUES ('8b0161b8-166c-48ec-a470-67fa54d7e9b6', 'user-17', 'user-17@dummy.com', 'e961696cafc92ed32672ab803f92ecb2412067caa5f07e900f59c68f7663c244', 'USER');
INSERT INTO users (id, username, email, password_hash, role) VALUES ('4c47ac92-c97d-4c3c-b022-17c5944d15ff', 'user-18', 'user-18@dummy.com', 'e961696cafc92ed32672ab803f92ecb2412067caa5f07e900f59c68f7663c244', 'USER');
INSERT INTO users (id, username, email, password_hash, role) VALUES ('8c620869-4e8c-48d7-929c-fe5876872955', 'user-19', 'user-19@dummy.com', 'e961696cafc92ed32672ab803f92ecb2412067caa5f07e900f59c68f7663c244', 'USER');
INSERT INTO users (id, username, email, password_hash, role) VALUES ('ef95e107-6847-4697-9f5e-fcadcb995fc1', 'user-20', 'user-20@dummy.com', 'e961696cafc92ed32672ab803f92ecb2412067caa5f07e900f59c68f7663c244', 'USER');
INSERT INTO users (id, username, email, password_hash, role) VALUES ('15896e14-ceaa-4c6a-99fc-c7e147b28aa7', 'user-21', 'user-21@dummy.com', 'e961696cafc92ed32672ab803f92ecb2412067caa5f07e900f59c68f7663c244', 'USER');
INSERT INTO users (id, username, email, password_hash, role) VALUES ('37564d79-fb85-48aa-bda7-6ff46d0fe4ab', 'user-22', 'user-22@dummy.com', 'e961696cafc92ed32672ab803f92ecb2412067caa5f07e900f59c68f7663c244', 'USER');
INSERT INTO users (id, username, email, password_hash, role) VALUES ('d0d44a71-fc99-4b0f-8c86-6e0f2ef1f1eb', 'user-23', 'user-23@dummy.com', 'e961696cafc92ed32672ab803f92ecb2412067caa5f07e900f59c68f7663c244', 'USER');
INSERT INTO users (id, username, email, password_hash, role) VALUES ('e6f49920-30b4-453b-82ea-7ebdf094d4e3', 'user-24', 'user-24@dummy.com', 'e961696cafc92ed32672ab803f92ecb2412067caa5f07e900f59c68f7663c244', 'USER');
INSERT INTO users (id, username, email, password_hash, role) VALUES ('21f0c7f4-c15d-4f7b-aefe-2a3461a65b46', 'user-25', 'user-25@dummy.com', 'e961696cafc92ed32672ab803f92ecb2412067caa5f07e900f59c68f7663c244', 'USER');
INSERT INTO users (id, username, email, password_hash, role) VALUES ('21f0c7f4-c15d-4f7b-aefe-2a3461b12345', 'admin-2', 'admin-2@dummy.com', 'e961696cafc92ed32672ab803f92ecb2412067caa5f07e900f59c68f7663c244', 'ADMIN');

-- CATEGORIES
INSERT INTO categories (id, category_name) VALUES (1, 'Strategy');
INSERT INTO categories (id, category_name) VALUES (2, 'Co-op');
INSERT INTO categories (id, category_name) VALUES (3, 'Fantasy');
INSERT INTO categories (id, category_name) VALUES (4, 'Sci-fi');
INSERT INTO categories (id, category_name) VALUES (5, 'Deck-building');
INSERT INTO categories (id, category_name) VALUES (6, 'Card Game');
INSERT INTO categories (id, category_name) VALUES (7, 'Party');
INSERT INTO categories (id, category_name) VALUES (8, 'Abstract');
INSERT INTO categories (id, category_name) VALUES (9, 'Solo');
INSERT INTO categories (id, category_name) VALUES (10, 'Economic');
INSERT INTO categories (id, category_name) VALUES (11, 'RPG');
INSERT INTO categories (id, category_name) VALUES (12, 'Adventure');
INSERT INTO categories (id, category_name) VALUES (13, 'Puzzle');
INSERT INTO categories (id, category_name) VALUES (14, 'Bluffing');
INSERT INTO categories (id, category_name) VALUES (15, 'Negotiation');
INSERT INTO categories (id, category_name) VALUES (16, 'Area Control');
INSERT INTO categories (id, category_name) VALUES (17, 'Tile Placement');
INSERT INTO categories (id, category_name) VALUES (18, 'Storytelling');
INSERT INTO categories (id, category_name) VALUES (19, 'Dexterity');
INSERT INTO categories (id, category_name) VALUES (20, 'Set Collection');

-- USER PREFERENCES
INSERT INTO user_preference (userId, preferenceId) VALUES ('39186206-a1d6-4dd9-b1fd-d87e0246da38', 17);
INSERT INTO user_preference (userId, preferenceId) VALUES ('39186206-a1d6-4dd9-b1fd-d87e0246da38', 6);
INSERT INTO user_preference (userId, preferenceId) VALUES ('39186206-a1d6-4dd9-b1fd-d87e0246da38', 19);
INSERT INTO user_preference (userId, preferenceId) VALUES ('39186206-a1d6-4dd9-b1fd-d87e0246da38', 1);
INSERT INTO user_preference (userId, preferenceId) VALUES ('62263b94-9883-4258-9687-25e156ca979d', 6);
INSERT INTO user_preference (userId, preferenceId) VALUES ('62263b94-9883-4258-9687-25e156ca979d', 11);
INSERT INTO user_preference (userId, preferenceId) VALUES ('62263b94-9883-4258-9687-25e156ca979d', 14);
INSERT INTO user_preference (userId, preferenceId) VALUES ('62263b94-9883-4258-9687-25e156ca979d', 16);
INSERT INTO user_preference (userId, preferenceId) VALUES ('dd174a9e-5695-4e56-95d2-673cb68f4b22', 20);
INSERT INTO user_preference (userId, preferenceId) VALUES ('dd174a9e-5695-4e56-95d2-673cb68f4b22', 18);
INSERT INTO user_preference (userId, preferenceId) VALUES ('dd174a9e-5695-4e56-95d2-673cb68f4b22', 4);
INSERT INTO user_preference (userId, preferenceId) VALUES ('dd174a9e-5695-4e56-95d2-673cb68f4b22', 19);
INSERT INTO user_preference (userId, preferenceId) VALUES ('3b1fae75-06bf-4866-8a92-5eb50f2ae19e', 3);
INSERT INTO user_preference (userId, preferenceId) VALUES ('3b1fae75-06bf-4866-8a92-5eb50f2ae19e', 7);
INSERT INTO user_preference (userId, preferenceId) VALUES ('3b1fae75-06bf-4866-8a92-5eb50f2ae19e', 16);
INSERT INTO user_preference (userId, preferenceId) VALUES ('3b1fae75-06bf-4866-8a92-5eb50f2ae19e', 8);
INSERT INTO user_preference (userId, preferenceId) VALUES ('805fe1c3-bb4d-42b8-92da-76296354feff', 2);
INSERT INTO user_preference (userId, preferenceId) VALUES ('805fe1c3-bb4d-42b8-92da-76296354feff', 3);
INSERT INTO user_preference (userId, preferenceId) VALUES ('805fe1c3-bb4d-42b8-92da-76296354feff', 12);
INSERT INTO user_preference (userId, preferenceId) VALUES ('805fe1c3-bb4d-42b8-92da-76296354feff', 11);
INSERT INTO user_preference (userId, preferenceId) VALUES ('b8c7fa17-e9ae-4ed5-af9c-d2c9b70ffa83', 2);
INSERT INTO user_preference (userId, preferenceId) VALUES ('b8c7fa17-e9ae-4ed5-af9c-d2c9b70ffa83', 16);
INSERT INTO user_preference (userId, preferenceId) VALUES ('b8c7fa17-e9ae-4ed5-af9c-d2c9b70ffa83', 14);
INSERT INTO user_preference (userId, preferenceId) VALUES ('b8c7fa17-e9ae-4ed5-af9c-d2c9b70ffa83', 5);
INSERT INTO user_preference (userId, preferenceId) VALUES ('5067482c-067b-4f1e-a022-8a5dcce96000', 17);
INSERT INTO user_preference (userId, preferenceId) VALUES ('5067482c-067b-4f1e-a022-8a5dcce96000', 20);
INSERT INTO user_preference (userId, preferenceId) VALUES ('5067482c-067b-4f1e-a022-8a5dcce96000', 8);
INSERT INTO user_preference (userId, preferenceId) VALUES ('5067482c-067b-4f1e-a022-8a5dcce96000', 14);
INSERT INTO user_preference (userId, preferenceId) VALUES ('8bc6d8f4-c51c-41c0-abb6-5ff9e91cc873', 14);
INSERT INTO user_preference (userId, preferenceId) VALUES ('8bc6d8f4-c51c-41c0-abb6-5ff9e91cc873', 17);
INSERT INTO user_preference (userId, preferenceId) VALUES ('8bc6d8f4-c51c-41c0-abb6-5ff9e91cc873', 2);
INSERT INTO user_preference (userId, preferenceId) VALUES ('8bc6d8f4-c51c-41c0-abb6-5ff9e91cc873', 9);
INSERT INTO user_preference (userId, preferenceId) VALUES ('23890d04-cb1a-44bf-b120-d2fbea08302e', 16);
INSERT INTO user_preference (userId, preferenceId) VALUES ('23890d04-cb1a-44bf-b120-d2fbea08302e', 7);
INSERT INTO user_preference (userId, preferenceId) VALUES ('23890d04-cb1a-44bf-b120-d2fbea08302e', 2);
INSERT INTO user_preference (userId, preferenceId) VALUES ('23890d04-cb1a-44bf-b120-d2fbea08302e', 20);
INSERT INTO user_preference (userId, preferenceId) VALUES ('aa6af5a0-e364-4b14-bf64-15daa22d79f4', 9);
INSERT INTO user_preference (userId, preferenceId) VALUES ('aa6af5a0-e364-4b14-bf64-15daa22d79f4', 15);
INSERT INTO user_preference (userId, preferenceId) VALUES ('aa6af5a0-e364-4b14-bf64-15daa22d79f4', 12);
INSERT INTO user_preference (userId, preferenceId) VALUES ('aa6af5a0-e364-4b14-bf64-15daa22d79f4', 1);
INSERT INTO user_preference (userId, preferenceId) VALUES ('feed9ce3-4cf7-4317-9c54-aa5508a1eb61', 15);
INSERT INTO user_preference (userId, preferenceId) VALUES ('feed9ce3-4cf7-4317-9c54-aa5508a1eb61', 13);
INSERT INTO user_preference (userId, preferenceId) VALUES ('feed9ce3-4cf7-4317-9c54-aa5508a1eb61', 16);
INSERT INTO user_preference (userId, preferenceId) VALUES ('feed9ce3-4cf7-4317-9c54-aa5508a1eb61', 6);
INSERT INTO user_preference (userId, preferenceId) VALUES ('d150bb63-fbe0-4edc-9ba3-26f6faea7281', 19);
INSERT INTO user_preference (userId, preferenceId) VALUES ('d150bb63-fbe0-4edc-9ba3-26f6faea7281', 11);
INSERT INTO user_preference (userId, preferenceId) VALUES ('d150bb63-fbe0-4edc-9ba3-26f6faea7281', 7);
INSERT INTO user_preference (userId, preferenceId) VALUES ('d150bb63-fbe0-4edc-9ba3-26f6faea7281', 18);
INSERT INTO user_preference (userId, preferenceId) VALUES ('1509d701-f954-4338-9b00-25acc7137710', 16);
INSERT INTO user_preference (userId, preferenceId) VALUES ('1509d701-f954-4338-9b00-25acc7137710', 3);
INSERT INTO user_preference (userId, preferenceId) VALUES ('1509d701-f954-4338-9b00-25acc7137710', 14);
INSERT INTO user_preference (userId, preferenceId) VALUES ('1509d701-f954-4338-9b00-25acc7137710', 5);
INSERT INTO user_preference (userId, preferenceId) VALUES ('d249d5f7-af23-462c-a36c-c9c6c0691564', 17);
INSERT INTO user_preference (userId, preferenceId) VALUES ('d249d5f7-af23-462c-a36c-c9c6c0691564', 18);
INSERT INTO user_preference (userId, preferenceId) VALUES ('d249d5f7-af23-462c-a36c-c9c6c0691564', 10);
INSERT INTO user_preference (userId, preferenceId) VALUES ('d249d5f7-af23-462c-a36c-c9c6c0691564', 11);
INSERT INTO user_preference (userId, preferenceId) VALUES ('43bd33ef-2afe-4907-aaa2-8702985e7048', 3);
INSERT INTO user_preference (userId, preferenceId) VALUES ('43bd33ef-2afe-4907-aaa2-8702985e7048', 9);
INSERT INTO user_preference (userId, preferenceId) VALUES ('43bd33ef-2afe-4907-aaa2-8702985e7048', 1);
INSERT INTO user_preference (userId, preferenceId) VALUES ('43bd33ef-2afe-4907-aaa2-8702985e7048', 19);
INSERT INTO user_preference (userId, preferenceId) VALUES ('2ed6bf69-6ded-4ac6-a54c-b65202c152b3', 6);
INSERT INTO user_preference (userId, preferenceId) VALUES ('2ed6bf69-6ded-4ac6-a54c-b65202c152b3', 1);
INSERT INTO user_preference (userId, preferenceId) VALUES ('2ed6bf69-6ded-4ac6-a54c-b65202c152b3', 10);
INSERT INTO user_preference (userId, preferenceId) VALUES ('2ed6bf69-6ded-4ac6-a54c-b65202c152b3', 13);
INSERT INTO user_preference (userId, preferenceId) VALUES ('8b0161b8-166c-48ec-a470-67fa54d7e9b6', 20);
INSERT INTO user_preference (userId, preferenceId) VALUES ('8b0161b8-166c-48ec-a470-67fa54d7e9b6', 12);
INSERT INTO user_preference (userId, preferenceId) VALUES ('8b0161b8-166c-48ec-a470-67fa54d7e9b6', 6);
INSERT INTO user_preference (userId, preferenceId) VALUES ('8b0161b8-166c-48ec-a470-67fa54d7e9b6', 5);
INSERT INTO user_preference (userId, preferenceId) VALUES ('4c47ac92-c97d-4c3c-b022-17c5944d15ff', 2);
INSERT INTO user_preference (userId, preferenceId) VALUES ('4c47ac92-c97d-4c3c-b022-17c5944d15ff', 14);
INSERT INTO user_preference (userId, preferenceId) VALUES ('4c47ac92-c97d-4c3c-b022-17c5944d15ff', 13);
INSERT INTO user_preference (userId, preferenceId) VALUES ('4c47ac92-c97d-4c3c-b022-17c5944d15ff', 9);
INSERT INTO user_preference (userId, preferenceId) VALUES ('8c620869-4e8c-48d7-929c-fe5876872955', 19);
INSERT INTO user_preference (userId, preferenceId) VALUES ('8c620869-4e8c-48d7-929c-fe5876872955', 16);
INSERT INTO user_preference (userId, preferenceId) VALUES ('8c620869-4e8c-48d7-929c-fe5876872955', 18);
INSERT INTO user_preference (userId, preferenceId) VALUES ('8c620869-4e8c-48d7-929c-fe5876872955', 10);
INSERT INTO user_preference (userId, preferenceId) VALUES ('ef95e107-6847-4697-9f5e-fcadcb995fc1', 7);
INSERT INTO user_preference (userId, preferenceId) VALUES ('ef95e107-6847-4697-9f5e-fcadcb995fc1', 5);
INSERT INTO user_preference (userId, preferenceId) VALUES ('ef95e107-6847-4697-9f5e-fcadcb995fc1', 10);
INSERT INTO user_preference (userId, preferenceId) VALUES ('ef95e107-6847-4697-9f5e-fcadcb995fc1', 17);
INSERT INTO user_preference (userId, preferenceId) VALUES ('15896e14-ceaa-4c6a-99fc-c7e147b28aa7', 16);
INSERT INTO user_preference (userId, preferenceId) VALUES ('15896e14-ceaa-4c6a-99fc-c7e147b28aa7', 7);
INSERT INTO user_preference (userId, preferenceId) VALUES ('15896e14-ceaa-4c6a-99fc-c7e147b28aa7', 4);
INSERT INTO user_preference (userId, preferenceId) VALUES ('15896e14-ceaa-4c6a-99fc-c7e147b28aa7', 19);
INSERT INTO user_preference (userId, preferenceId) VALUES ('37564d79-fb85-48aa-bda7-6ff46d0fe4ab', 3);
INSERT INTO user_preference (userId, preferenceId) VALUES ('37564d79-fb85-48aa-bda7-6ff46d0fe4ab', 19);
INSERT INTO user_preference (userId, preferenceId) VALUES ('37564d79-fb85-48aa-bda7-6ff46d0fe4ab', 9);
INSERT INTO user_preference (userId, preferenceId) VALUES ('37564d79-fb85-48aa-bda7-6ff46d0fe4ab', 12);
INSERT INTO user_preference (userId, preferenceId) VALUES ('d0d44a71-fc99-4b0f-8c86-6e0f2ef1f1eb', 7);
INSERT INTO user_preference (userId, preferenceId) VALUES ('d0d44a71-fc99-4b0f-8c86-6e0f2ef1f1eb', 19);
INSERT INTO user_preference (userId, preferenceId) VALUES ('d0d44a71-fc99-4b0f-8c86-6e0f2ef1f1eb', 10);
INSERT INTO user_preference (userId, preferenceId) VALUES ('d0d44a71-fc99-4b0f-8c86-6e0f2ef1f1eb', 2);
INSERT INTO user_preference (userId, preferenceId) VALUES ('e6f49920-30b4-453b-82ea-7ebdf094d4e3', 3);
INSERT INTO user_preference (userId, preferenceId) VALUES ('e6f49920-30b4-453b-82ea-7ebdf094d4e3', 9);
INSERT INTO user_preference (userId, preferenceId) VALUES ('e6f49920-30b4-453b-82ea-7ebdf094d4e3', 16);
INSERT INTO user_preference (userId, preferenceId) VALUES ('e6f49920-30b4-453b-82ea-7ebdf094d4e3', 4);
INSERT INTO user_preference (userId, preferenceId) VALUES ('21f0c7f4-c15d-4f7b-aefe-2a3461a65b46', 15);
INSERT INTO user_preference (userId, preferenceId) VALUES ('21f0c7f4-c15d-4f7b-aefe-2a3461a65b46', 2);
INSERT INTO user_preference (userId, preferenceId) VALUES ('21f0c7f4-c15d-4f7b-aefe-2a3461a65b46', 17);
INSERT INTO user_preference (userId, preferenceId) VALUES ('21f0c7f4-c15d-4f7b-aefe-2a3461a65b46', 7);

-- GAMES
INSERT INTO games (id, title, description, min_players, max_players, playtime_minutes, publisher, year_published, image_url) VALUES ('8aba0cd0-5ec2-4b50-b227-aa7299faf2f6', 'Catan', 'Story clearly collection perform right them those nice. Collection very American defense radio wide interest. Movie item modern recent.', 1, 6, 90, 'Page LLC', 2017, 'https://example.com/catan.jpg');
INSERT INTO games (id, title, description, min_players, max_players, playtime_minutes, publisher, year_published, image_url) VALUES ('4c0c7e6b-d6d8-4c42-a9a4-637417e7074e', 'Carcassonne', 'Risk chair score follow those page important. My eight building artist meeting including. Shoulder thought just option.
Soldier and research professor almost news. Girl focus its fall.', 2, 6, 45, 'Wiley, Wright and Jones', 2024, 'https://example.com/carcassonne.jpg');
INSERT INTO games (id, title, description, min_players, max_players, playtime_minutes, publisher, year_published, image_url) VALUES ('0baf8b14-51e1-4227-b86d-5bc07c9c55f6', '7 Wonders', 'Condition read interesting audience many. Station nothing better national perform main.
Consumer pay agreement develop fill environment.
Stand school international admit suggest figure.', 1, 4, 90, 'Baker PLC', 2012, 'https://example.com/7_wonders.jpg');
INSERT INTO games (id, title, description, min_players, max_players, playtime_minutes, publisher, year_published, image_url) VALUES ('782c8942-2d62-44a7-a2d1-08525684783c', 'Ticket to Ride', 'Power prove decade bring firm protect claim. Campaign student Mr skin company. Thank Congress bill technology.', 2, 4, 120, 'Lam-Morales', 2019, 'https://example.com/ticket_to_ride.jpg');
INSERT INTO games (id, title, description, min_players, max_players, playtime_minutes, publisher, year_published, image_url) VALUES ('69ac088b-7d9e-4364-b094-ffc3af30c125', 'Dominion', 'Determine someone on instead likely ago. Finally whether certain each individual. Politics yes into continue least. Necessary drop along second member.', 1, 6, 30, 'Burgess-Henderson', 1995, 'https://example.com/dominion.jpg');
INSERT INTO games (id, title, description, min_players, max_players, playtime_minutes, publisher, year_published, image_url) VALUES ('774700cb-a3ac-4ecb-bb70-a662e4b4368a', 'Pandemic', 'Break each out few who big cup. What go politics.
Wait task material for himself box staff. Certainly that fill score week another along pull. Turn pull crime nearly.', 2, 6, 60, 'Cohen, Brown and Chan', 2010, 'https://example.com/pandemic.jpg');
INSERT INTO games (id, title, description, min_players, max_players, playtime_minutes, publisher, year_published, image_url) VALUES ('8834d871-5ee7-4c23-a48d-4e99e84f131d', 'Gloomhaven', 'Fact at provide beautiful scientist.
In song build family serve drug market. Customer trial movie speech someone between morning. Power note take.
Form also traditional consumer.', 1, 5, 60, 'Smith, Russell and Smith', 2019, 'https://example.com/gloomhaven.jpg');
INSERT INTO games (id, title, description, min_players, max_players, playtime_minutes, publisher, year_published, image_url) VALUES ('779c9d95-ed98-4f89-a04a-c4b28a96c487', 'Wingspan', 'Eye provide parent site energy yet. Future health less would apply develop address treatment.
Others ask her allow sense trade. Do care tough leader into little young.', 1, 4, 60, 'Williams and Sons', 1995, 'https://example.com/wingspan.jpg');
INSERT INTO games (id, title, description, min_players, max_players, playtime_minutes, publisher, year_published, image_url) VALUES ('a17a2ecd-e3bf-424e-8b96-97cda76f6b21', 'Azul', 'Buy pass government early. Minute career child bit mouth kitchen two.', 2, 6, 45, 'Estes Inc', 2001, 'https://example.com/azul.jpg');
INSERT INTO games (id, title, description, min_players, max_players, playtime_minutes, publisher, year_published, image_url) VALUES ('71eb8d1e-87a7-403a-a567-b77ad63b139f', 'Splendor', 'What president hand federal account. Task bag race truth close none visit.
Defense instead someone production station career.', 1, 6, 30, 'Sanders-Delacruz', 2023, 'https://example.com/splendor.jpg');
INSERT INTO games (id, title, description, min_players, max_players, playtime_minutes, publisher, year_published, image_url) VALUES ('f3b9670b-a56c-4f43-9f31-d819f298973b', 'Root', 'Impact across best according control mention option. Guess low culture more power old four surface. Suddenly traditional even popular star law various.', 2, 5, 120, 'Johnson-Fuller', 2011, 'https://example.com/root.jpg');
INSERT INTO games (id, title, description, min_players, max_players, playtime_minutes, publisher, year_published, image_url) VALUES ('840b898b-a88b-4b58-9b17-6f4ca13c59b6', 'Ark Nova', 'Become management store event third.
Bring employee they street. Behind number effort young do. Spend show customer.
Couple start man even PM how. Policy area about break truth.', 2, 5, 90, 'Fuentes, Miller and Wood', 2014, 'https://example.com/ark_nova.jpg');
INSERT INTO games (id, title, description, min_players, max_players, playtime_minutes, publisher, year_published, image_url) VALUES ('2629c56c-b011-479a-baa0-9a48b335d91c', 'Everdell', 'Any tough pay country hand when. Into cover level need admit.
Quality term baby. Watch foreign dog pretty interesting.', 1, 4, 90, 'Moore, Ward and Johnson', 2014, 'https://example.com/everdell.jpg');
INSERT INTO games (id, title, description, min_players, max_players, playtime_minutes, publisher, year_published, image_url) VALUES ('760c629d-11ee-445b-81e3-8c87f8d0e6c6', 'The Crew', 'Attorney quite too include wide.
Full even according create example rise. Fine like green series improve than action. He much me paper tax management kid.
Us development line try crime.', 2, 5, 30, 'Rodriguez Group', 2024, 'https://example.com/the_crew.jpg');
INSERT INTO games (id, title, description, min_players, max_players, playtime_minutes, publisher, year_published, image_url) VALUES ('9edcb005-d2b1-4719-850f-e8066a4017f3', 'Patchwork', 'Beat young fish I. Something ground according contain. Hope theory force window.
Point suffer improve itself young example school. Like never include fight should thank. Class it wonder energy.', 2, 6, 90, 'Kirby, Barnett and Morales', 2004, 'https://example.com/patchwork.jpg');
INSERT INTO games (id, title, description, min_players, max_players, playtime_minutes, publisher, year_published, image_url) VALUES ('31d67f68-5550-4d5f-9e36-333f1334fd48', 'Galaxy Trucker', 'Middle tonight Mr collection dog skin. Up attorney finish source far. Identify wrong good something city.', 1, 6, 45, 'Morgan Group', 2018, 'https://example.com/galaxy_trucker.jpg');
INSERT INTO games (id, title, description, min_players, max_players, playtime_minutes, publisher, year_published, image_url) VALUES ('afa64ae4-a49e-4cdc-abc8-6cee7b674864', 'The Resistance', 'Chance outside event building whatever see notice. Although too moment book class tax.', 1, 4, 90, 'Reyes, Wiggins and Allen', 2018, 'https://example.com/the_resistance.jpg');
INSERT INTO games (id, title, description, min_players, max_players, playtime_minutes, publisher, year_published, image_url) VALUES ('5f0e793e-92ed-41ab-b120-6570a49d7679', 'Twilight Struggle', 'Nice support station community staff girl.
Catch newspaper when indicate money. Member general much perform. Medical sort later road marriage.', 1, 4, 30, 'Hayes Ltd', 2007, 'https://example.com/twilight_struggle.jpg');
INSERT INTO games (id, title, description, min_players, max_players, playtime_minutes, publisher, year_published, image_url) VALUES ('fbf3d1b9-0958-4292-80d2-385539ff62a7', 'Love Letter', 'Fight mission full huge see. Require you drop huge for prevent. Alone across join Democrat once adult drop.', 2, 5, 90, 'Mcneil LLC', 2000, 'https://example.com/love_letter.jpg');
INSERT INTO games (id, title, description, min_players, max_players, playtime_minutes, publisher, year_published, image_url) VALUES ('f55c648a-1a52-4de9-9e6f-34fe19435a24', 'Blood Rage', 'Serious wind laugh both. Unit indeed knowledge race miss push practice.
Anything source laugh. Around feeling capital another.', 1, 6, 90, 'Costa Inc', 2005, 'https://example.com/blood_rage.jpg');
INSERT INTO games (id, title, description, min_players, max_players, playtime_minutes, publisher, year_published, image_url) VALUES ('3e33cf9d-d5fc-468e-9128-035d486d6e2d', 'Lost Ruins of Arnak', 'Case ever seat account sound different. Address themselves full both.
Wear gas likely until. Lead buy American range simply meet. Science market particularly seven model responsibility start.', 2, 4, 30, 'Robinson-Garcia', 2020, 'https://example.com/lost_ruins_of_arnak.jpg');
INSERT INTO games (id, title, description, min_players, max_players, playtime_minutes, publisher, year_published, image_url) VALUES ('bdf4adc5-43dc-4278-bd88-1dc72daa2468', 'Isle of Skye', 'I gas phone be almost board deal. Understand first speak leave news.
List what chair partner. Community score entire American product once particular moment.', 2, 6, 90, 'Bowman-Pacheco', 2011, 'https://example.com/isle_of_skye.jpg');
INSERT INTO games (id, title, description, min_players, max_players, playtime_minutes, publisher, year_published, image_url) VALUES ('b05fc5ad-8eb5-4125-8dbf-d85047a6e7db', 'Kingdomino', 'Likely rule discuss why contain public research. Group find surface face break.
Card personal star beyond. Clear necessary friend position house material enter. Way spend play democratic step girl.', 1, 5, 60, 'Mccann, Russell and Doyle', 2023, 'https://example.com/kingdomino.jpg');
INSERT INTO games (id, title, description, min_players, max_players, playtime_minutes, publisher, year_published, image_url) VALUES ('9052a9d5-d3e7-40ad-8202-580ebd166e85', 'Brass: Birmingham', 'Land at standard dinner manager walk sound speech.
Treat sign TV other. Ability moment drop magazine. Cup daughter Mrs really knowledge base let.
Might my establish natural great my inside.', 2, 6, 90, 'Hall-Lynch', 2016, 'https://example.com/brass:_birmingham.jpg');
INSERT INTO games (id, title, description, min_players, max_players, playtime_minutes, publisher, year_published, image_url) VALUES ('4f86932e-e982-4cd2-bf1b-8e48bd0b3654', 'Agricola', 'Many onto left decide floor. Lay describe seem. Environmental sound everybody happen affect action.', 2, 4, 90, 'Fleming PLC', 1999, 'https://example.com/agricola.jpg');
INSERT INTO games (id, title, description, min_players, max_players, playtime_minutes, publisher, year_published, image_url) VALUES ('7275fbb0-0f64-483a-89c5-3f7ef1f6aef5', 'Codenames', 'Common painting to development car western recognize. After yet city including recent successful create table.
Similar toward and focus say party. Record stay staff.', 1, 6, 45, 'Rush, Morris and Davis', 2009, 'https://example.com/codenames.jpg');
INSERT INTO games (id, title, description, min_players, max_players, playtime_minutes, publisher, year_published, image_url) VALUES ('965e9707-71e1-4e3f-b7da-3133d051aeac', 'Terraforming Mars', 'Glass include without once radio from method. Garden political international culture expert religious free news. Response try thus southern inside well provide.', 2, 5, 45, 'Martinez, Mcdowell and Contreras', 2023, 'https://example.com/terraforming_mars.jpg');
INSERT INTO games (id, title, description, min_players, max_players, playtime_minutes, publisher, year_published, image_url) VALUES ('0ad786b0-7cc0-43ec-944e-1f463704b83a', 'Scythe', 'Hotel room other two. Interesting everyone window relationship morning dinner father.
Five player manage street expect police. Treatment physical item civil. Any then should full.', 2, 5, 60, 'Walton-Schaefer', 2005, 'https://example.com/scythe.jpg');
INSERT INTO games (id, title, description, min_players, max_players, playtime_minutes, publisher, year_published, image_url) VALUES ('a215cf6d-fe70-4bb2-89d5-6cc444f32db4', 'The Mind', 'Wait main mind food grow someone left. Author hold outside effect wait senior. Blue culture join else environment who.', 2, 6, 60, 'Powell-Gardner', 2009, 'https://example.com/the_mind.jpg');
INSERT INTO games (id, title, description, min_players, max_players, playtime_minutes, publisher, year_published, image_url) VALUES ('07563c9a-3fca-46b2-a018-e3af05c9e4de', 'Jaipur', 'Take people run push myself between. Court successful field upon central if. According computer development large chance. Them time fly both.
Course its never would rate a pretty.', 1, 4, 90, 'Walls-Gonzalez', 1996, 'https://example.com/jaipur.jpg');
INSERT INTO games (id, title, description, min_players, max_players, playtime_minutes, publisher, year_published, image_url) VALUES ('a0044329-740e-4bf2-852d-e98a2e524684', 'Calico', 'Cold something subject discussion. Air official land dark east PM keep. Source mean win story store decision.
Natural four protect fine vote. Expert upon hospital radio how thus. Star wear law.', 1, 5, 120, 'Mcdowell Ltd', 1998, 'https://example.com/calico.jpg');
INSERT INTO games (id, title, description, min_players, max_players, playtime_minutes, publisher, year_published, image_url) VALUES ('69026efa-dddd-408a-9ddf-cbd185b9b39d', 'Quacks of Quedlinburg', 'Very cut hundred chair artist. View computer entire. Order become truth lose.
Trip some than relationship skin. Begin cold hard. Down customer him.', 2, 5, 90, 'Peck LLC', 2009, 'https://example.com/quacks_of_quedlinburg.jpg');
INSERT INTO games (id, title, description, min_players, max_players, playtime_minutes, publisher, year_published, image_url) VALUES ('07011961-83b3-4e78-ac5a-a820f3963f44', 'Clank!', 'Its performance training network PM order item relationship. Present Democrat series three firm husband. Pay sometimes choose certain race wall fight.', 2, 4, 45, 'Ramirez-Moore', 2001, 'https://example.com/clank!.jpg');
INSERT INTO games (id, title, description, min_players, max_players, playtime_minutes, publisher, year_published, image_url) VALUES ('272873b6-7253-4e3e-adbf-1dc22a6fcbf4', 'Great Western Trail', 'New affect even offer. Wall into place top will.
Leave address reduce. Approach someone subject fly. Mind trouble can including plant.', 2, 6, 90, 'Lopez Inc', 2002, 'https://example.com/great_western_trail.jpg');
INSERT INTO games (id, title, description, min_players, max_players, playtime_minutes, publisher, year_published, image_url) VALUES ('d8df204d-f0f1-414b-9d25-2a39a253dfaf', 'Barrage', 'Through cup class. We live suffer least respond argue prevent single.
Give decision gun later even lot include always. Onto later pass quickly teacher. Movie manage hold remain until trouble mission.', 1, 5, 45, 'Wallace, Anthony and Gonzales', 2001, 'https://example.com/barrage.jpg');
INSERT INTO games (id, title, description, min_players, max_players, playtime_minutes, publisher, year_published, image_url) VALUES ('27f69719-060a-4baf-b5e6-1bf538584193', 'Chronicles of Crime', 'Human serve small spring find mouth reflect.
Wear role majority some instead Mr throughout unit. Their reason city thousand long international us knowledge.', 1, 4, 60, 'Hurley, Cox and Smith', 2011, 'https://example.com/chronicles_of_crime.jpg');
INSERT INTO games (id, title, description, min_players, max_players, playtime_minutes, publisher, year_published, image_url) VALUES ('34a5382d-c012-4372-8322-b0c83cb3ebb9', 'Cartographers', 'Social mother make author camera total more.
My million science prepare indicate head beat represent. Investment thousand pattern. Perform alone book life sign table.', 2, 6, 60, 'Velasquez-Lowe', 2018, 'https://example.com/cartographers.jpg');
INSERT INTO games (id, title, description, min_players, max_players, playtime_minutes, publisher, year_published, image_url) VALUES ('f4340ac9-3b44-4bd8-9bf6-59b9b11e35a5', 'Tiny Towns', 'Policy economy unit build beat charge happy. Never grow leader poor turn. Administration look city him experience.', 2, 5, 90, 'Fisher Inc', 2013, 'https://example.com/tiny_towns.jpg');
INSERT INTO games (id, title, description, min_players, max_players, playtime_minutes, publisher, year_published, image_url) VALUES ('af3d7f66-771c-42e9-87ff-48adea962f70', 'Obsession', 'Seem break should. Lead figure drop address organization outside. Computer themselves media else no.
Song voice social. Around social six hear. Throughout collection itself.', 1, 6, 60, 'Vaughn-Torres', 2021, 'https://example.com/obsession.jpg');
INSERT INTO games (id, title, description, min_players, max_players, playtime_minutes, publisher, year_published, image_url) VALUES ('004ee136-a3ff-4f53-b89e-24311a65651a', 'Viticulture', 'Southern arrive turn development daughter all. General free statement across. Woman condition meet gun season.', 1, 4, 45, 'Wilson-Reynolds', 1998, 'https://example.com/viticulture.jpg');
INSERT INTO games (id, title, description, min_players, max_players, playtime_minutes, publisher, year_published, image_url) VALUES ('dc9f5e5b-2f77-41e6-aa6d-8bbfe2a62a0e', 'Tzolk''in', 'Else what article cell here avoid customer beat. Blue social child catch. War price guy specific phone simply.', 2, 6, 30, 'Bailey, Norris and Poole', 1999, 'https://example.com/tzolkin.jpg');
INSERT INTO games (id, title, description, min_players, max_players, playtime_minutes, publisher, year_published, image_url) VALUES ('a8c82eb1-7f67-4181-aa95-acfd49f11304', '5-Minute Dungeon', 'Theory risk thousand which should law stop. Difficult music situation baby administration Congress think life.
Enter recognize industry red guess chance weight travel. Sign kid him education.', 1, 6, 60, 'Rios LLC', 2000, 'https://example.com/5-minute_dungeon.jpg');
INSERT INTO games (id, title, description, min_players, max_players, playtime_minutes, publisher, year_published, image_url) VALUES ('dca5e3a9-97b7-4429-8360-7dd7c97a54b6', 'Hanabi', 'Couple occur value left them reduce nation.
Stage chance candidate under class develop measure. Election enjoy occur. Clear school hot law strong sell then.', 1, 5, 60, 'Ellis-Taylor', 2020, 'https://example.com/hanabi.jpg');
INSERT INTO games (id, title, description, min_players, max_players, playtime_minutes, publisher, year_published, image_url) VALUES ('771ea99f-6730-4b1e-bfc3-ad7eaae30bce', 'Takenoko', 'Design my rock believe plan. Time else walk risk product. Process from although economic goal.
Will off shoulder include when everybody. Interest four majority response.', 2, 5, 120, 'Washington-Stewart', 2017, 'https://example.com/takenoko.jpg');
INSERT INTO games (id, title, description, min_players, max_players, playtime_minutes, publisher, year_published, image_url) VALUES ('58ae31ca-4833-4ccf-9ab8-8f820f24503c', 'Flash Point', 'Industry writer although. Perhaps challenge particularly stay soldier expect.', 2, 5, 120, 'Mcdonald, Wagner and Reynolds', 2012, 'https://example.com/flash_point.jpg');
INSERT INTO games (id, title, description, min_players, max_players, playtime_minutes, publisher, year_published, image_url) VALUES ('8ebcccdf-6bf4-4bca-9b2d-fa1c482aa56d', 'Onitama', 'Instead office too physical goal. Age election history small value expect film. Far national today watch cultural.', 1, 4, 90, 'Vargas Inc', 2020, 'https://example.com/onitama.jpg');
INSERT INTO games (id, title, description, min_players, max_players, playtime_minutes, publisher, year_published, image_url) VALUES ('b79b279c-162e-4bed-b8b7-a7b9393fb5eb', 'Paladins of the West Kingdom', 'Assume when should line. Or financial option develop major parent area. Chair someone who trade best save.', 1, 5, 45, 'Parrish, Gonzalez and Hardin', 2009, 'https://example.com/paladins_of_the_west_kingdom.jpg');
INSERT INTO games (id, title, description, min_players, max_players, playtime_minutes, publisher, year_published, image_url) VALUES ('0bfc0fde-87cb-4c68-b16a-91586ca32f18', 'Project L', 'Create south occur oil national information floor. Force history choose authority church firm.', 1, 6, 45, 'Lin LLC', 2012, 'https://example.com/project_l.jpg');
INSERT INTO games (id, title, description, min_players, max_players, playtime_minutes, publisher, year_published, image_url) VALUES ('60c33560-df5e-4915-a942-fb8a862a1198', 'Meadow', 'Indicate agreement should drop professor. Half ten both player.
Over situation gas prove. Explain protect reason adult.', 2, 6, 30, 'Molina, Evans and Hess', 2000, 'https://example.com/meadow.jpg');
INSERT INTO games (id, title, description, min_players, max_players, playtime_minutes, publisher, year_published, image_url) VALUES ('a9ba4567-adfa-4fc0-9406-fc0c932834f5', 'Camel Up', 'Beautiful strategy outside paper upon moment American. List international on scene final drive to. Author reach shake point.', 2, 5, 30, 'Hernandez Ltd', 2013, 'https://example.com/camel_up.jpg');

-- GAME CATEGORIES
INSERT INTO game_category (game_id, category_id) VALUES ('8aba0cd0-5ec2-4b50-b227-aa7299faf2f6', 10);
INSERT INTO game_category (game_id, category_id) VALUES ('8aba0cd0-5ec2-4b50-b227-aa7299faf2f6', 20);
INSERT INTO game_category (game_id, category_id) VALUES ('4c0c7e6b-d6d8-4c42-a9a4-637417e7074e', 8);
INSERT INTO game_category (game_id, category_id) VALUES ('4c0c7e6b-d6d8-4c42-a9a4-637417e7074e', 12);
INSERT INTO game_category (game_id, category_id) VALUES ('4c0c7e6b-d6d8-4c42-a9a4-637417e7074e', 1);
INSERT INTO game_category (game_id, category_id) VALUES ('0baf8b14-51e1-4227-b86d-5bc07c9c55f6', 7);
INSERT INTO game_category (game_id, category_id) VALUES ('782c8942-2d62-44a7-a2d1-08525684783c', 7);
INSERT INTO game_category (game_id, category_id) VALUES ('782c8942-2d62-44a7-a2d1-08525684783c', 10);
INSERT INTO game_category (game_id, category_id) VALUES ('782c8942-2d62-44a7-a2d1-08525684783c', 4);
INSERT INTO game_category (game_id, category_id) VALUES ('69ac088b-7d9e-4364-b094-ffc3af30c125', 3);
INSERT INTO game_category (game_id, category_id) VALUES ('69ac088b-7d9e-4364-b094-ffc3af30c125', 1);
INSERT INTO game_category (game_id, category_id) VALUES ('774700cb-a3ac-4ecb-bb70-a662e4b4368a', 18);
INSERT INTO game_category (game_id, category_id) VALUES ('8834d871-5ee7-4c23-a48d-4e99e84f131d', 19);
INSERT INTO game_category (game_id, category_id) VALUES ('8834d871-5ee7-4c23-a48d-4e99e84f131d', 13);
INSERT INTO game_category (game_id, category_id) VALUES ('779c9d95-ed98-4f89-a04a-c4b28a96c487', 15);
INSERT INTO game_category (game_id, category_id) VALUES ('a17a2ecd-e3bf-424e-8b96-97cda76f6b21', 15);
INSERT INTO game_category (game_id, category_id) VALUES ('71eb8d1e-87a7-403a-a567-b77ad63b139f', 14);
INSERT INTO game_category (game_id, category_id) VALUES ('71eb8d1e-87a7-403a-a567-b77ad63b139f', 18);
INSERT INTO game_category (game_id, category_id) VALUES ('71eb8d1e-87a7-403a-a567-b77ad63b139f', 8);
INSERT INTO game_category (game_id, category_id) VALUES ('f3b9670b-a56c-4f43-9f31-d819f298973b', 19);
INSERT INTO game_category (game_id, category_id) VALUES ('f3b9670b-a56c-4f43-9f31-d819f298973b', 12);
INSERT INTO game_category (game_id, category_id) VALUES ('840b898b-a88b-4b58-9b17-6f4ca13c59b6', 4);
INSERT INTO game_category (game_id, category_id) VALUES ('2629c56c-b011-479a-baa0-9a48b335d91c', 19);
INSERT INTO game_category (game_id, category_id) VALUES ('2629c56c-b011-479a-baa0-9a48b335d91c', 5);
INSERT INTO game_category (game_id, category_id) VALUES ('2629c56c-b011-479a-baa0-9a48b335d91c', 18);
INSERT INTO game_category (game_id, category_id) VALUES ('760c629d-11ee-445b-81e3-8c87f8d0e6c6', 3);
INSERT INTO game_category (game_id, category_id) VALUES ('760c629d-11ee-445b-81e3-8c87f8d0e6c6', 9);
INSERT INTO game_category (game_id, category_id) VALUES ('760c629d-11ee-445b-81e3-8c87f8d0e6c6', 18);
INSERT INTO game_category (game_id, category_id) VALUES ('9edcb005-d2b1-4719-850f-e8066a4017f3', 17);
INSERT INTO game_category (game_id, category_id) VALUES ('9edcb005-d2b1-4719-850f-e8066a4017f3', 20);
INSERT INTO game_category (game_id, category_id) VALUES ('9edcb005-d2b1-4719-850f-e8066a4017f3', 8);
INSERT INTO game_category (game_id, category_id) VALUES ('31d67f68-5550-4d5f-9e36-333f1334fd48', 15);
INSERT INTO game_category (game_id, category_id) VALUES ('31d67f68-5550-4d5f-9e36-333f1334fd48', 17);
INSERT INTO game_category (game_id, category_id) VALUES ('afa64ae4-a49e-4cdc-abc8-6cee7b674864', 15);
INSERT INTO game_category (game_id, category_id) VALUES ('afa64ae4-a49e-4cdc-abc8-6cee7b674864', 7);
INSERT INTO game_category (game_id, category_id) VALUES ('afa64ae4-a49e-4cdc-abc8-6cee7b674864', 2);
INSERT INTO game_category (game_id, category_id) VALUES ('5f0e793e-92ed-41ab-b120-6570a49d7679', 20);
INSERT INTO game_category (game_id, category_id) VALUES ('5f0e793e-92ed-41ab-b120-6570a49d7679', 1);
INSERT INTO game_category (game_id, category_id) VALUES ('5f0e793e-92ed-41ab-b120-6570a49d7679', 18);
INSERT INTO game_category (game_id, category_id) VALUES ('fbf3d1b9-0958-4292-80d2-385539ff62a7', 2);
INSERT INTO game_category (game_id, category_id) VALUES ('f55c648a-1a52-4de9-9e6f-34fe19435a24', 19);
INSERT INTO game_category (game_id, category_id) VALUES ('f55c648a-1a52-4de9-9e6f-34fe19435a24', 14);
INSERT INTO game_category (game_id, category_id) VALUES ('3e33cf9d-d5fc-468e-9128-035d486d6e2d', 16);
INSERT INTO game_category (game_id, category_id) VALUES ('3e33cf9d-d5fc-468e-9128-035d486d6e2d', 18);
INSERT INTO game_category (game_id, category_id) VALUES ('3e33cf9d-d5fc-468e-9128-035d486d6e2d', 19);
INSERT INTO game_category (game_id, category_id) VALUES ('bdf4adc5-43dc-4278-bd88-1dc72daa2468', 9);
INSERT INTO game_category (game_id, category_id) VALUES ('bdf4adc5-43dc-4278-bd88-1dc72daa2468', 2);
INSERT INTO game_category (game_id, category_id) VALUES ('bdf4adc5-43dc-4278-bd88-1dc72daa2468', 5);
INSERT INTO game_category (game_id, category_id) VALUES ('b05fc5ad-8eb5-4125-8dbf-d85047a6e7db', 7);
INSERT INTO game_category (game_id, category_id) VALUES ('b05fc5ad-8eb5-4125-8dbf-d85047a6e7db', 4);
INSERT INTO game_category (game_id, category_id) VALUES ('9052a9d5-d3e7-40ad-8202-580ebd166e85', 8);
INSERT INTO game_category (game_id, category_id) VALUES ('4f86932e-e982-4cd2-bf1b-8e48bd0b3654', 1);
INSERT INTO game_category (game_id, category_id) VALUES ('4f86932e-e982-4cd2-bf1b-8e48bd0b3654', 18);
INSERT INTO game_category (game_id, category_id) VALUES ('7275fbb0-0f64-483a-89c5-3f7ef1f6aef5', 8);
INSERT INTO game_category (game_id, category_id) VALUES ('7275fbb0-0f64-483a-89c5-3f7ef1f6aef5', 4);
INSERT INTO game_category (game_id, category_id) VALUES ('7275fbb0-0f64-483a-89c5-3f7ef1f6aef5', 15);
INSERT INTO game_category (game_id, category_id) VALUES ('965e9707-71e1-4e3f-b7da-3133d051aeac', 3);
INSERT INTO game_category (game_id, category_id) VALUES ('965e9707-71e1-4e3f-b7da-3133d051aeac', 14);
INSERT INTO game_category (game_id, category_id) VALUES ('0ad786b0-7cc0-43ec-944e-1f463704b83a', 1);
INSERT INTO game_category (game_id, category_id) VALUES ('0ad786b0-7cc0-43ec-944e-1f463704b83a', 16);
INSERT INTO game_category (game_id, category_id) VALUES ('a215cf6d-fe70-4bb2-89d5-6cc444f32db4', 2);
INSERT INTO game_category (game_id, category_id) VALUES ('a215cf6d-fe70-4bb2-89d5-6cc444f32db4', 3);
INSERT INTO game_category (game_id, category_id) VALUES ('07563c9a-3fca-46b2-a018-e3af05c9e4de', 8);
INSERT INTO game_category (game_id, category_id) VALUES ('a0044329-740e-4bf2-852d-e98a2e524684', 9);
INSERT INTO game_category (game_id, category_id) VALUES ('a0044329-740e-4bf2-852d-e98a2e524684', 15);
INSERT INTO game_category (game_id, category_id) VALUES ('a0044329-740e-4bf2-852d-e98a2e524684', 13);
INSERT INTO game_category (game_id, category_id) VALUES ('69026efa-dddd-408a-9ddf-cbd185b9b39d', 2);
INSERT INTO game_category (game_id, category_id) VALUES ('69026efa-dddd-408a-9ddf-cbd185b9b39d', 10);
INSERT INTO game_category (game_id, category_id) VALUES ('69026efa-dddd-408a-9ddf-cbd185b9b39d', 13);
INSERT INTO game_category (game_id, category_id) VALUES ('07011961-83b3-4e78-ac5a-a820f3963f44', 9);
INSERT INTO game_category (game_id, category_id) VALUES ('272873b6-7253-4e3e-adbf-1dc22a6fcbf4', 1);
INSERT INTO game_category (game_id, category_id) VALUES ('272873b6-7253-4e3e-adbf-1dc22a6fcbf4', 6);
INSERT INTO game_category (game_id, category_id) VALUES ('d8df204d-f0f1-414b-9d25-2a39a253dfaf', 3);
INSERT INTO game_category (game_id, category_id) VALUES ('d8df204d-f0f1-414b-9d25-2a39a253dfaf', 9);
INSERT INTO game_category (game_id, category_id) VALUES ('27f69719-060a-4baf-b5e6-1bf538584193', 12);
INSERT INTO game_category (game_id, category_id) VALUES ('27f69719-060a-4baf-b5e6-1bf538584193', 10);
INSERT INTO game_category (game_id, category_id) VALUES ('27f69719-060a-4baf-b5e6-1bf538584193', 3);
INSERT INTO game_category (game_id, category_id) VALUES ('34a5382d-c012-4372-8322-b0c83cb3ebb9', 2);
INSERT INTO game_category (game_id, category_id) VALUES ('34a5382d-c012-4372-8322-b0c83cb3ebb9', 19);
INSERT INTO game_category (game_id, category_id) VALUES ('f4340ac9-3b44-4bd8-9bf6-59b9b11e35a5', 14);
INSERT INTO game_category (game_id, category_id) VALUES ('f4340ac9-3b44-4bd8-9bf6-59b9b11e35a5', 10);
INSERT INTO game_category (game_id, category_id) VALUES ('af3d7f66-771c-42e9-87ff-48adea962f70', 17);
INSERT INTO game_category (game_id, category_id) VALUES ('af3d7f66-771c-42e9-87ff-48adea962f70', 8);
INSERT INTO game_category (game_id, category_id) VALUES ('004ee136-a3ff-4f53-b89e-24311a65651a', 10);
INSERT INTO game_category (game_id, category_id) VALUES ('dc9f5e5b-2f77-41e6-aa6d-8bbfe2a62a0e', 9);
INSERT INTO game_category (game_id, category_id) VALUES ('a8c82eb1-7f67-4181-aa95-acfd49f11304', 6);
INSERT INTO game_category (game_id, category_id) VALUES ('a8c82eb1-7f67-4181-aa95-acfd49f11304', 9);
INSERT INTO game_category (game_id, category_id) VALUES ('a8c82eb1-7f67-4181-aa95-acfd49f11304', 15);
INSERT INTO game_category (game_id, category_id) VALUES ('dca5e3a9-97b7-4429-8360-7dd7c97a54b6', 20);
INSERT INTO game_category (game_id, category_id) VALUES ('771ea99f-6730-4b1e-bfc3-ad7eaae30bce', 9);
INSERT INTO game_category (game_id, category_id) VALUES ('771ea99f-6730-4b1e-bfc3-ad7eaae30bce', 5);
INSERT INTO game_category (game_id, category_id) VALUES ('771ea99f-6730-4b1e-bfc3-ad7eaae30bce', 11);
INSERT INTO game_category (game_id, category_id) VALUES ('58ae31ca-4833-4ccf-9ab8-8f820f24503c', 10);
INSERT INTO game_category (game_id, category_id) VALUES ('58ae31ca-4833-4ccf-9ab8-8f820f24503c', 13);
INSERT INTO game_category (game_id, category_id) VALUES ('58ae31ca-4833-4ccf-9ab8-8f820f24503c', 20);
INSERT INTO game_category (game_id, category_id) VALUES ('8ebcccdf-6bf4-4bca-9b2d-fa1c482aa56d', 7);
INSERT INTO game_category (game_id, category_id) VALUES ('8ebcccdf-6bf4-4bca-9b2d-fa1c482aa56d', 1);
INSERT INTO game_category (game_id, category_id) VALUES ('b79b279c-162e-4bed-b8b7-a7b9393fb5eb', 7);
INSERT INTO game_category (game_id, category_id) VALUES ('b79b279c-162e-4bed-b8b7-a7b9393fb5eb', 20);
INSERT INTO game_category (game_id, category_id) VALUES ('0bfc0fde-87cb-4c68-b16a-91586ca32f18', 10);
INSERT INTO game_category (game_id, category_id) VALUES ('0bfc0fde-87cb-4c68-b16a-91586ca32f18', 12);
INSERT INTO game_category (game_id, category_id) VALUES ('0bfc0fde-87cb-4c68-b16a-91586ca32f18', 18);
INSERT INTO game_category (game_id, category_id) VALUES ('60c33560-df5e-4915-a942-fb8a862a1198', 13);
INSERT INTO game_category (game_id, category_id) VALUES ('60c33560-df5e-4915-a942-fb8a862a1198', 12);
INSERT INTO game_category (game_id, category_id) VALUES ('60c33560-df5e-4915-a942-fb8a862a1198', 14);
INSERT INTO game_category (game_id, category_id) VALUES ('a9ba4567-adfa-4fc0-9406-fc0c932834f5', 15);
INSERT INTO game_category (game_id, category_id) VALUES ('a9ba4567-adfa-4fc0-9406-fc0c932834f5', 2);

-- REVIEWS
INSERT INTO reviews (user_id, game_id, rating, comment, created_at) VALUES ('dd174a9e-5695-4e56-95d2-673cb68f4b22', '8aba0cd0-5ec2-4b50-b227-aa7299faf2f6', 3, 'Too much downtime between turns for our group.', '2024-10-17 00:47:55');
INSERT INTO reviews (user_id, game_id, rating, comment, created_at) VALUES ('e6f49920-30b4-453b-82ea-7ebdf094d4e3', '8aba0cd0-5ec2-4b50-b227-aa7299faf2f6', 1, 'Perfect for game night! Fast-paced and lots of fun.', '2024-12-17 00:47:55');
INSERT INTO reviews (user_id, game_id, rating, comment, created_at) VALUES ('5067482c-067b-4f1e-a022-8a5dcce96000', '8aba0cd0-5ec2-4b50-b227-aa7299faf2f6', 2, 'Too much downtime between turns for our group.', '2025-03-17 00:47:55');
INSERT INTO reviews (user_id, game_id, rating, comment, created_at) VALUES ('21f0c7f4-c15d-4f7b-aefe-2a3461a65b46', '8aba0cd0-5ec2-4b50-b227-aa7299faf2f6', 5, 'Engaging and strategic, highly recommend!', '2024-10-26 00:47:55');
INSERT INTO reviews (user_id, game_id, rating, comment, created_at) VALUES ('1509d701-f954-4338-9b00-25acc7137710', '8aba0cd0-5ec2-4b50-b227-aa7299faf2f6', 5, 'Not my favorite, but I can see the appeal for others.', '2025-03-08 00:47:55');
INSERT INTO reviews (user_id, game_id, rating, comment, created_at) VALUES ('d0d44a71-fc99-4b0f-8c86-6e0f2ef1f1eb', '4c0c7e6b-d6d8-4c42-a9a4-637417e7074e', 4, 'Perfect for game night! Fast-paced and lots of fun.', '2024-08-02 00:47:55');
INSERT INTO reviews (user_id, game_id, rating, comment, created_at) VALUES ('39186206-a1d6-4dd9-b1fd-d87e0246da38', '4c0c7e6b-d6d8-4c42-a9a4-637417e7074e', 3, 'Great theme and mechanics, but has a steep learning curve.', '2024-11-22 00:47:55');
INSERT INTO reviews (user_id, game_id, rating, comment, created_at) VALUES ('1509d701-f954-4338-9b00-25acc7137710', '4c0c7e6b-d6d8-4c42-a9a4-637417e7074e', 1, 'Beautiful artwork and good replayability.', '2025-03-12 00:47:55');
INSERT INTO reviews (user_id, game_id, rating, comment, created_at) VALUES ('43bd33ef-2afe-4907-aaa2-8702985e7048', '4c0c7e6b-d6d8-4c42-a9a4-637417e7074e', 1, 'A bit too long for my taste, but otherwise an excellent game.', '2025-04-13 00:47:55');
INSERT INTO reviews (user_id, game_id, rating, comment, created_at) VALUES ('3b1fae75-06bf-4866-8a92-5eb50f2ae19e', '4c0c7e6b-d6d8-4c42-a9a4-637417e7074e', 4, 'A bit too long for my taste, but otherwise an excellent game.', '2024-07-13 00:47:55');
INSERT INTO reviews (user_id, game_id, rating, comment, created_at) VALUES ('e6f49920-30b4-453b-82ea-7ebdf094d4e3', '0baf8b14-51e1-4227-b86d-5bc07c9c55f6', 2, 'Absolutely love it! Plays well with both new and experienced players.', '2024-10-12 00:47:55');
INSERT INTO reviews (user_id, game_id, rating, comment, created_at) VALUES ('ef95e107-6847-4697-9f5e-fcadcb995fc1', '0baf8b14-51e1-4227-b86d-5bc07c9c55f6', 2, 'Engaging and strategic, highly recommend!', '2024-12-21 00:47:55');
INSERT INTO reviews (user_id, game_id, rating, comment, created_at) VALUES ('dd174a9e-5695-4e56-95d2-673cb68f4b22', '0baf8b14-51e1-4227-b86d-5bc07c9c55f6', 5, 'Perfect for game night! Fast-paced and lots of fun.', '2025-05-06 00:47:55');
INSERT INTO reviews (user_id, game_id, rating, comment, created_at) VALUES ('d150bb63-fbe0-4edc-9ba3-26f6faea7281', '0baf8b14-51e1-4227-b86d-5bc07c9c55f6', 5, 'Creative design and smooth gameplay experience.', '2025-01-22 00:47:55');
INSERT INTO reviews (user_id, game_id, rating, comment, created_at) VALUES ('feed9ce3-4cf7-4317-9c54-aa5508a1eb61', '0baf8b14-51e1-4227-b86d-5bc07c9c55f6', 3, 'Creative design and smooth gameplay experience.', '2025-05-08 00:47:55');
INSERT INTO reviews (user_id, game_id, rating, comment, created_at) VALUES ('21f0c7f4-c15d-4f7b-aefe-2a3461a65b46', '782c8942-2d62-44a7-a2d1-08525684783c', 4, 'Perfect for game night! Fast-paced and lots of fun.', '2024-08-11 00:47:55');
INSERT INTO reviews (user_id, game_id, rating, comment, created_at) VALUES ('8c620869-4e8c-48d7-929c-fe5876872955', '782c8942-2d62-44a7-a2d1-08525684783c', 5, 'Absolutely love it! Plays well with both new and experienced players.', '2024-08-25 00:47:55');
INSERT INTO reviews (user_id, game_id, rating, comment, created_at) VALUES ('5067482c-067b-4f1e-a022-8a5dcce96000', '782c8942-2d62-44a7-a2d1-08525684783c', 2, 'Great theme and mechanics, but has a steep learning curve.', '2024-09-22 00:47:55');
INSERT INTO reviews (user_id, game_id, rating, comment, created_at) VALUES ('39186206-a1d6-4dd9-b1fd-d87e0246da38', '782c8942-2d62-44a7-a2d1-08525684783c', 5, 'Perfect for game night! Fast-paced and lots of fun.', '2024-06-28 00:47:55');
INSERT INTO reviews (user_id, game_id, rating, comment, created_at) VALUES ('dd174a9e-5695-4e56-95d2-673cb68f4b22', '782c8942-2d62-44a7-a2d1-08525684783c', 5, 'Creative design and smooth gameplay experience.', '2024-09-15 00:47:55');
INSERT INTO reviews (user_id, game_id, rating, comment, created_at) VALUES ('8bc6d8f4-c51c-41c0-abb6-5ff9e91cc873', '69ac088b-7d9e-4364-b094-ffc3af30c125', 5, 'Absolutely love it! Plays well with both new and experienced players.', '2024-09-30 00:47:55');
INSERT INTO reviews (user_id, game_id, rating, comment, created_at) VALUES ('8c620869-4e8c-48d7-929c-fe5876872955', '69ac088b-7d9e-4364-b094-ffc3af30c125', 5, 'Absolutely love it! Plays well with both new and experienced players.', '2025-04-13 00:47:55');
INSERT INTO reviews (user_id, game_id, rating, comment, created_at) VALUES ('15896e14-ceaa-4c6a-99fc-c7e147b28aa7', '69ac088b-7d9e-4364-b094-ffc3af30c125', 3, 'Not my favorite, but I can see the appeal for others.', '2025-01-05 00:47:55');
INSERT INTO reviews (user_id, game_id, rating, comment, created_at) VALUES ('ef95e107-6847-4697-9f5e-fcadcb995fc1', '69ac088b-7d9e-4364-b094-ffc3af30c125', 1, 'Engaging and strategic, highly recommend!', '2024-12-02 00:47:55');
INSERT INTO reviews (user_id, game_id, rating, comment, created_at) VALUES ('b8c7fa17-e9ae-4ed5-af9c-d2c9b70ffa83', '69ac088b-7d9e-4364-b094-ffc3af30c125', 3, 'Beautiful artwork and good replayability.', '2024-12-09 00:47:55');
INSERT INTO reviews (user_id, game_id, rating, comment, created_at) VALUES ('5067482c-067b-4f1e-a022-8a5dcce96000', '774700cb-a3ac-4ecb-bb70-a662e4b4368a', 5, 'Fun, but I wish it had more interaction between players.', '2025-02-23 00:47:55');
INSERT INTO reviews (user_id, game_id, rating, comment, created_at) VALUES ('dd174a9e-5695-4e56-95d2-673cb68f4b22', '774700cb-a3ac-4ecb-bb70-a662e4b4368a', 4, 'Not my favorite, but I can see the appeal for others.', '2025-03-31 00:47:55');
INSERT INTO reviews (user_id, game_id, rating, comment, created_at) VALUES ('62263b94-9883-4258-9687-25e156ca979d', '774700cb-a3ac-4ecb-bb70-a662e4b4368a', 2, 'A bit too long for my taste, but otherwise an excellent game.', '2024-11-17 00:47:55');
INSERT INTO reviews (user_id, game_id, rating, comment, created_at) VALUES ('e6f49920-30b4-453b-82ea-7ebdf094d4e3', '774700cb-a3ac-4ecb-bb70-a662e4b4368a', 3, 'Fun, but I wish it had more interaction between players.', '2024-08-08 00:47:55');
INSERT INTO reviews (user_id, game_id, rating, comment, created_at) VALUES ('8b0161b8-166c-48ec-a470-67fa54d7e9b6', '774700cb-a3ac-4ecb-bb70-a662e4b4368a', 5, 'Engaging and strategic, highly recommend!', '2024-12-27 00:47:55');
INSERT INTO reviews (user_id, game_id, rating, comment, created_at) VALUES ('4c47ac92-c97d-4c3c-b022-17c5944d15ff', '8834d871-5ee7-4c23-a48d-4e99e84f131d', 5, 'Absolutely love it! Plays well with both new and experienced players.', '2024-11-01 00:47:55');
INSERT INTO reviews (user_id, game_id, rating, comment, created_at) VALUES ('39186206-a1d6-4dd9-b1fd-d87e0246da38', '8834d871-5ee7-4c23-a48d-4e99e84f131d', 1, 'Beautiful artwork and good replayability.', '2024-07-04 00:47:55');
INSERT INTO reviews (user_id, game_id, rating, comment, created_at) VALUES ('1509d701-f954-4338-9b00-25acc7137710', '8834d871-5ee7-4c23-a48d-4e99e84f131d', 2, 'Great theme and mechanics, but has a steep learning curve.', '2025-04-01 00:47:55');
INSERT INTO reviews (user_id, game_id, rating, comment, created_at) VALUES ('d150bb63-fbe0-4edc-9ba3-26f6faea7281', '8834d871-5ee7-4c23-a48d-4e99e84f131d', 1, 'Great theme and mechanics, but has a steep learning curve.', '2024-08-25 00:47:55');
INSERT INTO reviews (user_id, game_id, rating, comment, created_at) VALUES ('2ed6bf69-6ded-4ac6-a54c-b65202c152b3', '8834d871-5ee7-4c23-a48d-4e99e84f131d', 3, 'Creative design and smooth gameplay experience.', '2024-10-03 00:47:55');
INSERT INTO reviews (user_id, game_id, rating, comment, created_at) VALUES ('3b1fae75-06bf-4866-8a92-5eb50f2ae19e', '779c9d95-ed98-4f89-a04a-c4b28a96c487', 4, 'Absolutely love it! Plays well with both new and experienced players.', '2025-05-11 00:47:55');
INSERT INTO reviews (user_id, game_id, rating, comment, created_at) VALUES ('21f0c7f4-c15d-4f7b-aefe-2a3461a65b46', '779c9d95-ed98-4f89-a04a-c4b28a96c487', 1, 'Too much downtime between turns for our group.', '2024-11-25 00:47:55');
INSERT INTO reviews (user_id, game_id, rating, comment, created_at) VALUES ('8c620869-4e8c-48d7-929c-fe5876872955', '779c9d95-ed98-4f89-a04a-c4b28a96c487', 4, 'Engaging and strategic, highly recommend!', '2025-02-09 00:47:55');
INSERT INTO reviews (user_id, game_id, rating, comment, created_at) VALUES ('4c47ac92-c97d-4c3c-b022-17c5944d15ff', '779c9d95-ed98-4f89-a04a-c4b28a96c487', 2, 'Creative design and smooth gameplay experience.', '2024-07-22 00:47:55');
INSERT INTO reviews (user_id, game_id, rating, comment, created_at) VALUES ('8b0161b8-166c-48ec-a470-67fa54d7e9b6', '779c9d95-ed98-4f89-a04a-c4b28a96c487', 3, 'Great theme and mechanics, but has a steep learning curve.', '2024-11-17 00:47:55');
INSERT INTO reviews (user_id, game_id, rating, comment, created_at) VALUES ('dd174a9e-5695-4e56-95d2-673cb68f4b22', 'a17a2ecd-e3bf-424e-8b96-97cda76f6b21', 4, 'A bit too long for my taste, but otherwise an excellent game.', '2024-11-13 00:47:55');
INSERT INTO reviews (user_id, game_id, rating, comment, created_at) VALUES ('23890d04-cb1a-44bf-b120-d2fbea08302e', 'a17a2ecd-e3bf-424e-8b96-97cda76f6b21', 3, 'A bit too long for my taste, but otherwise an excellent game.', '2024-07-22 00:47:55');
INSERT INTO reviews (user_id, game_id, rating, comment, created_at) VALUES ('37564d79-fb85-48aa-bda7-6ff46d0fe4ab', 'a17a2ecd-e3bf-424e-8b96-97cda76f6b21', 4, 'Beautiful artwork and good replayability.', '2025-05-02 00:47:55');
INSERT INTO reviews (user_id, game_id, rating, comment, created_at) VALUES ('8b0161b8-166c-48ec-a470-67fa54d7e9b6', 'a17a2ecd-e3bf-424e-8b96-97cda76f6b21', 3, 'Absolutely love it! Plays well with both new and experienced players.', '2025-04-11 00:47:55');
INSERT INTO reviews (user_id, game_id, rating, comment, created_at) VALUES ('39186206-a1d6-4dd9-b1fd-d87e0246da38', 'a17a2ecd-e3bf-424e-8b96-97cda76f6b21', 1, 'Creative design and smooth gameplay experience.', '2024-08-30 00:47:55');
INSERT INTO reviews (user_id, game_id, rating, comment, created_at) VALUES ('b8c7fa17-e9ae-4ed5-af9c-d2c9b70ffa83', '71eb8d1e-87a7-403a-a567-b77ad63b139f', 3, 'Fun, but I wish it had more interaction between players.', '2024-07-05 00:47:55');
INSERT INTO reviews (user_id, game_id, rating, comment, created_at) VALUES ('805fe1c3-bb4d-42b8-92da-76296354feff', '71eb8d1e-87a7-403a-a567-b77ad63b139f', 1, 'Great theme and mechanics, but has a steep learning curve.', '2025-03-07 00:47:55');
INSERT INTO reviews (user_id, game_id, rating, comment, created_at) VALUES ('21f0c7f4-c15d-4f7b-aefe-2a3461a65b46', '71eb8d1e-87a7-403a-a567-b77ad63b139f', 3, 'Beautiful artwork and good replayability.', '2024-07-02 00:47:55');
INSERT INTO reviews (user_id, game_id, rating, comment, created_at) VALUES ('e6f49920-30b4-453b-82ea-7ebdf094d4e3', '71eb8d1e-87a7-403a-a567-b77ad63b139f', 4, 'Too much downtime between turns for our group.', '2024-10-04 00:47:55');
INSERT INTO reviews (user_id, game_id, rating, comment, created_at) VALUES ('3b1fae75-06bf-4866-8a92-5eb50f2ae19e', '71eb8d1e-87a7-403a-a567-b77ad63b139f', 3, 'Creative design and smooth gameplay experience.', '2025-04-30 00:47:55');
INSERT INTO reviews (user_id, game_id, rating, comment, created_at) VALUES ('8b0161b8-166c-48ec-a470-67fa54d7e9b6', 'f3b9670b-a56c-4f43-9f31-d819f298973b', 5, 'Too much downtime between turns for our group.', '2024-10-11 00:47:55');
INSERT INTO reviews (user_id, game_id, rating, comment, created_at) VALUES ('5067482c-067b-4f1e-a022-8a5dcce96000', 'f3b9670b-a56c-4f43-9f31-d819f298973b', 4, 'Creative design and smooth gameplay experience.', '2025-03-15 00:47:55');
INSERT INTO reviews (user_id, game_id, rating, comment, created_at) VALUES ('8c620869-4e8c-48d7-929c-fe5876872955', 'f3b9670b-a56c-4f43-9f31-d819f298973b', 2, 'Engaging and strategic, highly recommend!', '2024-06-16 00:47:55');
INSERT INTO reviews (user_id, game_id, rating, comment, created_at) VALUES ('23890d04-cb1a-44bf-b120-d2fbea08302e', 'f3b9670b-a56c-4f43-9f31-d819f298973b', 3, 'Engaging and strategic, highly recommend!', '2025-04-03 00:47:55');
INSERT INTO reviews (user_id, game_id, rating, comment, created_at) VALUES ('d150bb63-fbe0-4edc-9ba3-26f6faea7281', 'f3b9670b-a56c-4f43-9f31-d819f298973b', 3, 'Perfect for game night! Fast-paced and lots of fun.', '2025-02-17 00:47:55');
INSERT INTO reviews (user_id, game_id, rating, comment, created_at) VALUES ('8b0161b8-166c-48ec-a470-67fa54d7e9b6', '840b898b-a88b-4b58-9b17-6f4ca13c59b6', 5, 'Beautiful artwork and good replayability.', '2024-09-16 00:47:55');
INSERT INTO reviews (user_id, game_id, rating, comment, created_at) VALUES ('21f0c7f4-c15d-4f7b-aefe-2a3461a65b46', '840b898b-a88b-4b58-9b17-6f4ca13c59b6', 1, 'Great theme and mechanics, but has a steep learning curve.', '2025-02-20 00:47:55');
INSERT INTO reviews (user_id, game_id, rating, comment, created_at) VALUES ('aa6af5a0-e364-4b14-bf64-15daa22d79f4', '840b898b-a88b-4b58-9b17-6f4ca13c59b6', 5, 'Perfect for game night! Fast-paced and lots of fun.', '2025-05-05 00:47:55');
INSERT INTO reviews (user_id, game_id, rating, comment, created_at) VALUES ('8c620869-4e8c-48d7-929c-fe5876872955', '840b898b-a88b-4b58-9b17-6f4ca13c59b6', 5, 'Engaging and strategic, highly recommend!', '2025-06-08 00:47:55');
INSERT INTO reviews (user_id, game_id, rating, comment, created_at) VALUES ('dd174a9e-5695-4e56-95d2-673cb68f4b22', '840b898b-a88b-4b58-9b17-6f4ca13c59b6', 1, 'Too much downtime between turns for our group.', '2024-09-30 00:47:55');
INSERT INTO reviews (user_id, game_id, rating, comment, created_at) VALUES ('aa6af5a0-e364-4b14-bf64-15daa22d79f4', '2629c56c-b011-479a-baa0-9a48b335d91c', 2, 'Fun, but I wish it had more interaction between players.', '2025-03-28 00:47:55');
INSERT INTO reviews (user_id, game_id, rating, comment, created_at) VALUES ('62263b94-9883-4258-9687-25e156ca979d', '2629c56c-b011-479a-baa0-9a48b335d91c', 3, 'Not my favorite, but I can see the appeal for others.', '2025-02-06 00:47:55');
INSERT INTO reviews (user_id, game_id, rating, comment, created_at) VALUES ('805fe1c3-bb4d-42b8-92da-76296354feff', '2629c56c-b011-479a-baa0-9a48b335d91c', 3, 'Too much downtime between turns for our group.', '2025-02-24 00:47:55');
INSERT INTO reviews (user_id, game_id, rating, comment, created_at) VALUES ('8c620869-4e8c-48d7-929c-fe5876872955', '2629c56c-b011-479a-baa0-9a48b335d91c', 1, 'Beautiful artwork and good replayability.', '2025-03-05 00:47:55');
INSERT INTO reviews (user_id, game_id, rating, comment, created_at) VALUES ('2ed6bf69-6ded-4ac6-a54c-b65202c152b3', '2629c56c-b011-479a-baa0-9a48b335d91c', 4, 'Creative design and smooth gameplay experience.', '2024-10-11 00:47:55');
INSERT INTO reviews (user_id, game_id, rating, comment, created_at) VALUES ('ef95e107-6847-4697-9f5e-fcadcb995fc1', '760c629d-11ee-445b-81e3-8c87f8d0e6c6', 2, 'Great theme and mechanics, but has a steep learning curve.', '2024-06-12 00:47:55');
INSERT INTO reviews (user_id, game_id, rating, comment, created_at) VALUES ('feed9ce3-4cf7-4317-9c54-aa5508a1eb61', '760c629d-11ee-445b-81e3-8c87f8d0e6c6', 4, 'Great theme and mechanics, but has a steep learning curve.', '2024-09-03 00:47:55');
INSERT INTO reviews (user_id, game_id, rating, comment, created_at) VALUES ('805fe1c3-bb4d-42b8-92da-76296354feff', '760c629d-11ee-445b-81e3-8c87f8d0e6c6', 2, 'Creative design and smooth gameplay experience.', '2024-09-14 00:47:55');
INSERT INTO reviews (user_id, game_id, rating, comment, created_at) VALUES ('43bd33ef-2afe-4907-aaa2-8702985e7048', '760c629d-11ee-445b-81e3-8c87f8d0e6c6', 3, 'Great theme and mechanics, but has a steep learning curve.', '2025-03-01 00:47:55');
INSERT INTO reviews (user_id, game_id, rating, comment, created_at) VALUES ('39186206-a1d6-4dd9-b1fd-d87e0246da38', '760c629d-11ee-445b-81e3-8c87f8d0e6c6', 1, 'Not my favorite, but I can see the appeal for others.', '2024-06-19 00:47:55');
INSERT INTO reviews (user_id, game_id, rating, comment, created_at) VALUES ('3b1fae75-06bf-4866-8a92-5eb50f2ae19e', '9edcb005-d2b1-4719-850f-e8066a4017f3', 5, 'Fun, but I wish it had more interaction between players.', '2025-04-01 00:47:55');
INSERT INTO reviews (user_id, game_id, rating, comment, created_at) VALUES ('4c47ac92-c97d-4c3c-b022-17c5944d15ff', '9edcb005-d2b1-4719-850f-e8066a4017f3', 3, 'Engaging and strategic, highly recommend!', '2024-10-27 00:47:55');
INSERT INTO reviews (user_id, game_id, rating, comment, created_at) VALUES ('805fe1c3-bb4d-42b8-92da-76296354feff', '9edcb005-d2b1-4719-850f-e8066a4017f3', 5, 'Perfect for game night! Fast-paced and lots of fun.', '2024-06-11 00:47:55');
INSERT INTO reviews (user_id, game_id, rating, comment, created_at) VALUES ('8c620869-4e8c-48d7-929c-fe5876872955', '9edcb005-d2b1-4719-850f-e8066a4017f3', 1, 'Great theme and mechanics, but has a steep learning curve.', '2024-07-23 00:47:55');
INSERT INTO reviews (user_id, game_id, rating, comment, created_at) VALUES ('e6f49920-30b4-453b-82ea-7ebdf094d4e3', '9edcb005-d2b1-4719-850f-e8066a4017f3', 4, 'Beautiful artwork and good replayability.', '2024-09-27 00:47:55');
INSERT INTO reviews (user_id, game_id, rating, comment, created_at) VALUES ('dd174a9e-5695-4e56-95d2-673cb68f4b22', '31d67f68-5550-4d5f-9e36-333f1334fd48', 1, 'Engaging and strategic, highly recommend!', '2025-01-03 00:47:55');
INSERT INTO reviews (user_id, game_id, rating, comment, created_at) VALUES ('4c47ac92-c97d-4c3c-b022-17c5944d15ff', '31d67f68-5550-4d5f-9e36-333f1334fd48', 3, 'Creative design and smooth gameplay experience.', '2024-07-23 00:47:55');
INSERT INTO reviews (user_id, game_id, rating, comment, created_at) VALUES ('62263b94-9883-4258-9687-25e156ca979d', '31d67f68-5550-4d5f-9e36-333f1334fd48', 5, 'Fun, but I wish it had more interaction between players.', '2025-02-03 00:47:55');
INSERT INTO reviews (user_id, game_id, rating, comment, created_at) VALUES ('feed9ce3-4cf7-4317-9c54-aa5508a1eb61', '31d67f68-5550-4d5f-9e36-333f1334fd48', 2, 'Great theme and mechanics, but has a steep learning curve.', '2024-08-23 00:47:55');
INSERT INTO reviews (user_id, game_id, rating, comment, created_at) VALUES ('8c620869-4e8c-48d7-929c-fe5876872955', '31d67f68-5550-4d5f-9e36-333f1334fd48', 4, 'Perfect for game night! Fast-paced and lots of fun.', '2025-02-12 00:47:55');
INSERT INTO reviews (user_id, game_id, rating, comment, created_at) VALUES ('5067482c-067b-4f1e-a022-8a5dcce96000', 'afa64ae4-a49e-4cdc-abc8-6cee7b674864', 2, 'Too much downtime between turns for our group.', '2025-05-15 00:47:55');
INSERT INTO reviews (user_id, game_id, rating, comment, created_at) VALUES ('8c620869-4e8c-48d7-929c-fe5876872955', 'afa64ae4-a49e-4cdc-abc8-6cee7b674864', 3, 'Perfect for game night! Fast-paced and lots of fun.', '2024-11-04 00:47:55');
INSERT INTO reviews (user_id, game_id, rating, comment, created_at) VALUES ('dd174a9e-5695-4e56-95d2-673cb68f4b22', 'afa64ae4-a49e-4cdc-abc8-6cee7b674864', 5, 'Absolutely love it! Plays well with both new and experienced players.', '2024-11-23 00:47:55');
INSERT INTO reviews (user_id, game_id, rating, comment, created_at) VALUES ('37564d79-fb85-48aa-bda7-6ff46d0fe4ab', 'afa64ae4-a49e-4cdc-abc8-6cee7b674864', 1, 'Too much downtime between turns for our group.', '2024-06-26 00:47:55');
INSERT INTO reviews (user_id, game_id, rating, comment, created_at) VALUES ('d0d44a71-fc99-4b0f-8c86-6e0f2ef1f1eb', 'afa64ae4-a49e-4cdc-abc8-6cee7b674864', 4, 'Engaging and strategic, highly recommend!', '2025-05-29 00:47:55');
INSERT INTO reviews (user_id, game_id, rating, comment, created_at) VALUES ('d0d44a71-fc99-4b0f-8c86-6e0f2ef1f1eb', '5f0e793e-92ed-41ab-b120-6570a49d7679', 5, 'Great theme and mechanics, but has a steep learning curve.', '2025-05-13 00:47:55');
INSERT INTO reviews (user_id, game_id, rating, comment, created_at) VALUES ('2ed6bf69-6ded-4ac6-a54c-b65202c152b3', '5f0e793e-92ed-41ab-b120-6570a49d7679', 3, 'Not my favorite, but I can see the appeal for others.', '2024-08-05 00:47:55');
INSERT INTO reviews (user_id, game_id, rating, comment, created_at) VALUES ('39186206-a1d6-4dd9-b1fd-d87e0246da38', '5f0e793e-92ed-41ab-b120-6570a49d7679', 1, 'Beautiful artwork and good replayability.', '2024-07-16 00:47:55');
INSERT INTO reviews (user_id, game_id, rating, comment, created_at) VALUES ('3b1fae75-06bf-4866-8a92-5eb50f2ae19e', '5f0e793e-92ed-41ab-b120-6570a49d7679', 1, 'A bit too long for my taste, but otherwise an excellent game.', '2024-06-10 00:47:55');
INSERT INTO reviews (user_id, game_id, rating, comment, created_at) VALUES ('4c47ac92-c97d-4c3c-b022-17c5944d15ff', '5f0e793e-92ed-41ab-b120-6570a49d7679', 1, 'Great theme and mechanics, but has a steep learning curve.', '2024-07-28 00:47:55');
INSERT INTO reviews (user_id, game_id, rating, comment, created_at) VALUES ('d150bb63-fbe0-4edc-9ba3-26f6faea7281', 'fbf3d1b9-0958-4292-80d2-385539ff62a7', 4, 'Not my favorite, but I can see the appeal for others.', '2024-12-20 00:47:55');
INSERT INTO reviews (user_id, game_id, rating, comment, created_at) VALUES ('2ed6bf69-6ded-4ac6-a54c-b65202c152b3', 'fbf3d1b9-0958-4292-80d2-385539ff62a7', 5, 'Too much downtime between turns for our group.', '2025-02-22 00:47:55');
INSERT INTO reviews (user_id, game_id, rating, comment, created_at) VALUES ('3b1fae75-06bf-4866-8a92-5eb50f2ae19e', 'fbf3d1b9-0958-4292-80d2-385539ff62a7', 3, 'Creative design and smooth gameplay experience.', '2024-11-04 00:47:55');
INSERT INTO reviews (user_id, game_id, rating, comment, created_at) VALUES ('43bd33ef-2afe-4907-aaa2-8702985e7048', 'fbf3d1b9-0958-4292-80d2-385539ff62a7', 3, 'Perfect for game night! Fast-paced and lots of fun.', '2025-02-02 00:47:55');
INSERT INTO reviews (user_id, game_id, rating, comment, created_at) VALUES ('5067482c-067b-4f1e-a022-8a5dcce96000', 'fbf3d1b9-0958-4292-80d2-385539ff62a7', 3, 'Too much downtime between turns for our group.', '2024-08-20 00:47:55');
INSERT INTO reviews (user_id, game_id, rating, comment, created_at) VALUES ('5067482c-067b-4f1e-a022-8a5dcce96000', 'f55c648a-1a52-4de9-9e6f-34fe19435a24', 2, 'Perfect for game night! Fast-paced and lots of fun.', '2025-05-19 00:47:55');
INSERT INTO reviews (user_id, game_id, rating, comment, created_at) VALUES ('8b0161b8-166c-48ec-a470-67fa54d7e9b6', 'f55c648a-1a52-4de9-9e6f-34fe19435a24', 3, 'Engaging and strategic, highly recommend!', '2024-11-11 00:47:55');
INSERT INTO reviews (user_id, game_id, rating, comment, created_at) VALUES ('15896e14-ceaa-4c6a-99fc-c7e147b28aa7', 'f55c648a-1a52-4de9-9e6f-34fe19435a24', 4, 'Perfect for game night! Fast-paced and lots of fun.', '2024-12-21 00:47:55');
INSERT INTO reviews (user_id, game_id, rating, comment, created_at) VALUES ('d249d5f7-af23-462c-a36c-c9c6c0691564', 'f55c648a-1a52-4de9-9e6f-34fe19435a24', 1, 'Creative design and smooth gameplay experience.', '2024-10-15 00:47:55');
INSERT INTO reviews (user_id, game_id, rating, comment, created_at) VALUES ('8c620869-4e8c-48d7-929c-fe5876872955', 'f55c648a-1a52-4de9-9e6f-34fe19435a24', 1, 'Great theme and mechanics, but has a steep learning curve.', '2024-12-29 00:47:55');
INSERT INTO reviews (user_id, game_id, rating, comment, created_at) VALUES ('21f0c7f4-c15d-4f7b-aefe-2a3461a65b46', '3e33cf9d-d5fc-468e-9128-035d486d6e2d', 2, 'Great theme and mechanics, but has a steep learning curve.', '2025-01-19 00:47:55');
INSERT INTO reviews (user_id, game_id, rating, comment, created_at) VALUES ('d0d44a71-fc99-4b0f-8c86-6e0f2ef1f1eb', '3e33cf9d-d5fc-468e-9128-035d486d6e2d', 4, 'Creative design and smooth gameplay experience.', '2024-10-08 00:47:55');
INSERT INTO reviews (user_id, game_id, rating, comment, created_at) VALUES ('2ed6bf69-6ded-4ac6-a54c-b65202c152b3', '3e33cf9d-d5fc-468e-9128-035d486d6e2d', 2, 'Engaging and strategic, highly recommend!', '2025-01-15 00:47:55');
INSERT INTO reviews (user_id, game_id, rating, comment, created_at) VALUES ('15896e14-ceaa-4c6a-99fc-c7e147b28aa7', '3e33cf9d-d5fc-468e-9128-035d486d6e2d', 4, 'Creative design and smooth gameplay experience.', '2025-03-12 00:47:55');
INSERT INTO reviews (user_id, game_id, rating, comment, created_at) VALUES ('39186206-a1d6-4dd9-b1fd-d87e0246da38', '3e33cf9d-d5fc-468e-9128-035d486d6e2d', 5, 'Fun, but I wish it had more interaction between players.', '2025-01-02 00:47:55');
INSERT INTO reviews (user_id, game_id, rating, comment, created_at) VALUES ('d249d5f7-af23-462c-a36c-c9c6c0691564', 'bdf4adc5-43dc-4278-bd88-1dc72daa2468', 1, 'Perfect for game night! Fast-paced and lots of fun.', '2024-10-31 00:47:55');
INSERT INTO reviews (user_id, game_id, rating, comment, created_at) VALUES ('d150bb63-fbe0-4edc-9ba3-26f6faea7281', 'bdf4adc5-43dc-4278-bd88-1dc72daa2468', 1, 'Not my favorite, but I can see the appeal for others.', '2025-01-16 00:47:55');
INSERT INTO reviews (user_id, game_id, rating, comment, created_at) VALUES ('8c620869-4e8c-48d7-929c-fe5876872955', 'bdf4adc5-43dc-4278-bd88-1dc72daa2468', 5, 'Engaging and strategic, highly recommend!', '2025-02-28 00:47:55');
INSERT INTO reviews (user_id, game_id, rating, comment, created_at) VALUES ('15896e14-ceaa-4c6a-99fc-c7e147b28aa7', 'bdf4adc5-43dc-4278-bd88-1dc72daa2468', 1, 'Beautiful artwork and good replayability.', '2025-01-27 00:47:55');
INSERT INTO reviews (user_id, game_id, rating, comment, created_at) VALUES ('21f0c7f4-c15d-4f7b-aefe-2a3461a65b46', 'bdf4adc5-43dc-4278-bd88-1dc72daa2468', 1, 'Not my favorite, but I can see the appeal for others.', '2024-08-24 00:47:55');
INSERT INTO reviews (user_id, game_id, rating, comment, created_at) VALUES ('23890d04-cb1a-44bf-b120-d2fbea08302e', 'b05fc5ad-8eb5-4125-8dbf-d85047a6e7db', 5, 'Too much downtime between turns for our group.', '2025-01-22 00:47:55');
INSERT INTO reviews (user_id, game_id, rating, comment, created_at) VALUES ('39186206-a1d6-4dd9-b1fd-d87e0246da38', 'b05fc5ad-8eb5-4125-8dbf-d85047a6e7db', 1, 'Creative design and smooth gameplay experience.', '2024-08-14 00:47:55');
INSERT INTO reviews (user_id, game_id, rating, comment, created_at) VALUES ('62263b94-9883-4258-9687-25e156ca979d', 'b05fc5ad-8eb5-4125-8dbf-d85047a6e7db', 2, 'Too much downtime between turns for our group.', '2025-05-06 00:47:55');
INSERT INTO reviews (user_id, game_id, rating, comment, created_at) VALUES ('e6f49920-30b4-453b-82ea-7ebdf094d4e3', 'b05fc5ad-8eb5-4125-8dbf-d85047a6e7db', 1, 'A bit too long for my taste, but otherwise an excellent game.', '2024-07-08 00:47:55');
INSERT INTO reviews (user_id, game_id, rating, comment, created_at) VALUES ('805fe1c3-bb4d-42b8-92da-76296354feff', 'b05fc5ad-8eb5-4125-8dbf-d85047a6e7db', 3, 'Great theme and mechanics, but has a steep learning curve.', '2024-09-24 00:47:55');
INSERT INTO reviews (user_id, game_id, rating, comment, created_at) VALUES ('37564d79-fb85-48aa-bda7-6ff46d0fe4ab', '9052a9d5-d3e7-40ad-8202-580ebd166e85', 5, 'Beautiful artwork and good replayability.', '2025-02-12 00:47:55');
INSERT INTO reviews (user_id, game_id, rating, comment, created_at) VALUES ('ef95e107-6847-4697-9f5e-fcadcb995fc1', '9052a9d5-d3e7-40ad-8202-580ebd166e85', 5, 'Engaging and strategic, highly recommend!', '2024-07-21 00:47:55');
INSERT INTO reviews (user_id, game_id, rating, comment, created_at) VALUES ('805fe1c3-bb4d-42b8-92da-76296354feff', '9052a9d5-d3e7-40ad-8202-580ebd166e85', 3, 'Engaging and strategic, highly recommend!', '2025-04-15 00:47:55');
INSERT INTO reviews (user_id, game_id, rating, comment, created_at) VALUES ('b8c7fa17-e9ae-4ed5-af9c-d2c9b70ffa83', '9052a9d5-d3e7-40ad-8202-580ebd166e85', 2, 'A bit too long for my taste, but otherwise an excellent game.', '2025-03-01 00:47:55');
INSERT INTO reviews (user_id, game_id, rating, comment, created_at) VALUES ('23890d04-cb1a-44bf-b120-d2fbea08302e', '9052a9d5-d3e7-40ad-8202-580ebd166e85', 3, 'A bit too long for my taste, but otherwise an excellent game.', '2025-04-18 00:47:55');
INSERT INTO reviews (user_id, game_id, rating, comment, created_at) VALUES ('b8c7fa17-e9ae-4ed5-af9c-d2c9b70ffa83', '4f86932e-e982-4cd2-bf1b-8e48bd0b3654', 4, 'Too much downtime between turns for our group.', '2024-11-21 00:47:55');
INSERT INTO reviews (user_id, game_id, rating, comment, created_at) VALUES ('dd174a9e-5695-4e56-95d2-673cb68f4b22', '4f86932e-e982-4cd2-bf1b-8e48bd0b3654', 4, 'Not my favorite, but I can see the appeal for others.', '2025-05-08 00:47:55');
INSERT INTO reviews (user_id, game_id, rating, comment, created_at) VALUES ('4c47ac92-c97d-4c3c-b022-17c5944d15ff', '4f86932e-e982-4cd2-bf1b-8e48bd0b3654', 5, 'Engaging and strategic, highly recommend!', '2024-07-09 00:47:55');
INSERT INTO reviews (user_id, game_id, rating, comment, created_at) VALUES ('ef95e107-6847-4697-9f5e-fcadcb995fc1', '4f86932e-e982-4cd2-bf1b-8e48bd0b3654', 4, 'Not my favorite, but I can see the appeal for others.', '2024-08-14 00:47:55');
INSERT INTO reviews (user_id, game_id, rating, comment, created_at) VALUES ('aa6af5a0-e364-4b14-bf64-15daa22d79f4', '4f86932e-e982-4cd2-bf1b-8e48bd0b3654', 1, 'Too much downtime between turns for our group.', '2024-11-09 00:47:55');
INSERT INTO reviews (user_id, game_id, rating, comment, created_at) VALUES ('3b1fae75-06bf-4866-8a92-5eb50f2ae19e', '7275fbb0-0f64-483a-89c5-3f7ef1f6aef5', 4, 'Beautiful artwork and good replayability.', '2024-11-09 00:47:55');
INSERT INTO reviews (user_id, game_id, rating, comment, created_at) VALUES ('5067482c-067b-4f1e-a022-8a5dcce96000', '7275fbb0-0f64-483a-89c5-3f7ef1f6aef5', 1, 'Fun, but I wish it had more interaction between players.', '2025-04-08 00:47:55');
INSERT INTO reviews (user_id, game_id, rating, comment, created_at) VALUES ('d150bb63-fbe0-4edc-9ba3-26f6faea7281', '7275fbb0-0f64-483a-89c5-3f7ef1f6aef5', 2, 'Creative design and smooth gameplay experience.', '2025-02-01 00:47:55');
INSERT INTO reviews (user_id, game_id, rating, comment, created_at) VALUES ('ef95e107-6847-4697-9f5e-fcadcb995fc1', '7275fbb0-0f64-483a-89c5-3f7ef1f6aef5', 3, 'Great theme and mechanics, but has a steep learning curve.', '2025-01-05 00:47:55');
INSERT INTO reviews (user_id, game_id, rating, comment, created_at) VALUES ('e6f49920-30b4-453b-82ea-7ebdf094d4e3', '7275fbb0-0f64-483a-89c5-3f7ef1f6aef5', 4, 'Perfect for game night! Fast-paced and lots of fun.', '2025-04-20 00:47:55');
INSERT INTO reviews (user_id, game_id, rating, comment, created_at) VALUES ('8bc6d8f4-c51c-41c0-abb6-5ff9e91cc873', '965e9707-71e1-4e3f-b7da-3133d051aeac', 1, 'Not my favorite, but I can see the appeal for others.', '2025-04-16 00:47:55');
INSERT INTO reviews (user_id, game_id, rating, comment, created_at) VALUES ('dd174a9e-5695-4e56-95d2-673cb68f4b22', '965e9707-71e1-4e3f-b7da-3133d051aeac', 4, 'A bit too long for my taste, but otherwise an excellent game.', '2024-08-09 00:47:55');
INSERT INTO reviews (user_id, game_id, rating, comment, created_at) VALUES ('62263b94-9883-4258-9687-25e156ca979d', '965e9707-71e1-4e3f-b7da-3133d051aeac', 3, 'A bit too long for my taste, but otherwise an excellent game.', '2025-03-04 00:47:55');
INSERT INTO reviews (user_id, game_id, rating, comment, created_at) VALUES ('d0d44a71-fc99-4b0f-8c86-6e0f2ef1f1eb', '965e9707-71e1-4e3f-b7da-3133d051aeac', 1, 'Absolutely love it! Plays well with both new and experienced players.', '2024-12-19 00:47:55');
INSERT INTO reviews (user_id, game_id, rating, comment, created_at) VALUES ('39186206-a1d6-4dd9-b1fd-d87e0246da38', '965e9707-71e1-4e3f-b7da-3133d051aeac', 2, 'Too much downtime between turns for our group.', '2024-12-24 00:47:55');
INSERT INTO reviews (user_id, game_id, rating, comment, created_at) VALUES ('4c47ac92-c97d-4c3c-b022-17c5944d15ff', '0ad786b0-7cc0-43ec-944e-1f463704b83a', 4, 'Too much downtime between turns for our group.', '2024-08-26 00:47:55');
INSERT INTO reviews (user_id, game_id, rating, comment, created_at) VALUES ('5067482c-067b-4f1e-a022-8a5dcce96000', '0ad786b0-7cc0-43ec-944e-1f463704b83a', 3, 'Great theme and mechanics, but has a steep learning curve.', '2025-03-09 00:47:55');
INSERT INTO reviews (user_id, game_id, rating, comment, created_at) VALUES ('805fe1c3-bb4d-42b8-92da-76296354feff', '0ad786b0-7cc0-43ec-944e-1f463704b83a', 3, 'Fun, but I wish it had more interaction between players.', '2025-04-11 00:47:55');
INSERT INTO reviews (user_id, game_id, rating, comment, created_at) VALUES ('d249d5f7-af23-462c-a36c-c9c6c0691564', '0ad786b0-7cc0-43ec-944e-1f463704b83a', 1, 'Engaging and strategic, highly recommend!', '2025-03-04 00:47:55');
INSERT INTO reviews (user_id, game_id, rating, comment, created_at) VALUES ('aa6af5a0-e364-4b14-bf64-15daa22d79f4', '0ad786b0-7cc0-43ec-944e-1f463704b83a', 1, 'Absolutely love it! Plays well with both new and experienced players.', '2024-10-18 00:47:55');
INSERT INTO reviews (user_id, game_id, rating, comment, created_at) VALUES ('8b0161b8-166c-48ec-a470-67fa54d7e9b6', 'a215cf6d-fe70-4bb2-89d5-6cc444f32db4', 2, 'Great theme and mechanics, but has a steep learning curve.', '2025-06-01 00:47:55');
INSERT INTO reviews (user_id, game_id, rating, comment, created_at) VALUES ('8c620869-4e8c-48d7-929c-fe5876872955', 'a215cf6d-fe70-4bb2-89d5-6cc444f32db4', 3, 'Great theme and mechanics, but has a steep learning curve.', '2025-04-05 00:47:55');
INSERT INTO reviews (user_id, game_id, rating, comment, created_at) VALUES ('aa6af5a0-e364-4b14-bf64-15daa22d79f4', 'a215cf6d-fe70-4bb2-89d5-6cc444f32db4', 4, 'Creative design and smooth gameplay experience.', '2025-03-17 00:47:55');
INSERT INTO reviews (user_id, game_id, rating, comment, created_at) VALUES ('37564d79-fb85-48aa-bda7-6ff46d0fe4ab', 'a215cf6d-fe70-4bb2-89d5-6cc444f32db4', 3, 'Too much downtime between turns for our group.', '2025-06-05 00:47:55');
INSERT INTO reviews (user_id, game_id, rating, comment, created_at) VALUES ('d249d5f7-af23-462c-a36c-c9c6c0691564', 'a215cf6d-fe70-4bb2-89d5-6cc444f32db4', 4, 'Creative design and smooth gameplay experience.', '2024-10-15 00:47:55');
INSERT INTO reviews (user_id, game_id, rating, comment, created_at) VALUES ('d150bb63-fbe0-4edc-9ba3-26f6faea7281', '07563c9a-3fca-46b2-a018-e3af05c9e4de', 2, 'Absolutely love it! Plays well with both new and experienced players.', '2025-01-10 00:47:55');
INSERT INTO reviews (user_id, game_id, rating, comment, created_at) VALUES ('8bc6d8f4-c51c-41c0-abb6-5ff9e91cc873', '07563c9a-3fca-46b2-a018-e3af05c9e4de', 1, 'Too much downtime between turns for our group.', '2025-04-12 00:47:55');
INSERT INTO reviews (user_id, game_id, rating, comment, created_at) VALUES ('4c47ac92-c97d-4c3c-b022-17c5944d15ff', '07563c9a-3fca-46b2-a018-e3af05c9e4de', 2, 'Fun, but I wish it had more interaction between players.', '2025-05-13 00:47:55');
INSERT INTO reviews (user_id, game_id, rating, comment, created_at) VALUES ('15896e14-ceaa-4c6a-99fc-c7e147b28aa7', '07563c9a-3fca-46b2-a018-e3af05c9e4de', 5, 'Engaging and strategic, highly recommend!', '2025-03-25 00:47:55');
INSERT INTO reviews (user_id, game_id, rating, comment, created_at) VALUES ('2ed6bf69-6ded-4ac6-a54c-b65202c152b3', '07563c9a-3fca-46b2-a018-e3af05c9e4de', 2, 'Great theme and mechanics, but has a steep learning curve.', '2025-06-07 00:47:55');
INSERT INTO reviews (user_id, game_id, rating, comment, created_at) VALUES ('2ed6bf69-6ded-4ac6-a54c-b65202c152b3', 'a0044329-740e-4bf2-852d-e98a2e524684', 4, 'A bit too long for my taste, but otherwise an excellent game.', '2024-09-19 00:47:55');
INSERT INTO reviews (user_id, game_id, rating, comment, created_at) VALUES ('3b1fae75-06bf-4866-8a92-5eb50f2ae19e', 'a0044329-740e-4bf2-852d-e98a2e524684', 5, 'Engaging and strategic, highly recommend!', '2025-05-18 00:47:55');
INSERT INTO reviews (user_id, game_id, rating, comment, created_at) VALUES ('8c620869-4e8c-48d7-929c-fe5876872955', 'a0044329-740e-4bf2-852d-e98a2e524684', 1, 'Great theme and mechanics, but has a steep learning curve.', '2024-07-23 00:47:55');
INSERT INTO reviews (user_id, game_id, rating, comment, created_at) VALUES ('4c47ac92-c97d-4c3c-b022-17c5944d15ff', 'a0044329-740e-4bf2-852d-e98a2e524684', 1, 'A bit too long for my taste, but otherwise an excellent game.', '2025-01-08 00:47:55');
INSERT INTO reviews (user_id, game_id, rating, comment, created_at) VALUES ('dd174a9e-5695-4e56-95d2-673cb68f4b22', 'a0044329-740e-4bf2-852d-e98a2e524684', 2, 'Absolutely love it! Plays well with both new and experienced players.', '2025-03-27 00:47:55');
INSERT INTO reviews (user_id, game_id, rating, comment, created_at) VALUES ('feed9ce3-4cf7-4317-9c54-aa5508a1eb61', '69026efa-dddd-408a-9ddf-cbd185b9b39d', 5, 'Not my favorite, but I can see the appeal for others.', '2025-03-15 00:47:55');
INSERT INTO reviews (user_id, game_id, rating, comment, created_at) VALUES ('e6f49920-30b4-453b-82ea-7ebdf094d4e3', '69026efa-dddd-408a-9ddf-cbd185b9b39d', 5, 'A bit too long for my taste, but otherwise an excellent game.', '2024-07-01 00:47:55');
INSERT INTO reviews (user_id, game_id, rating, comment, created_at) VALUES ('8b0161b8-166c-48ec-a470-67fa54d7e9b6', '69026efa-dddd-408a-9ddf-cbd185b9b39d', 2, 'Beautiful artwork and good replayability.', '2024-09-18 00:47:55');
INSERT INTO reviews (user_id, game_id, rating, comment, created_at) VALUES ('aa6af5a0-e364-4b14-bf64-15daa22d79f4', '69026efa-dddd-408a-9ddf-cbd185b9b39d', 5, 'Perfect for game night! Fast-paced and lots of fun.', '2025-06-01 00:47:55');
INSERT INTO reviews (user_id, game_id, rating, comment, created_at) VALUES ('15896e14-ceaa-4c6a-99fc-c7e147b28aa7', '69026efa-dddd-408a-9ddf-cbd185b9b39d', 2, 'A bit too long for my taste, but otherwise an excellent game.', '2025-05-04 00:47:55');
INSERT INTO reviews (user_id, game_id, rating, comment, created_at) VALUES ('23890d04-cb1a-44bf-b120-d2fbea08302e', '07011961-83b3-4e78-ac5a-a820f3963f44', 4, 'Absolutely love it! Plays well with both new and experienced players.', '2024-09-07 00:47:55');
INSERT INTO reviews (user_id, game_id, rating, comment, created_at) VALUES ('62263b94-9883-4258-9687-25e156ca979d', '07011961-83b3-4e78-ac5a-a820f3963f44', 4, 'A bit too long for my taste, but otherwise an excellent game.', '2024-10-05 00:47:55');
INSERT INTO reviews (user_id, game_id, rating, comment, created_at) VALUES ('d249d5f7-af23-462c-a36c-c9c6c0691564', '07011961-83b3-4e78-ac5a-a820f3963f44', 5, 'Engaging and strategic, highly recommend!', '2024-08-30 00:47:55');
INSERT INTO reviews (user_id, game_id, rating, comment, created_at) VALUES ('5067482c-067b-4f1e-a022-8a5dcce96000', '07011961-83b3-4e78-ac5a-a820f3963f44', 5, 'Not my favorite, but I can see the appeal for others.', '2025-01-28 00:47:55');
INSERT INTO reviews (user_id, game_id, rating, comment, created_at) VALUES ('43bd33ef-2afe-4907-aaa2-8702985e7048', '07011961-83b3-4e78-ac5a-a820f3963f44', 2, 'A bit too long for my taste, but otherwise an excellent game.', '2024-09-11 00:47:55');
INSERT INTO reviews (user_id, game_id, rating, comment, created_at) VALUES ('21f0c7f4-c15d-4f7b-aefe-2a3461a65b46', '272873b6-7253-4e3e-adbf-1dc22a6fcbf4', 5, 'Perfect for game night! Fast-paced and lots of fun.', '2025-01-08 00:47:55');
INSERT INTO reviews (user_id, game_id, rating, comment, created_at) VALUES ('d150bb63-fbe0-4edc-9ba3-26f6faea7281', '272873b6-7253-4e3e-adbf-1dc22a6fcbf4', 3, 'Perfect for game night! Fast-paced and lots of fun.', '2024-11-17 00:47:55');
INSERT INTO reviews (user_id, game_id, rating, comment, created_at) VALUES ('8bc6d8f4-c51c-41c0-abb6-5ff9e91cc873', '272873b6-7253-4e3e-adbf-1dc22a6fcbf4', 1, 'Not my favorite, but I can see the appeal for others.', '2025-01-09 00:47:55');
INSERT INTO reviews (user_id, game_id, rating, comment, created_at) VALUES ('805fe1c3-bb4d-42b8-92da-76296354feff', '272873b6-7253-4e3e-adbf-1dc22a6fcbf4', 1, 'Engaging and strategic, highly recommend!', '2024-11-25 00:47:55');
INSERT INTO reviews (user_id, game_id, rating, comment, created_at) VALUES ('62263b94-9883-4258-9687-25e156ca979d', '272873b6-7253-4e3e-adbf-1dc22a6fcbf4', 4, 'Creative design and smooth gameplay experience.', '2024-11-17 00:47:55');
INSERT INTO reviews (user_id, game_id, rating, comment, created_at) VALUES ('4c47ac92-c97d-4c3c-b022-17c5944d15ff', 'd8df204d-f0f1-414b-9d25-2a39a253dfaf', 4, 'Absolutely love it! Plays well with both new and experienced players.', '2024-10-08 00:47:55');
INSERT INTO reviews (user_id, game_id, rating, comment, created_at) VALUES ('5067482c-067b-4f1e-a022-8a5dcce96000', 'd8df204d-f0f1-414b-9d25-2a39a253dfaf', 2, 'A bit too long for my taste, but otherwise an excellent game.', '2024-09-09 00:47:55');
INSERT INTO reviews (user_id, game_id, rating, comment, created_at) VALUES ('1509d701-f954-4338-9b00-25acc7137710', 'd8df204d-f0f1-414b-9d25-2a39a253dfaf', 2, 'Too much downtime between turns for our group.', '2025-06-01 00:47:55');
INSERT INTO reviews (user_id, game_id, rating, comment, created_at) VALUES ('dd174a9e-5695-4e56-95d2-673cb68f4b22', 'd8df204d-f0f1-414b-9d25-2a39a253dfaf', 3, 'Perfect for game night! Fast-paced and lots of fun.', '2025-05-30 00:47:55');
INSERT INTO reviews (user_id, game_id, rating, comment, created_at) VALUES ('d249d5f7-af23-462c-a36c-c9c6c0691564', 'd8df204d-f0f1-414b-9d25-2a39a253dfaf', 1, 'Not my favorite, but I can see the appeal for others.', '2024-07-21 00:47:55');
INSERT INTO reviews (user_id, game_id, rating, comment, created_at) VALUES ('15896e14-ceaa-4c6a-99fc-c7e147b28aa7', '27f69719-060a-4baf-b5e6-1bf538584193', 4, 'Too much downtime between turns for our group.', '2025-02-15 00:47:55');
INSERT INTO reviews (user_id, game_id, rating, comment, created_at) VALUES ('23890d04-cb1a-44bf-b120-d2fbea08302e', '27f69719-060a-4baf-b5e6-1bf538584193', 1, 'Perfect for game night! Fast-paced and lots of fun.', '2024-11-18 00:47:55');
INSERT INTO reviews (user_id, game_id, rating, comment, created_at) VALUES ('2ed6bf69-6ded-4ac6-a54c-b65202c152b3', '27f69719-060a-4baf-b5e6-1bf538584193', 3, 'Perfect for game night! Fast-paced and lots of fun.', '2025-04-17 00:47:55');
INSERT INTO reviews (user_id, game_id, rating, comment, created_at) VALUES ('62263b94-9883-4258-9687-25e156ca979d', '27f69719-060a-4baf-b5e6-1bf538584193', 1, 'Engaging and strategic, highly recommend!', '2025-05-23 00:47:55');
INSERT INTO reviews (user_id, game_id, rating, comment, created_at) VALUES ('37564d79-fb85-48aa-bda7-6ff46d0fe4ab', '27f69719-060a-4baf-b5e6-1bf538584193', 5, 'Beautiful artwork and good replayability.', '2024-06-20 00:47:55');
INSERT INTO reviews (user_id, game_id, rating, comment, created_at) VALUES ('d150bb63-fbe0-4edc-9ba3-26f6faea7281', '34a5382d-c012-4372-8322-b0c83cb3ebb9', 2, 'Fun, but I wish it had more interaction between players.', '2024-09-25 00:47:55');
INSERT INTO reviews (user_id, game_id, rating, comment, created_at) VALUES ('8c620869-4e8c-48d7-929c-fe5876872955', '34a5382d-c012-4372-8322-b0c83cb3ebb9', 1, 'A bit too long for my taste, but otherwise an excellent game.', '2024-11-16 00:47:55');
INSERT INTO reviews (user_id, game_id, rating, comment, created_at) VALUES ('62263b94-9883-4258-9687-25e156ca979d', '34a5382d-c012-4372-8322-b0c83cb3ebb9', 2, 'Fun, but I wish it had more interaction between players.', '2025-05-29 00:47:55');
INSERT INTO reviews (user_id, game_id, rating, comment, created_at) VALUES ('feed9ce3-4cf7-4317-9c54-aa5508a1eb61', '34a5382d-c012-4372-8322-b0c83cb3ebb9', 2, 'Too much downtime between turns for our group.', '2024-07-29 00:47:55');
INSERT INTO reviews (user_id, game_id, rating, comment, created_at) VALUES ('5067482c-067b-4f1e-a022-8a5dcce96000', '34a5382d-c012-4372-8322-b0c83cb3ebb9', 2, 'Not my favorite, but I can see the appeal for others.', '2024-12-28 00:47:55');
INSERT INTO reviews (user_id, game_id, rating, comment, created_at) VALUES ('aa6af5a0-e364-4b14-bf64-15daa22d79f4', 'f4340ac9-3b44-4bd8-9bf6-59b9b11e35a5', 4, 'Creative design and smooth gameplay experience.', '2025-02-19 00:47:55');
INSERT INTO reviews (user_id, game_id, rating, comment, created_at) VALUES ('dd174a9e-5695-4e56-95d2-673cb68f4b22', 'f4340ac9-3b44-4bd8-9bf6-59b9b11e35a5', 4, 'Absolutely love it! Plays well with both new and experienced players.', '2025-06-05 00:47:55');
INSERT INTO reviews (user_id, game_id, rating, comment, created_at) VALUES ('d249d5f7-af23-462c-a36c-c9c6c0691564', 'f4340ac9-3b44-4bd8-9bf6-59b9b11e35a5', 4, 'Absolutely love it! Plays well with both new and experienced players.', '2025-01-01 00:47:55');
INSERT INTO reviews (user_id, game_id, rating, comment, created_at) VALUES ('8bc6d8f4-c51c-41c0-abb6-5ff9e91cc873', 'f4340ac9-3b44-4bd8-9bf6-59b9b11e35a5', 2, 'Too much downtime between turns for our group.', '2024-12-21 00:47:55');
INSERT INTO reviews (user_id, game_id, rating, comment, created_at) VALUES ('4c47ac92-c97d-4c3c-b022-17c5944d15ff', 'f4340ac9-3b44-4bd8-9bf6-59b9b11e35a5', 1, 'Perfect for game night! Fast-paced and lots of fun.', '2024-10-10 00:47:55');
INSERT INTO reviews (user_id, game_id, rating, comment, created_at) VALUES ('805fe1c3-bb4d-42b8-92da-76296354feff', 'af3d7f66-771c-42e9-87ff-48adea962f70', 2, 'Great theme and mechanics, but has a steep learning curve.', '2025-01-23 00:47:55');
INSERT INTO reviews (user_id, game_id, rating, comment, created_at) VALUES ('e6f49920-30b4-453b-82ea-7ebdf094d4e3', 'af3d7f66-771c-42e9-87ff-48adea962f70', 4, 'Not my favorite, but I can see the appeal for others.', '2024-10-02 00:47:55');
INSERT INTO reviews (user_id, game_id, rating, comment, created_at) VALUES ('39186206-a1d6-4dd9-b1fd-d87e0246da38', 'af3d7f66-771c-42e9-87ff-48adea962f70', 3, 'Beautiful artwork and good replayability.', '2024-07-27 00:47:55');
INSERT INTO reviews (user_id, game_id, rating, comment, created_at) VALUES ('1509d701-f954-4338-9b00-25acc7137710', 'af3d7f66-771c-42e9-87ff-48adea962f70', 2, 'A bit too long for my taste, but otherwise an excellent game.', '2025-02-10 00:47:55');
INSERT INTO reviews (user_id, game_id, rating, comment, created_at) VALUES ('4c47ac92-c97d-4c3c-b022-17c5944d15ff', 'af3d7f66-771c-42e9-87ff-48adea962f70', 1, 'Creative design and smooth gameplay experience.', '2025-04-06 00:47:55');
INSERT INTO reviews (user_id, game_id, rating, comment, created_at) VALUES ('ef95e107-6847-4697-9f5e-fcadcb995fc1', '004ee136-a3ff-4f53-b89e-24311a65651a', 3, 'A bit too long for my taste, but otherwise an excellent game.', '2025-01-27 00:47:55');
INSERT INTO reviews (user_id, game_id, rating, comment, created_at) VALUES ('23890d04-cb1a-44bf-b120-d2fbea08302e', '004ee136-a3ff-4f53-b89e-24311a65651a', 4, 'A bit too long for my taste, but otherwise an excellent game.', '2024-09-13 00:47:55');
INSERT INTO reviews (user_id, game_id, rating, comment, created_at) VALUES ('3b1fae75-06bf-4866-8a92-5eb50f2ae19e', '004ee136-a3ff-4f53-b89e-24311a65651a', 4, 'Too much downtime between turns for our group.', '2024-06-29 00:47:55');
INSERT INTO reviews (user_id, game_id, rating, comment, created_at) VALUES ('21f0c7f4-c15d-4f7b-aefe-2a3461a65b46', '004ee136-a3ff-4f53-b89e-24311a65651a', 5, 'Absolutely love it! Plays well with both new and experienced players.', '2025-01-22 00:47:55');
INSERT INTO reviews (user_id, game_id, rating, comment, created_at) VALUES ('43bd33ef-2afe-4907-aaa2-8702985e7048', '004ee136-a3ff-4f53-b89e-24311a65651a', 4, 'Beautiful artwork and good replayability.', '2025-03-13 00:47:55');
INSERT INTO reviews (user_id, game_id, rating, comment, created_at) VALUES ('23890d04-cb1a-44bf-b120-d2fbea08302e', 'dc9f5e5b-2f77-41e6-aa6d-8bbfe2a62a0e', 4, 'Absolutely love it! Plays well with both new and experienced players.', '2025-03-17 00:47:55');
INSERT INTO reviews (user_id, game_id, rating, comment, created_at) VALUES ('62263b94-9883-4258-9687-25e156ca979d', 'dc9f5e5b-2f77-41e6-aa6d-8bbfe2a62a0e', 3, 'Great theme and mechanics, but has a steep learning curve.', '2025-05-11 00:47:55');
INSERT INTO reviews (user_id, game_id, rating, comment, created_at) VALUES ('feed9ce3-4cf7-4317-9c54-aa5508a1eb61', 'dc9f5e5b-2f77-41e6-aa6d-8bbfe2a62a0e', 5, 'Engaging and strategic, highly recommend!', '2025-04-21 00:47:55');
INSERT INTO reviews (user_id, game_id, rating, comment, created_at) VALUES ('805fe1c3-bb4d-42b8-92da-76296354feff', 'dc9f5e5b-2f77-41e6-aa6d-8bbfe2a62a0e', 2, 'A bit too long for my taste, but otherwise an excellent game.', '2024-12-04 00:47:55');
INSERT INTO reviews (user_id, game_id, rating, comment, created_at) VALUES ('aa6af5a0-e364-4b14-bf64-15daa22d79f4', 'dc9f5e5b-2f77-41e6-aa6d-8bbfe2a62a0e', 2, 'Creative design and smooth gameplay experience.', '2024-07-29 00:47:55');
INSERT INTO reviews (user_id, game_id, rating, comment, created_at) VALUES ('2ed6bf69-6ded-4ac6-a54c-b65202c152b3', 'a8c82eb1-7f67-4181-aa95-acfd49f11304', 1, 'Great theme and mechanics, but has a steep learning curve.', '2024-12-04 00:47:55');
INSERT INTO reviews (user_id, game_id, rating, comment, created_at) VALUES ('8b0161b8-166c-48ec-a470-67fa54d7e9b6', 'a8c82eb1-7f67-4181-aa95-acfd49f11304', 1, 'Not my favorite, but I can see the appeal for others.', '2024-11-26 00:47:55');
INSERT INTO reviews (user_id, game_id, rating, comment, created_at) VALUES ('8bc6d8f4-c51c-41c0-abb6-5ff9e91cc873', 'a8c82eb1-7f67-4181-aa95-acfd49f11304', 5, 'Perfect for game night! Fast-paced and lots of fun.', '2025-06-06 00:47:55');
INSERT INTO reviews (user_id, game_id, rating, comment, created_at) VALUES ('4c47ac92-c97d-4c3c-b022-17c5944d15ff', 'a8c82eb1-7f67-4181-aa95-acfd49f11304', 3, 'Engaging and strategic, highly recommend!', '2024-08-03 00:47:55');
INSERT INTO reviews (user_id, game_id, rating, comment, created_at) VALUES ('aa6af5a0-e364-4b14-bf64-15daa22d79f4', 'a8c82eb1-7f67-4181-aa95-acfd49f11304', 3, 'Engaging and strategic, highly recommend!', '2025-05-02 00:47:55');
INSERT INTO reviews (user_id, game_id, rating, comment, created_at) VALUES ('39186206-a1d6-4dd9-b1fd-d87e0246da38', 'dca5e3a9-97b7-4429-8360-7dd7c97a54b6', 5, 'Beautiful artwork and good replayability.', '2024-07-07 00:47:55');
INSERT INTO reviews (user_id, game_id, rating, comment, created_at) VALUES ('4c47ac92-c97d-4c3c-b022-17c5944d15ff', 'dca5e3a9-97b7-4429-8360-7dd7c97a54b6', 4, 'Absolutely love it! Plays well with both new and experienced players.', '2024-09-06 00:47:55');
INSERT INTO reviews (user_id, game_id, rating, comment, created_at) VALUES ('5067482c-067b-4f1e-a022-8a5dcce96000', 'dca5e3a9-97b7-4429-8360-7dd7c97a54b6', 4, 'Absolutely love it! Plays well with both new and experienced players.', '2025-04-01 00:47:55');
INSERT INTO reviews (user_id, game_id, rating, comment, created_at) VALUES ('805fe1c3-bb4d-42b8-92da-76296354feff', 'dca5e3a9-97b7-4429-8360-7dd7c97a54b6', 2, 'Perfect for game night! Fast-paced and lots of fun.', '2024-07-16 00:47:55');
INSERT INTO reviews (user_id, game_id, rating, comment, created_at) VALUES ('8c620869-4e8c-48d7-929c-fe5876872955', 'dca5e3a9-97b7-4429-8360-7dd7c97a54b6', 2, 'Great theme and mechanics, but has a steep learning curve.', '2024-07-17 00:47:55');
INSERT INTO reviews (user_id, game_id, rating, comment, created_at) VALUES ('d249d5f7-af23-462c-a36c-c9c6c0691564', '771ea99f-6730-4b1e-bfc3-ad7eaae30bce', 2, 'Engaging and strategic, highly recommend!', '2024-09-08 00:47:55');
INSERT INTO reviews (user_id, game_id, rating, comment, created_at) VALUES ('b8c7fa17-e9ae-4ed5-af9c-d2c9b70ffa83', '771ea99f-6730-4b1e-bfc3-ad7eaae30bce', 1, 'Fun, but I wish it had more interaction between players.', '2025-02-15 00:47:55');
INSERT INTO reviews (user_id, game_id, rating, comment, created_at) VALUES ('62263b94-9883-4258-9687-25e156ca979d', '771ea99f-6730-4b1e-bfc3-ad7eaae30bce', 1, 'Creative design and smooth gameplay experience.', '2025-03-16 00:47:55');
INSERT INTO reviews (user_id, game_id, rating, comment, created_at) VALUES ('8c620869-4e8c-48d7-929c-fe5876872955', '771ea99f-6730-4b1e-bfc3-ad7eaae30bce', 4, 'Not my favorite, but I can see the appeal for others.', '2025-02-08 00:47:55');
INSERT INTO reviews (user_id, game_id, rating, comment, created_at) VALUES ('39186206-a1d6-4dd9-b1fd-d87e0246da38', '771ea99f-6730-4b1e-bfc3-ad7eaae30bce', 3, 'Great theme and mechanics, but has a steep learning curve.', '2024-11-18 00:47:55');
INSERT INTO reviews (user_id, game_id, rating, comment, created_at) VALUES ('4c47ac92-c97d-4c3c-b022-17c5944d15ff', '58ae31ca-4833-4ccf-9ab8-8f820f24503c', 5, 'Creative design and smooth gameplay experience.', '2025-06-06 00:47:55');
INSERT INTO reviews (user_id, game_id, rating, comment, created_at) VALUES ('37564d79-fb85-48aa-bda7-6ff46d0fe4ab', '58ae31ca-4833-4ccf-9ab8-8f820f24503c', 2, 'Too much downtime between turns for our group.', '2024-07-17 00:47:55');
INSERT INTO reviews (user_id, game_id, rating, comment, created_at) VALUES ('1509d701-f954-4338-9b00-25acc7137710', '58ae31ca-4833-4ccf-9ab8-8f820f24503c', 1, 'A bit too long for my taste, but otherwise an excellent game.', '2024-08-16 00:47:55');
INSERT INTO reviews (user_id, game_id, rating, comment, created_at) VALUES ('d150bb63-fbe0-4edc-9ba3-26f6faea7281', '58ae31ca-4833-4ccf-9ab8-8f820f24503c', 5, 'Beautiful artwork and good replayability.', '2024-12-10 00:47:55');
INSERT INTO reviews (user_id, game_id, rating, comment, created_at) VALUES ('d0d44a71-fc99-4b0f-8c86-6e0f2ef1f1eb', '58ae31ca-4833-4ccf-9ab8-8f820f24503c', 2, 'Beautiful artwork and good replayability.', '2024-09-25 00:47:55');
INSERT INTO reviews (user_id, game_id, rating, comment, created_at) VALUES ('e6f49920-30b4-453b-82ea-7ebdf094d4e3', '8ebcccdf-6bf4-4bca-9b2d-fa1c482aa56d', 4, 'Creative design and smooth gameplay experience.', '2024-08-02 00:47:55');
INSERT INTO reviews (user_id, game_id, rating, comment, created_at) VALUES ('37564d79-fb85-48aa-bda7-6ff46d0fe4ab', '8ebcccdf-6bf4-4bca-9b2d-fa1c482aa56d', 2, 'Absolutely love it! Plays well with both new and experienced players.', '2024-07-27 00:47:55');
INSERT INTO reviews (user_id, game_id, rating, comment, created_at) VALUES ('4c47ac92-c97d-4c3c-b022-17c5944d15ff', '8ebcccdf-6bf4-4bca-9b2d-fa1c482aa56d', 2, 'Too much downtime between turns for our group.', '2025-04-08 00:47:55');
INSERT INTO reviews (user_id, game_id, rating, comment, created_at) VALUES ('39186206-a1d6-4dd9-b1fd-d87e0246da38', '8ebcccdf-6bf4-4bca-9b2d-fa1c482aa56d', 4, 'Great theme and mechanics, but has a steep learning curve.', '2024-09-12 00:47:55');
INSERT INTO reviews (user_id, game_id, rating, comment, created_at) VALUES ('23890d04-cb1a-44bf-b120-d2fbea08302e', '8ebcccdf-6bf4-4bca-9b2d-fa1c482aa56d', 3, 'Absolutely love it! Plays well with both new and experienced players.', '2025-01-10 00:47:55');
INSERT INTO reviews (user_id, game_id, rating, comment, created_at) VALUES ('8b0161b8-166c-48ec-a470-67fa54d7e9b6', 'b79b279c-162e-4bed-b8b7-a7b9393fb5eb', 3, 'Not my favorite, but I can see the appeal for others.', '2025-01-11 00:47:55');
INSERT INTO reviews (user_id, game_id, rating, comment, created_at) VALUES ('8c620869-4e8c-48d7-929c-fe5876872955', 'b79b279c-162e-4bed-b8b7-a7b9393fb5eb', 3, 'Perfect for game night! Fast-paced and lots of fun.', '2024-11-28 00:47:55');
INSERT INTO reviews (user_id, game_id, rating, comment, created_at) VALUES ('d0d44a71-fc99-4b0f-8c86-6e0f2ef1f1eb', 'b79b279c-162e-4bed-b8b7-a7b9393fb5eb', 2, 'Engaging and strategic, highly recommend!', '2025-01-31 00:47:55');
INSERT INTO reviews (user_id, game_id, rating, comment, created_at) VALUES ('4c47ac92-c97d-4c3c-b022-17c5944d15ff', 'b79b279c-162e-4bed-b8b7-a7b9393fb5eb', 5, 'Creative design and smooth gameplay experience.', '2025-02-12 00:47:55');
INSERT INTO reviews (user_id, game_id, rating, comment, created_at) VALUES ('aa6af5a0-e364-4b14-bf64-15daa22d79f4', 'b79b279c-162e-4bed-b8b7-a7b9393fb5eb', 5, 'Fun, but I wish it had more interaction between players.', '2024-11-02 00:47:55');
INSERT INTO reviews (user_id, game_id, rating, comment, created_at) VALUES ('1509d701-f954-4338-9b00-25acc7137710', '0bfc0fde-87cb-4c68-b16a-91586ca32f18', 5, 'A bit too long for my taste, but otherwise an excellent game.', '2025-03-11 00:47:55');
INSERT INTO reviews (user_id, game_id, rating, comment, created_at) VALUES ('d0d44a71-fc99-4b0f-8c86-6e0f2ef1f1eb', '0bfc0fde-87cb-4c68-b16a-91586ca32f18', 4, 'Great theme and mechanics, but has a steep learning curve.', '2024-07-23 00:47:55');
INSERT INTO reviews (user_id, game_id, rating, comment, created_at) VALUES ('15896e14-ceaa-4c6a-99fc-c7e147b28aa7', '0bfc0fde-87cb-4c68-b16a-91586ca32f18', 5, 'Not my favorite, but I can see the appeal for others.', '2024-10-03 00:47:55');
INSERT INTO reviews (user_id, game_id, rating, comment, created_at) VALUES ('5067482c-067b-4f1e-a022-8a5dcce96000', '0bfc0fde-87cb-4c68-b16a-91586ca32f18', 1, 'A bit too long for my taste, but otherwise an excellent game.', '2024-11-23 00:47:55');
INSERT INTO reviews (user_id, game_id, rating, comment, created_at) VALUES ('43bd33ef-2afe-4907-aaa2-8702985e7048', '0bfc0fde-87cb-4c68-b16a-91586ca32f18', 3, 'A bit too long for my taste, but otherwise an excellent game.', '2025-06-08 00:47:55');
INSERT INTO reviews (user_id, game_id, rating, comment, created_at) VALUES ('15896e14-ceaa-4c6a-99fc-c7e147b28aa7', '60c33560-df5e-4915-a942-fb8a862a1198', 5, 'Creative design and smooth gameplay experience.', '2024-12-20 00:47:55');
INSERT INTO reviews (user_id, game_id, rating, comment, created_at) VALUES ('37564d79-fb85-48aa-bda7-6ff46d0fe4ab', '60c33560-df5e-4915-a942-fb8a862a1198', 5, 'Too much downtime between turns for our group.', '2025-03-25 00:47:55');
INSERT INTO reviews (user_id, game_id, rating, comment, created_at) VALUES ('5067482c-067b-4f1e-a022-8a5dcce96000', '60c33560-df5e-4915-a942-fb8a862a1198', 2, 'A bit too long for my taste, but otherwise an excellent game.', '2025-01-09 00:47:55');
INSERT INTO reviews (user_id, game_id, rating, comment, created_at) VALUES ('805fe1c3-bb4d-42b8-92da-76296354feff', '60c33560-df5e-4915-a942-fb8a862a1198', 3, 'Not my favorite, but I can see the appeal for others.', '2025-02-03 00:47:55');
INSERT INTO reviews (user_id, game_id, rating, comment, created_at) VALUES ('e6f49920-30b4-453b-82ea-7ebdf094d4e3', '60c33560-df5e-4915-a942-fb8a862a1198', 5, 'Engaging and strategic, highly recommend!', '2025-03-29 00:47:55');
INSERT INTO reviews (user_id, game_id, rating, comment, created_at) VALUES ('d150bb63-fbe0-4edc-9ba3-26f6faea7281', 'a9ba4567-adfa-4fc0-9406-fc0c932834f5', 2, 'Engaging and strategic, highly recommend!', '2025-05-23 00:47:55');
INSERT INTO reviews (user_id, game_id, rating, comment, created_at) VALUES ('23890d04-cb1a-44bf-b120-d2fbea08302e', 'a9ba4567-adfa-4fc0-9406-fc0c932834f5', 5, 'Fun, but I wish it had more interaction between players.', '2025-02-26 00:47:55');
INSERT INTO reviews (user_id, game_id, rating, comment, created_at) VALUES ('2ed6bf69-6ded-4ac6-a54c-b65202c152b3', 'a9ba4567-adfa-4fc0-9406-fc0c932834f5', 3, 'Beautiful artwork and good replayability.', '2024-11-08 00:47:55');
INSERT INTO reviews (user_id, game_id, rating, comment, created_at) VALUES ('8c620869-4e8c-48d7-929c-fe5876872955', 'a9ba4567-adfa-4fc0-9406-fc0c932834f5', 5, 'Great theme and mechanics, but has a steep learning curve.', '2024-10-28 00:47:55');
INSERT INTO reviews (user_id, game_id, rating, comment, created_at) VALUES ('62263b94-9883-4258-9687-25e156ca979d', 'a9ba4567-adfa-4fc0-9406-fc0c932834f5', 5, 'Absolutely love it! Plays well with both new and experienced players.', '2024-11-15 00:47:55');
