Задача 1
Условие
Определить, какие автомобили из каждого класса имеют наименьшую среднюю позицию в гонках, и вывести информацию о каждом таком автомобиле для данного класса, включая его класс, среднюю позицию и количество гонок, в которых он участвовал. Также отсортировать результаты по средней позиции
Решение
WITH CarStats AS (
    SELECT
        c.name,
        c.class,
        AVG(r.position) AS avg_position,
        COUNT(r.race) AS race_count
    FROM Cars c
    JOIN Results r ON c.name = r.car
    GROUP BY c.name, c.class
),
RankedCars AS (
    SELECT *,
           RANK() OVER (PARTITION BY class ORDER BY avg_position ASC) AS rank_in_class
    FROM CarStats
)
SELECT
    class,
    name,
    ROUND(avg_position, 2) AS avg_position,
    race_count
FROM RankedCars
WHERE rank_in_class = 1
ORDER BY avg_position ASC;
