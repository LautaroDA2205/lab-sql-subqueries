USE sakila;

--1 BUSCAMOS EL NUMERO DE COPIAS DE "HUNCHBACK IMPOSSIBLE" EN INVENTARIO--
SELECT COUNT(*) AS num_copies
FROM inventory
WHERE film_id = (
    SELECT film_id
    FROM film
    WHERE title = 'Hunchback Impossible'
);

--2 LISTA DE PELICULAS CUYA DURACION ES MAYOR A LA MEDIA--
SELECT title, length
FROM film
WHERE length > (
    SELECT AVG(length)
    FROM film
);

--3 LISTA DE ACTORES QUE HAN PARTICIPADO EN "ALONE TRIP"--
SELECT first_name, last_name
FROM actor
WHERE actor_id IN (
    SELECT actor_id
    FROM film_actor
    WHERE film_id = (
        SELECT film_id
        FROM film
        WHERE title = 'Alone Trip'
    )
);


--4 PELICULAS QUE SE ENCUADRAN DENTRO DE LA CATEGORÍA 'FAMILY'--
SELECT
title
FROM film WHERE film_id IN (
SELECT
film_id
FROM film_category WHERE category_id = (
SELECT 
category_id
FROM category WHERE name = 'Family'));

--5 LISTA CON EL NOMBRE Y CORREO ELECTRÓNICO DE LOS CLIENTES QUE ESTÁN EN CANADÁ--
SELECT first_name, last_name, email
FROM customer
WHERE address_id IN (
SELECT address_id
FROM address
WHERE city_id IN (
SELECT city_id
FROM city
WHERE country_id = (
SELECT country_id
FROM country
WHERE country = 'Canada')));

SELECT
c.first_name,
c.last_name,
c.email
FROM customer c 
JOIN address a ON c.address_id = a.address_id
JOIN city ci ON a.city_id = ci.city_id
JOIN country cy ON ci.country_id = cy.country_id
WHERE cy.country = 'Canada';

--6 LISTA DE PELICULAS PROTAGONIZADA POR EL ACTOR MÁS "ESTELAR" --
SELECT
title
FROM film 
WHERE film_id IN (
SELECT
film_id
FROM film_actor WHERE actor_id = (
SELECT
actor_id
FROM film_actor
GROUP BY actor_id 
ORDER BY COUNT(film_id) DESC
LIMIT 1))
; 

--7 LISTA DE PELICULAS ALQUILADAS POR EL CLIENTE MÁS RENTABLE--
SELECT
f.title
FROM film f
JOIN inventory i ON f.film_id = i.film_id
JOIN rental r ON i.inventory_id = r.inventory_id
WHERE r.customer_id = (
SELECT
customer_id
FROM payment
GROUP BY customer_id
ORDER BY sum(amount) DESC
LIMIT 1);

--8 CLIENTES QUE HAN GASTADO MÁS DE LA MEDIA
SELECT customer_id, SUM(amount) AS total_amount_spent
FROM payment
GROUP BY customer_id
HAVING SUM(amount) > (
    SELECT AVG(total_spent)
    FROM (
        SELECT SUM(amount) AS total_spent
        FROM payment
        GROUP BY customer_id
    ) AS sub
);
