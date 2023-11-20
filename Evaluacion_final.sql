USE sakila;


-- 1. Selecciona todos los nombres de las películas sin que aparezcan duplicados.

SELECT DISTINCT `title`
	FROM `film`;

-- 2. Muestra los nombres de todas las películas que tengan una clasificación de "PG-13".

SELECT `title`, `rating`
	FROM `film`
	WHERE `rating` = 'PG-13';


-- 3. Encuentra el título y la descripción de todas las películas que contengan la palabra "amazing" en su descripción.

SELECT `title`, `description`
	FROM `film`
	WHERE `description` LIKE'%amazing%';

-- 4. Encuentra el título de todas las películas que tengan una duración mayor a 120 minutos.

SELECT `title`, `length`
	FROM `film`
	WHERE `length` > 120;

-- 5.Recupera los nombres de todos los actores.

SELECT `first_name`
	FROM `actor`;

-- 6. Encuentra el nombre y apellido de los actores que tengan "Gibson" en su apellido.

SELECT `first_name`, `last_name`
	FROM `actor`
	WHERE `last_name` LIKE '%Gibson%';

-- 7. Encuentra los nombres de los actores que tengan un actor_id entre 10 y 20.

SELECT `first_name`, `actor_id`
	FROM `actor`
	WHERE `actor_id` BETWEEN 10 AND 20;

-- 8. Encuentra el título de las películas en la tabla film que no sean ni "R" ni "PG-13" en cuanto a su clasificación.

SELECT `title`, `rating`
	FROM `film`
	WHERE `rating` NOT IN ('R','PG-13');
    
-- 9. Encuentra la cantidad total de películas en cada clasificación de la tabla film y muestra la clasificación junto con el recuento.

SELECT `rating`, COUNT(*) AS `recuento` 
	FROM `film`
	GROUP BY `rating`;
    
-- 10. Encuentra la cantidad total de películas alquiladas por cada cliente y muestra el ID del cliente, su nombre y apellido junto con la cantidad de películas alquiladas.

SELECT `c`.`customer_id`, `c`.`first_name`, `c`.`last_name`, COUNT(`r`.`rental_id`) AS `cantidad_total_alquileres` 
FROM `customer` c INNER JOIN `rental` r
ON `c`.`customer_id` = `r`.`customer_id` 
GROUP BY `c`.`customer_id`, `c`.`first_name`, `c`.`last_name`;

-- 11.Encuentra la cantidad total de películas alquiladas por categoría y muestra el nombre de la categoría junto con el recuento de alquileres.

SELECT `c`.`name` AS `nombre_categoria`, COUNT(`r`.`rental_id`) AS `cantidad_total_alquileres`
	FROM `category` c INNER JOIN `film_category` fc ON `c`.`category_id` = `fc`.`category_id`
					  INNER JOIN `film` f ON `fc`.`film_id` = `f`.`film_id`
					  INNER JOIN `inventory` i ON `f`.`film_id` = `i`.`film_id`
                      INNER JOIN `rental` r ON `i`.`inventory_id` = `r`.`inventory_id`
	GROUP BY `c`.`name`;

-- 12. Encuentra el promedio de duración de las películas para cada clasificación de la tabla film y muestra la clasificación junto con el promedio de duración.

SELECT `rating`, AVG(`length`) AS `promedio_duracion_pelis`
	FROM `film`
	GROUP BY `rating`;

-- 13. Encuentra el nombre y apellido de los actores que aparecen en la película con title "Indian Love".

SELECT `a`.`first_name`, `a`.`last_name` 
	FROM `actor` a INNER JOIN `film_actor` fa ON `a`.`actor_id` = `fa`.`actor_id` 
				   INNER JOIN `film` f ON `fa`.`film_id` = `f`.`film_id` 
	WHERE `f`.`title` = 'Indian Love';

-- 14. Muestra el título de todas las películas que contengan la palabra "dog" o "cat" en su descripción.

SELECT `title`, `description`
	FROM `film`
	WHERE `description` LIKE '%dog%' OR description LIKE '%cat%';
    
-- 15.  Hay algún actor/actriz que no aparecen en ninguna película en la tabla film_actor.

SELECT `a`.`first_name`, `a`.`last_name` 
	FROM `actor` a LEFT JOIN `film_actor` fa ON `a`.`actor_id` = `fa`.`actor_id` 
	WHERE `fa`.`actor_id` IS NULL;

-- 16. Encuentra el título de todas las películas que fueron lanzadas entre el año 2005 y 2010. 

    SELECT `title`, `release_year` 
    FROM `film` 
    WHERE `release_year` BETWEEN 2005 AND 2010;
    
-- 17. Encuentra el título de todas las películas que son de la misma categoría que "Family"  ⚠️⚠️⚠️

SELECT `f`.`title`
	FROM `film` f JOIN `film_category` fc ON `f`.`film_id` = `fc`.`film_id`
				  JOIN `category` c ON `fc`.`category_id` = `c`.`category_id` 		
	WHERE `c`.`name` = 'Family';
    
-- 18. Muestra el nombre y apellido de los actores que aparecen en más de 10 películas. 

SELECT `a`.`first_name`, `a`.`last_name`
	FROM `actor` a JOIN `film_actor` fa ON `a`.`actor_id` = `fa`.`actor_id` 
	GROUP BY `a`.`actor_id` 
	HAVING COUNT(fa.film_id) > 10;
    
-- 19. Encuentra el título de todas las películas que son "R" y tienen una duración mayor a 2 horas en la tabla film.

 SELECT `title` 
	 FROM `film` 
	 WHERE `rating` = 'R' AND length > 120;
     
-- 20.  Encuentra las categorías de películas que tienen un promedio de duración superior a 120 minutos y muestra el nombre de la categoría junto con el promedio de duración.

SELECT `c`.`name` AS `nombre_categoria`, AVG(`f`.`length`) AS `promedio_duracion` 
	FROM `category` c INNER JOIN `film_category` fc ON `c`.`category_id` = `fc`.`category_id` 
					  INNER JOIN `film` f ON `fc`.`film_id` = `f`.`film_id`
	GROUP BY `c`.`name` 
	HAVING AVG(`f`.`length`) > 120;

-- 21. Encuentra los actores que han actuado en al menos 5 películas y muestra el nombre del actor junto con la cantidad de películas en las que han actuado.

SELECT `a`.`first_name`, `a`.`last_name`, COUNT(`fa`.`film_id`) AS `cantidad_peliculas`
	FROM `actor` a INNER JOIN `film_actor` fa ON `a`.`actor_id` = `fa`.`actor_id`
	GROUP BY `a`.`actor_id`
	HAVING COUNT(`fa`.`film_id`) >= 5;
    
-- 22. Encuentra el título de todas las películas que fueron alquiladas por más de 5 días. Utiliza una subconsulta para encontrar los rental_ids con una duración superior a 5 días y luego selecciona las películas correspondientes.

SELECT `title`
	FROM `film` 
    WHERE `film_id` IN (SELECT `f`.`film_id`
							FROM `film` f
								JOIN `inventory` i ON `f`.`film_id` = `i.film_id`
								JOIN `rental` r ON `i`.`inventory_id` = `r`.`inventory_id`
							WHERE `r`.`duracion` > 5);

-- 23. Encuentra el nombre y apellido de los actores que no han actuado en ninguna película de la categoría "Horror". Utiliza una subconsulta para encontrar los actores que han actuado en películas de la categoría "Horror" y luego excluyelos de la lista de actores.

SELECT `first_name`, `last_name`
	FROM `actor`
	WHERE `actor_id` NOT IN (SELECT DISTINCT `fa`.`actor_id`
								FROM `film_actor` fa
									JOIN `film_category` fc ON `fa`.`film_id` = `fc`.`film_id`
									JOIN `category` c ON `fc`.`category_id` = `c`.`category_id`
								WHERE `c`.`name` = 'Horror');
                                
-- 24. BONUS: Encuentra el título de las películas que son comedias y tienen una duración mayor a 180 minutos en la tabla film.

SELECT `f`.`title`
	FROM `film` f
		JOIN `film_category` fc ON `f`.`film_id` = `fc`.`film_id`
		JOIN `category` c ON `fc`.`category_id` = `c`.`category_id`
	WHERE `c`.`name` = 'Comedy' AND `f`.`length` > 180;  
    
    
-- 25. BONUS: Encuentra todos los actores que han actuado juntos en al menos una película. La consulta debe mostrar el nombre y apellido de los actores y el número de películas en las que han actuado juntos.

-- (Estoy en ello xD)    