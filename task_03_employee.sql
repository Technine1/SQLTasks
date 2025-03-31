Задача 3
Условие

Найти всех сотрудников, которые занимают роль менеджера и имеют подчиненных (то есть число подчиненных больше 0). Для каждого такого сотрудника вывести следующую информацию:

EmployeeID: идентификатор сотрудника.
Имя сотрудника.
Идентификатор менеджера.
Название отдела, к которому он принадлежит.
Название роли, которую он занимает.
Название проектов, к которым он относится (если есть, конкатенированные в одном столбце).
Название задач, назначенных этому сотруднику (если есть, конкатенированные в одном столбце).
Общее количество подчиненных у каждого сотрудника (включая их подчиненных).
Если у сотрудника нет назначенных проектов или задач, отобразить NULL.
Решение
WITH RECURSIVE SubTree AS (
    -- Рекурсивно находим всех подчинённых каждого сотрудника
    SELECT
        e.ManagerID AS RootManagerID,
        e.EmployeeID AS SubordinateID
    FROM Employees e
    WHERE e.ManagerID IS NOT NULL

    UNION ALL

    SELECT
        st.RootManagerID,
        e.EmployeeID
    FROM Employees e
    JOIN SubTree st ON e.ManagerID = st.SubordinateID
),

-- Считаем количество всех подчинённых для каждого менеджера
SubordinateCounts AS (
    SELECT
        RootManagerID AS EmployeeID,
        COUNT(*) AS TotalSubordinates
    FROM SubTree
    GROUP BY RootManagerID
),

-- Список задач и их агрегация
TaskStats AS (
    SELECT
        AssignedTo,
        GROUP_CONCAT(TaskName ORDER BY TaskName SEPARATOR ', ') AS Tasks
    FROM Tasks
    GROUP BY AssignedTo
),

-- Список проектов, связанных с отделом
ProjectStats AS (
    SELECT
        e.EmployeeID,
        GROUP_CONCAT(DISTINCT p.ProjectName ORDER BY p.ProjectName SEPARATOR ', ') AS Projects
    FROM Employees e
    JOIN Projects p ON e.DepartmentID = p.DepartmentID
    GROUP BY e.EmployeeID
)

-- Основной выбор
SELECT
    e.EmployeeID,
    e.Name,
    e.ManagerID,
    d.DepartmentName,
    r.RoleName,
    ps.Projects,
    ts.Tasks,
    sc.TotalSubordinates
FROM Employees e
JOIN Roles r ON e.RoleID = r.RoleID
JOIN Departments d ON e.DepartmentID = d.DepartmentID
LEFT JOIN SubordinateCounts sc ON e.EmployeeID = sc.EmployeeID
LEFT JOIN ProjectStats ps ON e.EmployeeID = ps.EmployeeID
LEFT JOIN TaskStats ts ON e.EmployeeID = ts.AssignedTo
WHERE r.RoleName = 'Менеджер'
  AND sc.TotalSubordinates > 0
ORDER BY e.Name;
