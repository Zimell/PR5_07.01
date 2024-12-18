-- DROP SCHEMA public;

CREATE SCHEMA public AUTHORIZATION postgres;

-- DROP SEQUENCE film_id_seq;

CREATE SEQUENCE film_id_seq
	INCREMENT BY 1
	MINVALUE 1
	MAXVALUE 2147483647
	START 1
	CACHE 1
	NO CYCLE;

-- Permissions

ALTER SEQUENCE film_id_seq OWNER TO postgres;
GRANT ALL ON SEQUENCE film_id_seq TO postgres;

-- DROP SEQUENCE hall_id_seq;

CREATE SEQUENCE hall_id_seq
	INCREMENT BY 1
	MINVALUE 1
	MAXVALUE 2147483647
	START 1
	CACHE 1
	NO CYCLE;

-- Permissions

ALTER SEQUENCE hall_id_seq OWNER TO postgres;
GRANT ALL ON SEQUENCE hall_id_seq TO postgres;

-- DROP SEQUENCE screening_id_seq;

CREATE SEQUENCE screening_id_seq
	INCREMENT BY 1
	MINVALUE 1
	MAXVALUE 2147483647
	START 1
	CACHE 1
	NO CYCLE;

-- Permissions

ALTER SEQUENCE screening_id_seq OWNER TO postgres;
GRANT ALL ON SEQUENCE screening_id_seq TO postgres;
-- public.film определение

-- Drop table

-- DROP TABLE film;

CREATE TABLE film (
	id serial4 NOT NULL,
	"name" varchar(255) NULL,
	description text NULL,
	CONSTRAINT film_pkey PRIMARY KEY (id)
);

-- Permissions

ALTER TABLE film OWNER TO postgres;
GRANT ALL ON TABLE film TO postgres;


-- public.hall определение

-- Drop table

-- DROP TABLE hall;

CREATE TABLE hall (
	id serial4 NOT NULL,
	"name" varchar(100) NULL,
	CONSTRAINT hall_pkey PRIMARY KEY (id)
);

-- Permissions

ALTER TABLE hall OWNER TO postgres;
GRANT ALL ON TABLE hall TO postgres;


-- public.hall_row определение

-- Drop table

-- DROP TABLE hall_row;

CREATE TABLE hall_row (
	id_hall int4 NOT NULL,
	"number" int2 NOT NULL,
	capacity int2 NULL,
	CONSTRAINT hall_row_pkey PRIMARY KEY (id_hall, number),
	CONSTRAINT hall_row_id_hall_fkey FOREIGN KEY (id_hall) REFERENCES hall(id)
);

-- Permissions

ALTER TABLE hall_row OWNER TO postgres;
GRANT ALL ON TABLE hall_row TO postgres;


-- public.screening определение

-- Drop table

-- DROP TABLE screening;

CREATE TABLE screening (
	id serial4 NOT NULL,
	hall_id int4 NULL,
	film_id int4 NULL,
	"time" timestamp NULL,
	CONSTRAINT screening_pkey PRIMARY KEY (id),
	CONSTRAINT screening_film_id_fkey FOREIGN KEY (film_id) REFERENCES film(id),
	CONSTRAINT screening_hall_id_fkey FOREIGN KEY (hall_id) REFERENCES hall(id)
);

-- Permissions

ALTER TABLE screening OWNER TO postgres;
GRANT ALL ON TABLE screening TO postgres;


-- public.tickets определение

-- Drop table

-- DROP TABLE tickets;

CREATE TABLE tickets (
	id_screening int4 NOT NULL,
	"row" int2 NOT NULL,
	seat int2 NOT NULL,
	"cost" int4 NULL,
	CONSTRAINT tickets_pkey PRIMARY KEY (id_screening, "row", seat),
	CONSTRAINT tickets_id_screening_fkey FOREIGN KEY (id_screening) REFERENCES screening(id)
);

-- Permissions

ALTER TABLE tickets OWNER TO postgres;
GRANT ALL ON TABLE tickets TO postgres;


-- public.film_1 исходный текст

CREATE OR REPLACE VIEW film_1
AS SELECT hall.name AS "Зал",
    film.name AS "Название фильма",
    screening."time" AS "Начало время"
   FROM screening
     JOIN hall ON hall.id = screening.hall_id
     JOIN film ON film.id = screening.film_id
  WHERE screening.hall_id = 5;

-- Permissions

ALTER TABLE film_1 OWNER TO postgres;
GRANT ALL ON TABLE film_1 TO postgres;


-- public.film_11 исходный текст

CREATE OR REPLACE VIEW film_11
AS SELECT hall.name AS "Зал",
    film.name AS "Название фильма",
    screening."time" AS "Начало время"
   FROM screening
     JOIN hall ON hall.id = screening.hall_id
     JOIN film ON film.id = screening.film_id
  WHERE screening."time" > '2024-01-01 11:00:00'::timestamp without time zone;

-- Permissions

ALTER TABLE film_11 OWNER TO postgres;
GRANT ALL ON TABLE film_11 TO postgres;


-- public.film_2 исходный текст

CREATE OR REPLACE VIEW film_2
AS SELECT hall.name AS "Зал",
    film.name AS "Название фильма",
    screening."time" AS "Начало время"
   FROM screening
     JOIN hall ON hall.id = screening.hall_id
     JOIN film ON film.id = screening.film_id
  WHERE screening.film_id = 4;

-- Permissions

ALTER TABLE film_2 OWNER TO postgres;
GRANT ALL ON TABLE film_2 TO postgres;


-- public.row_hall исходный текст

CREATE OR REPLACE VIEW row_hall
AS SELECT hall.name AS "Зал",
    hall_row.number AS "Ряд",
    hall_row.capacity AS "Кол-во мест"
   FROM hall_row
     JOIN hall ON hall_row.id_hall = hall.id
  WHERE hall_row.id_hall = 3 AND hall_row.number = 2;

-- Permissions

ALTER TABLE row_hall OWNER TO postgres;
GRANT ALL ON TABLE row_hall TO postgres;




-- Permissions

GRANT ALL ON SCHEMA public TO postgres;

INSERT INTO public.film (id,"name",description) VALUES
	 (1,'Форсаж 1','Боевик, триллер'),
	 (2,'Веном 3','Боевик, ужасы'),
	 (3,'Ужасающий 3','Ужасы'),
	 (4,'Переводчик','Боевик, триллер'),
	 (5,'Драйв','Драма'),
	 (6,'Побег из Шоушенка','Драма'),
	 (7,'Игры разума','Биография'),
	 (8,'Форрест Гамп','Комедия, Драма'),
	 (9,'Матрица','Научная фантастика'),
	 (10,'Начало','Научная фантастика');
INSERT INTO public.hall (id,"name") VALUES
	 (1,'Зал 1'),
	 (2,'Зал 2'),
	 (3,'Зал 3'),
	 (4,'Зал 4'),
	 (5,'Зал 5'),
	 (6,'Зал 6'),
	 (7,'Зал 7'),
	 (8,'Зал 8'),
	 (9,'Зал 9'),
	 (10,'Зал 10');
INSERT INTO public.hall_row (id_hall,"number",capacity) VALUES
	 (1,1,6),
	 (2,6,12),
	 (4,10,15),
	 (3,2,8),
	 (4,3,7),
	 (5,5,8),
	 (6,9,25),
	 (7,7,18),
	 (9,8,16),
	 (10,4,10);
INSERT INTO public.screening (id,hall_id,film_id,"time") VALUES
	 (1,1,2,'2024-02-01 11:40:00'),
	 (2,2,1,'2024-02-09 20:40:00'),
	 (3,3,3,'2024-02-01 11:40:00'),
	 (4,5,5,'2024-02-06 10:30:00'),
	 (5,4,4,'2024-02-07 11:40:00'),
	 (7,7,7,'2023-02-01 10:00:00'),
	 (8,6,6,'2023-02-01 18:00:00'),
	 (9,9,10,'2023-02-01 19:00:00'),
	 (10,8,9,'2023-02-01 20:00:00'),
	 (6,10,8,'2023-01-01 10:00:00');
INSERT INTO public.tickets (id_screening,"row",seat,"cost") VALUES
	 (1,5,12,450),
	 (3,4,9,350),
	 (2,6,8,400),
	 (5,8,4,300),
	 (4,2,10,500),
	 (7,1,2,250),
	 (10,10,7,200),
	 (8,3,14,550),
	 (9,9,6,600),
	 (6,7,2,650);