Задача 3
Условие
Определить классы автомобилей, которые имеют наименьшую среднюю позицию в гонках, и вывести информацию о каждом автомобиле из этих классов, включая его имя, среднюю позицию, количество гонок, в которых он участвовал, 
страну производства класса автомобиля, а также общее количество гонок, в которых участвовали автомобили этих классов. Если несколько классов имеют одинаковую среднюю позицию, выбрать все из них.
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
ClassStats AS (
    SELECT
        car_class,
        AVG(average_position) AS class_avg_position,
        SUM(race_count) AS class_total_races
    FROM CarStats
    GROUP BY car_class
),
MinClassAvg AS (
    SELECT MIN(class_avg_position) AS min_avg_position
    FROM ClassStats
),
SelectedClasses AS (
    SELECT cs.car_class, cs.class_avg_position, cs.class_total_races
    FROM ClassStats cs
    JOIN MinClassAvg m ON cs.class_avg_position = m.min_avg_position
)
SELECT
    cs.car_name,
    cs.car_class,
    ROUND(cs.average_position, 4) AS average_position,
    cs.race_count,
    cs.country,
    sc.class_total_races
FROM CarStats cs
JOIN SelectedClasses sc ON cs.car_class = sc.car_class
ORDER BY cs.car_class, cs.car_name;
