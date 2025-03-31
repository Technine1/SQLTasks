Задача 2
Условие

Необходимо провести анализ клиентов, которые сделали более двух бронирований в разных отелях и потратили более 500 долларов на свои бронирования. Для этого:

Определить клиентов, которые сделали более двух бронирований и забронировали номера в более чем одном отеле. Вывести для каждого такого клиента следующие данные: ID_customer, имя, общее количество бронирований, общее количество уникальных отелей, в которых они бронировали номера, и общую сумму, потраченную на бронирования.
Также определить клиентов, которые потратили более 500 долларов на бронирования, и вывести для них ID_customer, имя, общую сумму, потраченную на бронирования, и общее количество бронирований.
В результате объединить данные из первых двух пунктов, чтобы получить список клиентов, которые соответствуют условиям обоих запросов. Отобразить поля: ID_customer, имя, общее количество бронирований, общую сумму, потраченную на бронирования, и общее количество уникальных отелей.
Результаты отсортировать по общей сумме, потраченной клиентами, в порядке возрастания.
Решение
WITH CustomerStats AS (
    SELECT
        c.ID_customer,
        c.name,
        COUNT(b.ID_booking) AS total_bookings,
        COUNT(DISTINCT h.ID_hotel) AS unique_hotels,
        SUM(DATEDIFF(b.check_out_date, b.check_in_date) * r.price) AS total_spent
    FROM Booking b
    JOIN Customer c ON b.ID_customer = c.ID_customer
    JOIN Room r ON b.ID_room = r.ID_room
    JOIN Hotel h ON r.ID_hotel = h.ID_hotel
    GROUP BY c.ID_customer, c.name
),
FilteredA AS (
    SELECT *
    FROM CustomerStats
    WHERE total_bookings > 2 AND unique_hotels > 1
),
FilteredB AS (
    SELECT *
    FROM CustomerStats
    WHERE total_spent > 500
),
Final AS (
    SELECT
        a.ID_customer,
        a.name,
        a.total_bookings,
        a.total_spent,
        a.unique_hotels
    FROM FilteredA a
    INNER JOIN FilteredB b ON a.ID_customer = b.ID_customer
)
SELECT *
FROM Final
ORDER BY total_spent ASC;
