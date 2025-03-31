Задача 2
Условие

Найти всех сотрудников, подчиняющихся Ивану Иванову с EmployeeID = 1, включая их подчиненных и подчиненных подчиненных. Для каждого сотрудника вывести следующую информацию:

EmployeeID: идентификатор сотрудника.
Имя сотрудника.
Идентификатор менеджера.
Название отдела, к которому он принадлежит.
Название роли, которую он занимает.
Название проектов, к которым он относится (если есть, конкатенированные в одном столбце).
Название задач, назначенных этому сотруднику (если есть, конкатенированные в одном столбце).
Общее количество задач, назначенных этому сотруднику.
Общее количество подчиненных у каждого сотрудника (не включая подчиненных их подчиненных).
Если у сотрудника нет назначенных проектов или задач, отобразить NULL.
Решение
WITH RECURSIVE Subordinates AS (
    SELECT
        e.EmployeeID,
        e.Name,
        e.ManagerID,
        e.DepartmentID,
        e.RoleID
    FROM Employees e
    WHERE e.ManagerID = 1

    UNION ALL

    SELECT
        e.EmployeeID,
        e.Name,
        e.ManagerID,
        e.DepartmentID,
        e.RoleID
    FROM Employees e
    JOIN Subordinates s ON e.ManagerID = s.EmployeeID
),

DirectSubCount AS (
    SELECT
        ManagerID,
        COUNT(*) AS direct_sub_count
    FROM Employees
    GROUP BY ManagerID
),

TaskStats AS (
    SELECT
        AssignedTo,
        GROUP_CONCAT(TaskName ORDER BY TaskName SEPARATOR ', ') AS tasks,
        COUNT(*) AS task_count
    FROM Tasks
    GROUP BY AssignedTo
),

EmployeeProjects AS (
    SELECT
        e.EmployeeID,
        GROUP_CONCAT(DISTINCT p.ProjectName ORDER BY p.ProjectName SEPARATOR ', ') AS projects
    FROM Employees e
    JOIN Projects p ON e.DepartmentID = p.DepartmentID
    GROUP BY e.EmployeeID
)

SELECT
    s.EmployeeID,
    s.Name,
    s.ManagerID,
    d.DepartmentName,
    r.RoleName,
    ep.projects AS Projects,
    ts.tasks AS Tasks,
    ts.task_count AS TaskCount,
    COALESCE(ds.direct_sub_count, 0) AS DirectSubordinates
FROM Subordinates s
LEFT JOIN Departments d ON s.DepartmentID = d.DepartmentID
LEFT JOIN Roles r ON s.RoleID = r.RoleID
LEFT JOIN EmployeeProjects ep ON s.EmployeeID = ep.EmployeeID
LEFT JOIN TaskStats ts ON s.EmployeeID = ts.AssignedTo
LEFT JOIN DirectSubCount ds ON s.EmployeeID = ds.ManagerID
ORDER BY s.Name;
