-- ======================================================
-- PROYECTO: Sistema de Gestión de Clínica
-- ALUMNO: Gaston Alexander Villaro
-- ======================================================
-- Se incluyeron sentencias DROP TABLE IF EXISTS para garantizar que el esquema 
-- pueda ser recreado limpiamente, evitando conflictos con tablas preexistentes.
CREATE DATABASE IF NOT EXISTS clinica_villaro;
USE clinica_villaro;
-- Se borran en orden inverso a su creación para no romper las relaciones DROP TABLE
-- Primero borro las tablas por si tengo que volver a correr el script desde cero
DROP TABLE IF EXISTS turnos;
DROP TABLE IF EXISTS medicos;
DROP TABLE IF EXISTS pacientes;
DROP TABLE IF EXISTS especialidades;

-- Tabla para organizar a los médicos por su área
CREATE TABLE especialidades (
    id_especialidad INT AUTO_INCREMENT PRIMARY KEY,
    nombre_esp VARCHAR(50) NOT NULL
);
-- Datos básicos de los pacientes para la clínica
CREATE TABLE pacientes (
    id_paciente INT AUTO_INCREMENT PRIMARY KEY,
    nombre VARCHAR(100) NOT NULL,
    dni VARCHAR(20) NOT NULL,
    telefono VARCHAR(20)
);
-- Registro de profesionales. id_especialidad es la conexión con la tabla de arriba
CREATE TABLE medicos (
    id_medico INT AUTO_INCREMENT PRIMARY KEY,
    nombre VARCHAR(100) NOT NULL,
    matricula VARCHAR(20) NOT NULL,
    id_especialidad INT,
    FOREIGN KEY (id_especialidad) REFERENCES especialidades(id_especialidad)
);
-- Esta es la tabla principal que une al médico con el paciente en un horario
CREATE TABLE turnos (
    id_turno INT AUTO_INCREMENT PRIMARY KEY,
    fecha_turno DATE NOT NULL,
    id_medico INT,
    id_paciente INT,
    FOREIGN KEY (id_medico) REFERENCES medicos(id_medico),
    FOREIGN KEY (id_paciente) REFERENCES pacientes(id_paciente)
);