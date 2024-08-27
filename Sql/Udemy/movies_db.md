### Movie DB

#### Actor

```
CREATE TABLE actors (
	actor_id SERIAL PRIMARY KEY,
	first_name VARCHAR(150),
	last_name VARCHAR(150) NOT NULL,
	gender CHAR(1),
	date_of_birth DATE,
	created_date DATE,
	updated_date DATE
);
```

### Director
```
CREATE TABLE directors(
	director_id SERIAL PRIMARY KEY,
	first_name VARCHAR(150),
	last_name VARCHAR(150) NOT NULL,
	nationality VARCHAR(20),
	date_of_birth DATE,
	created_date DATE,
	updated_date DATE
);
```

### Movie
```
CREATE TABLE movies(
	movie_id SERIAL PRIMARY KEY,
	movie_name VARCHAR(100) NOT NUll,
	movie_duration INT,
	movie_language VARCHAR(20),
	age_certification VARCHAR(10),
	release_date DATE,
	created_date DATE,
	updated_date DATE,
	director_id INT REFERENCES directors(director_id)
);
```

### Movie Revenues

```
CREATE TABLE movies_revenues(
	revenue_id SERIAL PRIMARY KEY,
	movie_id INT REFERENCES movies(movie_id),
	revenues_domestic NUMERIC(10,2),
	revenues_international NUMERIC(10,2)
);
```

### Junction Table
```

CREATE TABLE movies_actors(
	movie_id INT REFERENCES movies (movie_id),
	actor_id INT REFERENCES actors (actor_id),
	PRIMARY KEY(movie_id,actor_id)
);
```