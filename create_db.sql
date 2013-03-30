DROP TABLE IF EXISTS chefs;
DROP TABLE IF EXISTS restaurants;
DROP TABLE IF EXISTS chef_tenure;
DROP TABLE IF EXISTS critics;
DROP TABLE IF EXISTS reviews;

CREATE TABLE chefs (
	id INTEGER PRIMARY KEY,
	first_name VARCHAR(30) NOT NULL,
	last_name VARCHAR(30) NOT NULL,
	mentor VARCHAR(30)
);

CREATE TABLE restaurants (
	id INTEGER PRIMARY KEY,
	name VARCHAR(50) NOT NULL,
	neighbourhood VARCHAR(100),
	cuisine VARCHAR(50)
);

CREATE TABLE chef_tenure (
	id INTEGER PRIMARY KEY,
	start_date TEXT,
	end_date TEXT,
	head_chef ENUM(0,1),
	chef_id INTEGER,
	restaurant_id INTEGER,

	FOREIGN KEY (chef_id) REFERENCES chefs(id),
	FOREIGN KEY (restaurant_id) REFERENCES restaurants(id)
);

CREATE TABLE critics (
	id INTEGER PRIMARY KEY,
	screen_name VARCHAR(50)
);

CREATE TABLE reviews (
	id INTEGER PRIMARY KEY,
	review TEXT,
	score SMALLINT,
	critic_id VARCHAR(50),
	restaurant_id INTEGER,

	FOREIGN KEY (restaurant_id) REFERENCES restaurants(id),
	FOREIGN KEY (critic_id) REFERENCES critics(id)
);

INSERT INTO chefs
		 VALUES (null, 'Eric', 'Lin', null);

INSERT INTO chefs
		 VALUES (null, 'Peter', 'Lin', 1);

INSERT INTO chefs
		 VALUES (null, 'Nick', 'Hong', 1);

INSERT INTO chef_tenure (id, start_date, end_date, head_chef, chef_id, restaurant_id)
	   VALUES (null, "2013-01-00", "2013-01-10", 0, 1, 1);

INSERT INTO chef_tenure
	   VALUES (null, "2013-01-00", "2013-01-15", 0, 2, 1);

INSERT INTO chef_tenure
	   VALUES (null, "2013-01-20", "2013-01-25", 0, 3, 2);

INSERT INTO chef_tenure
	   VALUES (null, "2013-01-00", "2013-01-10", 1, 1, 2);

INSERT INTO restaurants
	   VALUES (null, 'Bagel', 'SF', 'American');

INSERT INTO restaurants
	   VALUES (null, 'Toast', 'SF', 'Western');

INSERT INTO restaurants
	   VALUES (null, 'Egg', 'SF', 'East');

INSERT INTO critics
     VALUES (null, 'Eric');

INSERT INTO critics
     VALUES (null, 'Peter');

INSERT INTO reviews
     VALUES (null, 'Good', 11, 1, 1);

INSERT INTO reviews
     VALUES (null, 'Bad', 5, 1, 1);     

INSERT INTO reviews
     VALUES (null, 'Zero', 0, 1, 1); 

INSERT INTO reviews
     VALUES (null, 'Grand', 20, 1, 2);

INSERT INTO reviews
     VALUES (null, 'ok', 9, 2, 1);  	