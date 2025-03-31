Задача 5
Условие
Определить, какие классы автомобилей имеют наибольшее количество автомобилей с низкой средней позицией (больше 3.0) и вывести информацию о каждом автомобиле из этих классов, включая его имя, класс, среднюю позицию, количество гонок, в которых он участвовал, 
страну производства класса автомобиля, а также общее количество гонок для каждого класса. Отсортировать результаты по количеству автомобилей с низкой средней позицией.
Решение
WITH CarStats AS (
    SELECT
        c.name AS car_name,
        c.class AS car_class,
        cl.country,
        AVG(r.position) AS avg_position,
        COUNT(*) AS race_count
    FROM Cars c
    JOIN Classes cl ON c.class = cl.class
    JOIN Results r ON c.name = r.car
    GROUP BY c.name, c.class, cl.country
),
LowPerfCars AS (
    SELECT *
    FROM CarStats
    WHERE avg_position > 3.0
),
ClassAggregates AS (
    SELECT
        car_class,
        COUNT(*) AS low_perf_count,
        SUM(race_count) AS total_races_in_class
    FROM LowPerfCars
    GROUP BY car_class
),
Final AS (
    SELECT
        lpc.car_name,
        lpc.car_class,
        ROUND(lpc.avg_position, 4) AS avg_position,
        lpc.race_count,
        lpc.country,
        ca.total_races_in_class,
        ca.low_perf_count
    FROM LowPerfCars lpc
    JOIN ClassAggregates ca ON lpc.car_class = ca.car_class
)
SELECT *
FROM Final
ORDER BY low_perf_count DESC, car_class, avg_position;
