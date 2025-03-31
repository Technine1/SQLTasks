-- Скрипт создания таблиц для PostgreSQL
CREATE TABLE Departments (
    DepartmentID SERIAL PRIMARY KEY,
    DepartmentName VARCHAR(100) NOT NULL
);
-- Остальная часть структуры см. в описании выше
