Задача 2
Условие
Определить автомобиль, который имеет наименьшую среднюю позицию в гонках среди всех автомобилей, и вывести информацию об этом автомобиле, включая его класс, среднюю позицию, количество гонок, в которых он участвовал, и страну производства класса автомобиля. 
Если несколько автомобилей имеют одинаковую наименьшую среднюю позицию, выбрать один из них по алфавиту (по имени автомобиля).
Решение
WITH CarStats AS (
    SELECT
        c.name AS car_name,
        c.class AS car_class,
        cl.country,
        AVG(r.position) AS average_position,
        COUNT(r.race) AS race_count
    FROM Cars c
    JOIN Classes cl ON c.class = cl.class
    JOIN Results r ON c.name = r.car
    GROUP BY c.name, c.class, cl.country
),
RankedCar AS (
    SELECT *,
           RANK() OVER (ORDER BY average_position ASC, car_name ASC) AS rank_overall
    FROM CarStats
)
SELECT
    car_name,
    car_class,
    ROUND(average_position, 4) AS average_position,
    race_count,
    country
FROM RankedCar
WHERE rank_overall = 1;
