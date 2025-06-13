CREATE EXTENSION IF NOT EXISTS "pgcrypto";

CREATE TABLE IF NOT EXISTS users (
    id UUID PRIMARY KEY,
    username VARCHAR(50) NOT NULL UNIQUE,
    email VARCHAR(255) NOT NULL UNIQUE,
    password_hash VARCHAR(255) NOT NULL,
    role VARCHAR(20) NOT NULL
);

CREATE TABLE IF NOT EXISTS user_details (
    user_id UUID primary key,
    first_name VARCHAR(50),
    last_name VARCHAR(50),
    city VARCHAR(50),
    FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE
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

CREATE TABLE IF NOT EXISTS games (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    title TEXT NOT NULL,
    description TEXT NOT NULL,
    min_players INT,
    max_players INT,
    playtime_minutes INT,
    publisher VARCHAR(100),
    year_published INT,
    image_url TEXT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

ALTER TABLE games ADD COLUMN IF NOT EXISTS fts tsvector;
CREATE INDEX IF NOT EXISTS games_fts_idx ON games USING GIN(fts);

CREATE OR REPLACE FUNCTION update_games_fts() RETURNS trigger AS $$
BEGIN
    NEW.fts := to_tsvector('english', coalesce(NEW.title, '') || ' ' || coalesce(NEW.description, ''));
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE OR REPLACE TRIGGER trg_update_games_fts
    BEFORE INSERT OR UPDATE ON games
    FOR EACH ROW EXECUTE FUNCTION update_games_fts();

CREATE OR REPLACE FUNCTION search_game(search_query TEXT)
    RETURNS TABLE (
                id UUID,
                title TEXT,
                description TEXT,
                min_players INT,
                max_players INT,
                playtime_minutes INT,
                publisher VARCHAR,
                year_published INT,
                image_url TEXT,
                created_at TIMESTAMP
            ) AS $$
BEGIN
    RETURN QUERY
        SELECT g.id,
               g.title,
               g.description,
               g.min_players,
               g.max_players,
               g.playtime_minutes,
               g.publisher,
               g.year_published,
               g.image_url,
               g.created_at
        FROM games g
        WHERE g.fts @@ plainto_tsquery('english', search_query)
        ORDER BY ts_rank(g.fts, plainto_tsquery('english', search_query)) DESC;
END;
$$ LANGUAGE plpgsql STABLE;

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
SELECT g.*,
       AVG(rating) AS avg_rating
FROM reviews r
         LEFT JOIN games g ON r.game_id = g.id
GROUP BY g.id, g.title, g.description, g.min_players, g.max_players, g.playtime_minutes, g.publisher, g.year_published, g.image_url, g.created_at ORDER BY avg_rating DESC;


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

INSERT INTO games (
    id, title, description, min_players, max_players, playtime_minutes, publisher, year_published, image_url, created_at
) VALUES (
             '8aba0cd0-5ec2-4b50-b227-aa7299faf2f6',
             'Catan',
             'Settle the uncharted island of Catan by gathering and trading resources to build roads, settlements, and cities. Outwit your opponents through strategic planning and negotiation to become the dominant force on the island. With ever-changing board layouts and player interactions, every game is a unique adventure.',
             1,
             6,
             90,
             'Page LLC',
             2017,
             'https://example.com/catan.jpg',
             CURRENT_TIMESTAMP
         );

INSERT INTO games (
    id, title, description, min_players, max_players, playtime_minutes, publisher, year_published, image_url, created_at
) VALUES (
             '4c0c7e6b-d6d8-4c42-a9a4-637417e7074e',
             'Carcassonne',
             'Build a medieval landscape by strategically placing tiles to create cities, roads, and monasteries. Deploy your followers as knights, monks, or farmers to score points and control territories. Each game unfolds into a rich tapestry of strategic territory control.',
             2,
             6,
             45,
             'Wiley, Wright and Jones',
             2024,
             'https://example.com/carcassonne.jpg',
             CURRENT_TIMESTAMP
         );

INSERT INTO games (
    id, title, description, min_players, max_players, playtime_minutes, publisher, year_published, image_url, created_at
) VALUES (
             '0baf8b14-51e1-4227-b86d-5bc07c9c55f6',
             '7 Wonders',
             'Lead one of the great ancient cities and develop your civilization across three ages by building structures, advancing scientific discoveries, and forging military might. Strategic card drafting and resource management play a vital role as you compete to construct your Wonder and leave a lasting legacy. With simultaneous turns and deep tactical choices, 7 Wonders offers a rich experience in under an hour.',
             1,
             4,
             90,
             'Baker PLC',
             2012,
             'https://example.com/7_wonders.jpg',
             CURRENT_TIMESTAMP
         );

INSERT INTO games (
    id, title, description, min_players, max_players, playtime_minutes, publisher, year_published, image_url, created_at
) VALUES (
             '782c8942-2d62-44a7-a2d1-08525684783c',
             'Ticket to Ride',
             'Collect train cards and claim railway routes across North America to complete destination tickets and earn points. Plan your journey wisely, block opponents, and connect cities as you race to build the most extensive rail network. Elegant rules and tense decisions make this a beloved classic for families and strategists alike.',
             2,
             4,
             120,
             'Lam-Morales',
             2019,
             'https://example.com/ticket_to_ride.jpg',
             CURRENT_TIMESTAMP
         );

INSERT INTO games (
    id, title, description, min_players, max_players, playtime_minutes, publisher, year_published, image_url, created_at
) VALUES (
             '69ac088b-7d9e-4364-b094-ffc3af30c125',
             'Dominion',
             'Build a powerful deck of action, treasure, and victory cards as you compete to control a growing kingdom. Every game presents a unique set of available cards, encouraging new strategies and combinations. Dominion pioneered the deck-building genre with fast-paced play and deep replayability.',
             1,
             6,
             30,
             'Burgess-Henderson',
             1995,
             'https://example.com/dominion.jpg',
             CURRENT_TIMESTAMP
         );

INSERT INTO games (
    id, title, description, min_players, max_players, playtime_minutes, publisher, year_published, image_url, created_at
) VALUES (
             '774700cb-a3ac-4ecb-bb70-a662e4b4368a',
             'Pandemic',
             'Work together as a team of specialists to stop the outbreak of deadly diseases around the globe. Travel the world, treat infections, and find cures before time runs out. With cooperative gameplay and high tension, Pandemic challenges players to save humanity.',
             2,
             6,
             60,
             'Cohen, Brown and Chan',
             2010,
             'https://example.com/pandemic.jpg',
             CURRENT_TIMESTAMP
         );

INSERT INTO games (
    id, title, description, min_players, max_players, playtime_minutes, publisher, year_published, image_url, created_at
) VALUES (
             '8834d871-5ee7-4c23-a48d-4e99e84f131d',
             'Gloomhaven',
             'Embark on a sprawling campaign in a dark fantasy world where players take on the roles of mercenaries with unique abilities. Tactical combat, branching storylines, and character progression create a rich, legacy-style experience. Each decision influences the evolving world, making every campaign distinct and memorable.',
             1,
             5,
             60,
             'Smith, Russell and Smith',
             2019,
             'https://example.com/gloomhaven.jpg',
             CURRENT_TIMESTAMP
         );

INSERT INTO games (
    id, title, description, min_players, max_players, playtime_minutes, publisher, year_published, image_url, created_at
) VALUES (
             '779c9d95-ed98-4f89-a04a-c4b28a96c487',
             'Wingspan',
             'Play as bird enthusiasts developing wildlife preserves to attract the best birds across habitats. Each bird extends a chain of powerful combinations in your engine-building strategy. With beautiful artwork and educational value, Wingspan is both relaxing and deeply strategic.',
             1,
             4,
             60,
             'Williams and Sons',
             1995,
             'https://example.com/wingspan.jpg',
             CURRENT_TIMESTAMP
         );

INSERT INTO games (
    id, title, description, min_players, max_players, playtime_minutes, publisher, year_published, image_url, created_at
) VALUES (
             'a17a2ecd-e3bf-424e-8b96-97cda76f6b21',
             'Azul',
             'Take on the role of a tile-laying artist decorating the royal palace of Evora. Draft colorful tiles and place them strategically to score points based on patterns and sets. Azul blends simple rules with deep tactics and beautiful components for an elegant abstract experience.',
             2,
             6,
             45,
             'Estes Inc',
             2001,
             'https://example.com/azul.jpg',
             CURRENT_TIMESTAMP
         );

INSERT INTO games (
    id, title, description, min_players, max_players, playtime_minutes, publisher, year_published, image_url, created_at
) VALUES (
             '71eb8d1e-87a7-403a-a567-b77ad63b139f',
             'Splendor',
             'Take on the role of a Renaissance merchant acquiring mines, transportation, and artisans to create a thriving gem empire. Collect chips and cards to build your tableau and attract noble patrons. Splendor is a fast-paced, elegant engine-builder with simple rules and deep strategy.',
             1,
             6,
             30,
             'Sanders-Delacruz',
             2023,
             'https://example.com/splendor.jpg',
             CURRENT_TIMESTAMP
         );

INSERT INTO games (
    id, title, description, min_players, max_players, playtime_minutes, publisher, year_published, image_url, created_at
) VALUES (
             'f3b9670b-a56c-4f43-9f31-d819f298973b',
             'Root',
             'Command asymmetric animal factions vying for control of a vast woodland in a war of strategy and diplomacy. Each faction has its own unique mechanics and goals, making for rich interactions and deep replayability. Root blends charming artwork with a tense struggle for dominance in a living world.',
             2,
             5,
             120,
             'Johnson-Fuller',
             2011,
             'https://example.com/root.jpg',
             CURRENT_TIMESTAMP
         );

INSERT INTO games (
    id, title, description, min_players, max_players, playtime_minutes, publisher, year_published, image_url, created_at
) VALUES (
             '840b898b-a88b-4b58-9b17-6f4ca13c59b6',
             'Ark Nova',
             'Design and manage a modern zoo focused on animal conservation and scientific advancement. Use action selection and card synergy to build enclosures, support conservation projects, and attract visitors. Ark Nova offers deep strategic gameplay with a rich blend of mechanics and thematic immersion.',
             2,
             5,
             90,
             'Fuentes, Miller and Wood',
             2014,
             'https://example.com/ark_nova.jpg',
             CURRENT_TIMESTAMP
         );

INSERT INTO games (
    id, title, description, min_players, max_players, playtime_minutes, publisher, year_published, image_url, created_at
) VALUES (
             '2629c56c-b011-479a-baa0-9a48b335d91c',
             'Everdell',
             'Build a thriving woodland city in a charming valley beneath the Ever Tree. Deploy critter workers, construct buildings, and prepare for the changing seasons in this beautiful worker placement and tableau-building game. Everdell features stunning art and a cozy yet strategic gameplay experience.',
             1,
             4,
             90,
             'Moore, Ward and Johnson',
             2014,
             'https://example.com/everdell.jpg',
             CURRENT_TIMESTAMP
         );

INSERT INTO games (
    id, title, description, min_players, max_players, playtime_minutes, publisher, year_published, image_url, created_at
) VALUES (
             '760c629d-11ee-445b-81e3-8c87f8d0e6c6',
             'The Crew',
             'Embark on a cooperative trick-taking adventure through space with over 50 missions to complete. Each round challenges players to silently coordinate their efforts and complete specific objectives. The Crew offers a fresh take on classic card mechanics with a compelling story-driven campaign.',
             2,
             5,
             30,
             'Rodriguez Group',
             2024,
             'https://example.com/the_crew.jpg',
             CURRENT_TIMESTAMP
         );

INSERT INTO games (
    id, title, description, min_players, max_players, playtime_minutes, publisher, year_published, image_url, created_at
) VALUES (
             '9edcb005-d2b1-4719-850f-e8066a4017f3',
             'Patchwork',
             'Compete to build the most aesthetic and high-scoring quilt on a personal board using Tetris-like fabric pieces. Manage time and buttons, your currency, to carefully plan out patch placements. Patchwork is a quick, clever, and colorful two-player strategy game.',
             2,
             6,
             90,
             'Kirby, Barnett and Morales',
             2004,
             'https://example.com/patchwork.jpg',
             CURRENT_TIMESTAMP
         );

INSERT INTO games (
    id, title, description, min_players, max_players, playtime_minutes, publisher, year_published, image_url, created_at
) VALUES (
             '31d67f68-5550-4d5f-9e36-333f1334fd48',
             'Galaxy Trucker',
             'Assemble a spaceship from sewer pipes in real time and race it across a hazardous galaxy full of asteroids, pirates, and unexpected events. Quick thinking, adaptability, and a bit of luck are key to delivering your cargo and arriving in one piece. Galaxy Trucker is chaotic, fast-paced, and full of hilarious mishaps.',
             1,
             6,
             45,
             'Morgan Group',
             2018,
             'https://example.com/galaxy_trucker.jpg',
             CURRENT_TIMESTAMP
         );

INSERT INTO games (
    id, title, description, min_players, max_players, playtime_minutes, publisher, year_published, image_url, created_at
) VALUES (
             'afa64ae4-a49e-4cdc-abc8-6cee7b674864',
             'The Resistance',
             'A game of secret identities, deduction, and deception as players take on roles of rebels and spies. Work together to complete missions—unless you''re a spy working to sabotage them. The Resistance thrives on bluffing, logic, and social manipulation, making every round intense.',
             1,
             4,
             90,
             'Reyes, Wiggins and Allen',
             2018,
             'https://example.com/the_resistance.jpg',
             CURRENT_TIMESTAMP
         );

INSERT INTO games (
    id, title, description, min_players, max_players, playtime_minutes, publisher, year_published, image_url, created_at
) VALUES (
             '5f0e793e-92ed-41ab-b120-6570a49d7679',
             'Twilight Struggle',
             'Relive the Cold War as the USA and USSR in this two-player strategy game of influence and historical events. Balance military power, space race, and political maneuvering across global regions. Twilight Struggle blends card-driven strategy and tension with rich historical depth.',
             1,
             4,
             30,
             'Hayes Ltd',
             2007,
             'https://example.com/twilight_struggle.jpg',
             CURRENT_TIMESTAMP
         );

INSERT INTO games (
    id, title, description, min_players, max_players, playtime_minutes, publisher, year_published, image_url, created_at
) VALUES (
             'fbf3d1b9-0958-4292-80d2-385539ff62a7',
             'Love Letter',
             'Compete to deliver your love letter to the princess by enlisting the help of court members with special abilities. Use deduction, risk, and a bit of luck to eliminate rivals and be closest to her heart. Love Letter is a compact, quick, and engaging game of bluffing and strategy.',
             2,
             5,
             90,
             'Mcneil LLC',
             2000,
             'https://example.com/love_letter.jpg',
             CURRENT_TIMESTAMP
         );

INSERT INTO games (
    id, title, description, min_players, max_players, playtime_minutes, publisher, year_published, image_url, created_at
) VALUES (
             'f55c648a-1a52-4de9-9e6f-34fe19435a24',
             'Blood Rage',
             'Enter the world of Norse mythology where Viking clans battle for glory before Ragnarok. Draft cards, upgrade your warriors, and engage in area control to earn honor in combat. Blood Rage is a dynamic and visually striking game of strategic conquest and timing.',
             1,
             6,
             90,
             'Costa Inc',
             2005,
             'https://example.com/blood_rage.jpg',
             CURRENT_TIMESTAMP
         );

INSERT INTO games (
    id, title, description, min_players, max_players, playtime_minutes, publisher, year_published, image_url, created_at
) VALUES (
             '3e33cf9d-d5fc-468e-9128-035d486d6e2d',
             'Lost Ruins of Arnak',
             'Explore a mysterious island full of forgotten ruins and ancient secrets in this hybrid of deck-building and worker placement. Research lost knowledge, fight guardians, and uncover powerful artifacts. Lost Ruins of Arnak offers rich strategy and exploration in a beautifully illustrated world.',
             2,
             4,
             30,
             'Robinson-Garcia',
             2020,
             'https://example.com/lost_ruins_of_arnak.jpg',
             CURRENT_TIMESTAMP
         );

INSERT INTO games (
    id, title, description, min_players, max_players, playtime_minutes, publisher, year_published, image_url, created_at
) VALUES (
             'bdf4adc5-43dc-4278-bd88-1dc72daa2468',
             'Isle of Skye',
             'Build your kingdom by bidding on and placing landscape tiles in this strategic tile-laying game. Each round brings new scoring rules, making timing and valuation crucial to success. Isle of Skye combines auction mechanics with spatial puzzle solving for a dynamic experience.',
             2,
             6,
             90,
             'Bowman-Pacheco',
             2011,
             'https://example.com/isle_of_skye.jpg',
             CURRENT_TIMESTAMP
         );

INSERT INTO games (
    id, title, description, min_players, max_players, playtime_minutes, publisher, year_published, image_url, created_at
) VALUES (
             'b05fc5ad-8eb5-4125-8dbf-d85047a6e7db',
             'Kingdomino',
             'Expand your kingdom by connecting colorful domino-like tiles with matching terrain. Choose carefully from the available tiles each round to maximize scoring while denying your opponents. Kingdomino is a fast, family-friendly game that rewards smart spatial planning.',
             1,
             5,
             60,
             'Mccann, Russell and Doyle',
             2023,
             'https://example.com/kingdomino.jpg',
             CURRENT_TIMESTAMP
         );

INSERT INTO games (
    id, title, description, min_players, max_players, playtime_minutes, publisher, year_published, image_url, created_at
) VALUES (
             '9052a9d5-d3e7-40ad-8202-580ebd166e85',
             'Brass: Birmingham',
             'Develop industries, build networks, and navigate the economic shifts of the Industrial Revolution in England. Balance coal, iron, and beer resources to grow your empire through canals and railways. Brass: Birmingham delivers deep strategic play with a rich economic engine and high replayability.',
             2,
             6,
             90,
             'Hall-Lynch',
             2016,
             'https://example.com/brass:_birmingham.jpg',
             CURRENT_TIMESTAMP
         );

INSERT INTO games (
    id, title, description, min_players, max_players, playtime_minutes, publisher, year_published, image_url, created_at
) VALUES (
             '4f86932e-e982-4cd2-bf1b-8e48bd0b3654',
             'Agricola',
             'Take on the role of a farmer managing crops, livestock, and family in 17th-century Europe. Balance food production and expansion while improving your homestead through careful worker placement. Agricola offers deep strategic decisions with high replayability and challenge.',
             2,
             4,
             90,
             'Fleming PLC',
             1999,
             'https://example.com/agricola.jpg',
             CURRENT_TIMESTAMP
         );

INSERT INTO games (
    id, title, description, min_players, max_players, playtime_minutes, publisher, year_published, image_url, created_at
) VALUES (
             '7275fbb0-0f64-483a-89c5-3f7ef1f6aef5',
             'Codenames',
             'Two teams compete to contact all their secret agents using one-word clues linked to multiple code words. Avoid the deadly assassin and decipher your teammate’s hints while staying ahead of the rival team. Codenames is a quick, clever party game that rewards creativity and deduction.',
             1,
             6,
             45,
             'Rush, Morris and Davis',
             2009,
             'https://example.com/codenames.jpg',
             CURRENT_TIMESTAMP
         );

INSERT INTO games (
    id, title, description, min_players, max_players, playtime_minutes, publisher, year_published, image_url, created_at
) VALUES (
             '965e9707-71e1-4e3f-b7da-3133d051aeac',
             'Terraforming Mars',
             'Lead a corporation in the 2400s working to make Mars habitable by raising oxygen levels, creating oceans, and increasing temperature. Play project cards, manage resources, and build infrastructure to gain points and reshape the planet. Terraforming Mars combines strategy, science, and engine-building in a race to colonize the red planet.',
             2,
             5,
             45,
             'Martinez, Mcdowell and Contreras',
             2023,
             'https://example.com/terraforming_mars.jpg',
             CURRENT_TIMESTAMP
         );

INSERT INTO games (
    id, title, description, min_players, max_players, playtime_minutes, publisher, year_published, image_url, created_at
) VALUES (
             '0ad786b0-7cc0-43ec-944e-1f463704b83a',
             'Scythe',
             'Set in an alternate-history 1920s, Scythe is a game of economic development, territory control, and powerful mechs. Expand your faction’s influence by producing resources, deploying mechs, and building infrastructure. Scythe offers asymmetric gameplay with deep strategy and stunning artwork in a rich dieselpunk world.',
             2,
             5,
             60,
             'Walton-Schaefer',
             2005,
             'https://example.com/scythe.jpg',
             CURRENT_TIMESTAMP
         );

INSERT INTO games (
    id, title, description, min_players, max_players, playtime_minutes, publisher, year_published, image_url, created_at
) VALUES (
             'a215cf6d-fe70-4bb2-89d5-6cc444f32db4',
             'The Mind',
             'In The Mind, players must silently cooperate to play cards in ascending order—without speaking or signaling. It’s a minimalist yet intense game that tests intuition, timing, and teamwork. Simple in concept but thrilling in execution, The Mind is a true test of mental connection.',
             2,
             6,
             60,
             'Powell-Gardner',
             2009,
             'https://example.com/the_mind.jpg',
             CURRENT_TIMESTAMP
         );

INSERT INTO games (
    id, title, description, min_players, max_players, playtime_minutes, publisher, year_published, image_url, created_at
) VALUES (
             '07563c9a-3fca-46b2-a018-e3af05c9e4de',
             'Jaipur',
             'As a trader in the city of Jaipur, you must outwit your opponent to become the Maharaja’s personal merchant. Trade goods, manage camels, and plan your moves carefully in this fast-paced card game for two. Jaipur blends tactics and luck in a quick, elegant duel of commerce.',
             1,
             4,
             90,
             'Walls-Gonzalez',
             1996,
             'https://example.com/jaipur.jpg',
             CURRENT_TIMESTAMP
         );

INSERT INTO games (
    id, title, description, min_players, max_players, playtime_minutes, publisher, year_published, image_url, created_at
) VALUES (
             'a0044329-740e-4bf2-852d-e98a2e524684',
             'Calico',
             'Design a cozy quilt by placing colorful fabric patches while trying to attract adorable cats and match patterns. Each decision is a tight puzzle of color, pattern, and placement with a relaxing aesthetic. Calico blends spatial strategy and satisfying combos in a beautiful, tactile experience.',
             1,
             5,
             120,
             'Mcdowell Ltd',
             1998,
             'https://example.com/calico.jpg',
             CURRENT_TIMESTAMP
         );

INSERT INTO games (
    id, title, description, min_players, max_players, playtime_minutes, publisher, year_published, image_url, created_at
) VALUES (
             '69026efa-dddd-408a-9ddf-cbd185b9b39d',
             'Quacks of Quedlinburg',
             'Brew potions using a push-your-luck mechanic by drawing ingredients from your bag, hoping not to make it explode. Each round adds new ingredients and powers, creating chaotic and rewarding combos. Quacks is vibrant, fast-paced, and full of explosive tension and laughs.',
             2,
             5,
             90,
             'Peck LLC',
             2009,
             'https://example.com/quacks_of_quedlinburg.jpg',
             CURRENT_TIMESTAMP
         );

INSERT INTO games (
    id, title, description, min_players, max_players, playtime_minutes, publisher, year_published, image_url, created_at
) VALUES (
             '07011961-83b3-4e78-ac5a-a820f3963f44',
             'Clank!',
             'Delve into a dungeon to steal treasure while avoiding the dragon’s wrath in this deck-building adventure game. Build your deck, sneak past monsters, and get out before the noise you make (clank!) brings danger. Clank! mixes excitement and risk-taking with clever engine-building in a fantasy heist.',
             2,
             4,
             45,
             'Ramirez-Moore',
             2001,
             'https://example.com/clank!.jpg',
             CURRENT_TIMESTAMP
         );

INSERT INTO games (
    id, title, description, min_players, max_players, playtime_minutes, publisher, year_published, image_url, created_at
) VALUES (
             '272873b6-7253-4e3e-adbf-1dc22a6fcbf4',
             'Great Western Trail',
             'Drive your cattle from Texas to Kansas City, managing your herd, navigating hazards, and upgrading your path along the way. Employ cowboys, craftsmen, and engineers to optimize your strategy and score big in the railroad network. Great Western Trail offers deep planning, tactical movement, and deck management in a unique Western setting.',
             2,
             6,
             90,
             'Lopez Inc',
             2002,
             'https://example.com/great_western_trail.jpg',
             CURRENT_TIMESTAMP
         );

INSERT INTO games (
    id, title, description, min_players, max_players, playtime_minutes, publisher, year_published, image_url, created_at
) VALUES (
             'd8df204d-f0f1-414b-9d25-2a39a253dfaf',
             'Barrage',
             'Build dams, manage water flow, and construct power-generating infrastructure in a cutthroat industrial economy. Barrage combines tight worker placement and resource management with a unique rotating wheel mechanic. Strategic and unforgiving, it challenges players to optimize while disrupting opponents'' plans.',
             1,
             5,
             45,
             'Wallace, Anthony and Gonzales',
             2001,
             'https://example.com/barrage.jpg',
             CURRENT_TIMESTAMP
         );

INSERT INTO games (
    id, title, description, min_players, max_players, playtime_minutes, publisher, year_published, image_url, created_at
) VALUES (
             '27f69719-060a-4baf-b5e6-1bf538584193',
             'Chronicles of Crime',
             'Step into the shoes of a detective solving modern crimes using virtual reality and app integration. Investigate scenes, interrogate suspects, and analyze evidence in branching narrative cases. Chronicles of Crime is an immersive blend of storytelling, deduction, and technology-enhanced play.',
             1,
             4,
             60,
             'Hurley, Cox and Smith',
             2011,
             'https://example.com/chronicles_of_crime.jpg',
             CURRENT_TIMESTAMP
         );

INSERT INTO games (
    id, title, description, min_players, max_players, playtime_minutes, publisher, year_published, image_url, created_at
) VALUES (
             '34a5382d-c012-4372-8322-b0c83cb3ebb9',
             'Cartographers',
             'Sketch maps of fantasy lands in this roll-and-write game where players fill in a grid with terrain to earn points. Each season introduces new scoring objectives and monster ambushes. Cartographers rewards planning, adaptability, and spatial awareness with satisfying creativity.',
             2,
             6,
             60,
             'Velasquez-Lowe',
             2018,
             'https://example.com/cartographers.jpg',
             CURRENT_TIMESTAMP
         );

INSERT INTO games (
    id, title, description, min_players, max_players, playtime_minutes, publisher, year_published, image_url, created_at
) VALUES (
             'f4340ac9-3b44-4bd8-9bf6-59b9b11e35a5',
             'Tiny Towns',
             'Construct a thriving town on a tiny 4x4 grid using resource cubes placed in specific patterns. Every building requires precise planning and efficient use of limited space. Tiny Towns is a clever puzzle game of spatial optimization and long-term planning.',
             2,
             5,
             90,
             'Fisher Inc',
             2013,
             'https://example.com/tiny_towns.jpg',
             CURRENT_TIMESTAMP
         );

INSERT INTO games (
    id, title, description, min_players, max_players, playtime_minutes, publisher, year_published, image_url, created_at
) VALUES (
             'af3d7f66-771c-42e9-87ff-48adea962f70',
             'Obsession',
             'Manage an English estate in Victorian times, hosting events, courting suitors, and managing servants. Balance reputation, wealth, and guest invitations in a thematic mix of worker placement and tableau-building. Obsession immerses players in historical charm and strategic domestic development.',
             1,
             6,
             60,
             'Vaughn-Torres',
             2021,
             'https://example.com/obsession.jpg',
             CURRENT_TIMESTAMP
         );

INSERT INTO games (
    id, title, description, min_players, max_players, playtime_minutes, publisher, year_published, image_url, created_at
) VALUES (
             '004ee136-a3ff-4f53-b89e-24311a65651a',
             'Viticulture',
             'Run a vineyard in Tuscany by planting vines, harvesting grapes, and producing wine to fulfill orders. Use your workers wisely throughout the seasons and upgrade your estate for strategic advantages. Viticulture is a thematic worker placement game filled with charm and tactical depth.',
             1,
             4,
             45,
             'Wilson-Reynolds',
             1998,
             'https://example.com/viticulture.jpg',
             CURRENT_TIMESTAMP
         );

INSERT INTO games (
    id, title, description, min_players, max_players, playtime_minutes, publisher, year_published, image_url, created_at
) VALUES (
             'dc9f5e5b-2f77-41e6-aa6d-8bbfe2a62a0e',
             'Tzolk''in',
             'Harness the power of the Mayan calendar in this unique worker placement game with rotating gears. Timing is key as workers increase in value the longer they stay on the board. Tzolk’in offers deep planning, resource management, and a visually stunning experience.',
             2,
             6,
             30,
             'Bailey, Norris and Poole',
             1999,
             'https://example.com/tzolkin.jpg',
             CURRENT_TIMESTAMP
         );

INSERT INTO games (
    id, title, description, min_players, max_players, playtime_minutes, publisher, year_published, image_url, created_at
) VALUES (
             'a8c82eb1-7f67-4181-aa95-acfd49f11304',
             '5-Minute Dungeon',
             'Team up to conquer a series of dungeon rooms in just five minutes using fast-paced card play and cooperation. Each player uses a unique hero deck to overcome obstacles and defeat bosses. 5-Minute Dungeon is frantic, fun, and perfect for quick bursts of chaotic action.',
             1,
             6,
             60,
             'Rios LLC',
             2000,
             'https://example.com/5-minute_dungeon.jpg',
             CURRENT_TIMESTAMP
         );

INSERT INTO games (
    id, title, description, min_players, max_players, playtime_minutes, publisher, year_published, image_url, created_at
) VALUES (
             'dca5e3a9-97b7-4429-8360-7dd7c97a54b6',
             'Hanabi',
             'Work together to create a perfect fireworks display by playing cards in the correct order. The twist? You can see everyone’s cards except your own, and must rely on limited clues. Hanabi is a cooperative game of logic, memory, and subtle communication.',
             1,
             5,
             60,
             'Ellis-Taylor',
             2020,
             'https://example.com/hanabi.jpg',
             CURRENT_TIMESTAMP
         );

INSERT INTO games (
    id, title, description, min_players, max_players, playtime_minutes, publisher, year_published, image_url, created_at
) VALUES (
             '771ea99f-6730-4b1e-bfc3-ad7eaae30bce',
             'Takenoko',
             'Tend to a bamboo garden and care for a hungry panda gifted to you by the Emperor of Japan. Manage plots, grow bamboo, and feed the panda while completing objectives. Takenoko is a charming game that blends light strategy with delightful visuals.',
             2,
             5,
             120,
             'Washington-Stewart',
             2017,
             'https://example.com/takenoko.jpg',
             CURRENT_TIMESTAMP
         );

INSERT INTO games (
    id, title, description, min_players, max_players, playtime_minutes, publisher, year_published, image_url, created_at
) VALUES (
             '58ae31ca-4833-4ccf-9ab8-8f820f24503c',
             'Flash Point',
             'Join a team of firefighters as you race against time to rescue victims and extinguish flames. Each player has a unique role and must coordinate with others to survive emergencies. Flash Point is an intense cooperative game with real-time danger and heroism.',
             2,
             5,
             120,
             'Mcdonald, Wagner and Reynolds',
             2012,
             'https://example.com/flash_point.jpg',
             CURRENT_TIMESTAMP
         );

INSERT INTO games (
    id, title, description, min_players, max_players, playtime_minutes, publisher, year_published, image_url, created_at
) VALUES (
             '8ebcccdf-6bf4-4bca-9b2d-fa1c482aa56d',
             'Onitama',
             'Onitama is a fast-paced abstract strategy game that blends chess-like movement with ever-changing tactics. Each game uses a limited set of movement cards, making every match a unique puzzle. With elegant mechanics and minimal components, it''s perfect for quick duels of wits.',
             1,
             4,
             90,
             'Vargas Inc',
             2020,
             'https://example.com/onitama.jpg',
             CURRENT_TIMESTAMP
         );

INSERT INTO games (
    id, title, description, min_players, max_players, playtime_minutes, publisher, year_published, image_url, created_at
) VALUES (
             'b79b279c-162e-4bed-b8b7-a7b9393fb5eb',
             'Paladins of the West Kingdom',
             'Defend the kingdom from external threats while building fortifications and spreading faith. Recruit paladins, assign workers, and balance your strength, faith, and influence in this strategic eurogame. Paladins rewards long-term planning and engine-building in a rich medieval setting.',
             1,
             5,
             45,
             'Parrish, Gonzalez and Hardin',
             2009,
             'https://example.com/paladins_of_the_west_kingdom.jpg',
             CURRENT_TIMESTAMP
         );

INSERT INTO games (
    id, title, description, min_players, max_players, playtime_minutes, publisher, year_published, image_url, created_at
) VALUES (
             '0bfc0fde-87cb-4c68-b16a-91586ca32f18',
             'Project L',
             'Use brightly colored puzzle pieces to complete increasingly complex shapes in this satisfying engine-building game. Upgrade your actions, collect more pieces, and optimize your puzzle-solving strategy. Project L blends minimalist design with tactical depth and visual appeal.',
             1,
             6,
             45,
             'Lin LLC',
             2012,
             'https://example.com/project_l.jpg',
             CURRENT_TIMESTAMP
         );

INSERT INTO games (
    id, title, description, min_players, max_players, playtime_minutes, publisher, year_published, image_url, created_at
) VALUES (
             '60c33560-df5e-4915-a942-fb8a862a1198',
             'Meadow',
             'Explore nature and collect beautiful illustrations of flora and fauna to build your personal tableau. Strategically choose cards from the display and fulfill conditions to earn points and unlock new discoveries. Meadow is a serene, visually stunning game that rewards thoughtful planning and exploration.',
             2,
             6,
             30,
             'Molina, Evans and Hess',
             2000,
             'https://example.com/meadow.jpg',
             CURRENT_TIMESTAMP
         );

INSERT INTO games (
    id, title, description, min_players, max_players, playtime_minutes, publisher, year_published, image_url, created_at
) VALUES (
             'a9ba4567-adfa-4fc0-9406-fc0c932834f5',
             'Camel Up',
             'Bet on racing camels that move in unpredictable ways across a stacked-track desert course. Place bets, manipulate movement, and outguess your opponents to win the most money. Camel Up is chaotic, hilarious, and a crowd-pleaser perfect for groups and families.',
             2,
             5,
             30,
             'Hernandez Ltd',
             2013,
             'https://example.com/camel_up.jpg',
             CURRENT_TIMESTAMP
         );


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
