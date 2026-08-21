-- Base de datos: helpdesk_db
-- Laboratorio 3 - Cloud-Ready Ops

CREATE DATABASE IF NOT EXISTS helpdesk_db;
USE helpdesk_db;

CREATE TABLE Empleados (
    id INT PRIMARY KEY,
    nombre VARCHAR(50)
);

INSERT INTO Empleados (id, nombre) VALUES (1, 'Administrador');
