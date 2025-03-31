Задача 3
Условие

Вам необходимо провести анализ данных о бронированиях в отелях и определить предпочтения клиентов по типу отелей. Для этого выполните следующие шаги:

Категоризация отелей.
Определите категорию каждого отеля на основе средней стоимости номера:

«Дешевый»: средняя стоимость менее 175 долларов.
«Средний»: средняя стоимость от 175 до 300 долларов.
«Дорогой»: средняя стоимость более 300 долларов.
Анализ предпочтений клиентов.
Для каждого клиента определите предпочитаемый тип отеля на основании условия ниже:

Если у клиента есть хотя бы один «дорогой» отель, присвойте ему категорию «дорогой».
Если у клиента нет «дорогих» отелей, но есть хотя бы один «средний», присвойте ему категорию «средний».
Если у клиента нет «дорогих» и «средних» отелей, но есть «дешевые», присвойте ему категорию предпочитаемых отелей «дешевый».
Вывод информации.
Выведите для каждого клиента следующую информацию:

ID_customer: уникальный идентификатор клиента.
name: имя клиента.
preferred_hotel_type: предпочитаемый тип отеля.
visited_hotels: список уникальных отелей, которые посетил клиент.
Сортировка результатов.
Отсортируйте клиентов так, чтобы сначала шли клиенты с «дешевыми» отелями, затем со «средними» и в конце — с «дорогими».
Решение
WITH HotelAvgPrice AS (
    SELECT
        h.ID_hotel,
        h.name AS hotel_name,
        AVG(r.price) AS avg_price,
        CASE
            WHEN AVG(r.price) < 175 THEN 'Дешевый'
            WHEN AVG(r.price) BETWEEN 175 AND 300 THEN 'Средний'
            WHEN AVG(r.price) > 300 THEN 'Дорогой'
        END AS hotel_category
    FROM Hotel h
    JOIN Room r ON h.ID_hotel = r.ID_hotel
    GROUP BY h.ID_hotel, h.name
),
CustomerHotelCategories AS (
    SELECT DISTINCT
        c.ID_customer,
        c.name AS customer_name,
        h.ID_hotel,
        hp.hotel_name,
        hp.hotel_category
    FROM Booking b
    JOIN Customer c ON b.ID_customer = c.ID_customer
    JOIN Room r ON b.ID_room = r.ID_room
    JOIN Hotel h ON r.ID_hotel = h.ID_hotel
    JOIN HotelAvgPrice hp ON h.ID_hotel = hp.ID_hotel
),
CustomerPreferences AS (
    SELECT
        ID_customer,
        customer_name,
        GROUP_CONCAT(DISTINCT hotel_name ORDER BY hotel_name SEPARATOR ', ') AS visited_hotels,
        MAX(
            CASE hotel_category
                WHEN 'Дорогой' THEN 3
                WHEN 'Средний' THEN 2
                WHEN 'Дешевый' THEN 1
            END
        ) AS category_rank
    FROM CustomerHotelCategories
    GROUP BY ID_customer, customer_name
),
FinalResult AS (
    SELECT
        cp.ID_customer,
        cp.customer_name,
        CASE cp.category_rank
            WHEN 3 THEN 'Дорогой'
            WHEN 2 THEN 'Средний'
            WHEN 1 THEN 'Дешевый'
        END AS preferred_hotel_type,
        cp.visited_hotels
    FROM CustomerPreferences cp
)
SELECT *
FROM FinalResult
ORDER BY
    FIELD(preferred_hotel_type, 'Дешевый', 'Средний', 'Дорогой'), customer_name;
