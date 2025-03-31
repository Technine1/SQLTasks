Задача 1
Условие
Определить, какие клиенты сделали более двух бронирований в разных отелях, и вывести информацию о каждом таком клиенте, включая его имя, электронную почту, телефон, общее количество бронирований, 
а также список отелей, в которых они бронировали номера (объединенные в одно поле через запятую с помощью CONCAT). 
Также подсчитать среднюю длительность их пребывания (в днях) по всем бронированиям. Отсортировать результаты по количеству бронирований в порядке убывания.
Решение
SELECT
    c.name,
    c.email,
    c.phone,
    COUNT(b.ID_booking) AS total_bookings,
    GROUP_CONCAT(DISTINCT h.name ORDER BY h.name SEPARATOR ', ') AS hotels,
    ROUND(AVG(DATEDIFF(b.check_out_date, b.check_in_date)), 2) AS avg_stay_length
FROM Booking b
JOIN Customer c ON b.ID_customer = c.ID_customer
JOIN Room r ON b.ID_room = r.ID_room
JOIN Hotel h ON r.ID_hotel = h.ID_hotel
GROUP BY c.ID_customer
HAVING COUNT(DISTINCT h.ID_hotel) > 1
   AND COUNT(b.ID_booking) > 2
ORDER BY total_bookings DESC;
