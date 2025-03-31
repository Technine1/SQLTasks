Задача 4
Условие
Определить, какие автомобили имеют среднюю позицию лучше (меньше) средней позиции всех автомобилей в своем классе (то есть автомобилей в классе должно быть минимум два, чтобы выбрать один из них). 
Вывести информацию об этих автомобилях, включая их имя, класс, среднюю позицию, количество гонок, в которых они участвовали, и страну производства класса автомобиля. 
Также отсортировать результаты по классу и затем по средней позиции в порядке возрастания.
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
ClassAverages AS (
    SELECT
        car_class,
        AVG(avg_position) AS class_avg_position,
        COUNT(*) AS car_count_in_class
    FROM CarStats
    GROUP BY car_class
),
FilteredClasses AS (
    SELECT * 
    FROM ClassAverages
    WHERE car_count_in_class >= 2
)
SELECT
    cs.car_name,
    cs.car_class,
    ROUND(cs.avg_position, 4) AS avg_position,
    cs.race_count,
    cs.country
FROM CarStats cs
JOIN FilteredClasses fc ON cs.car_class = fc.car_class
WHERE cs.avg_position < fc.class_avg_position
ORDER BY cs.car_class, cs.avg_position;
