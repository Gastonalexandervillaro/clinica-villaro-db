-- 1. LIMPIEZA Y ENTORNO
DROP DATABASE IF EXISTS clinica_villaro;
CREATE DATABASE clinica_villaro;
USE clinica_villaro;

-- 2. ESTRUCTURA (DDL)
CREATE TABLE especialidades (
    id_especialidad INT AUTO_INCREMENT PRIMARY KEY,
    nombre_esp VARCHAR(50)
);

CREATE TABLE medicos (
    id_medico INT AUTO_INCREMENT PRIMARY KEY,
    nombre VARCHAR(100),
    matricula VARCHAR(20),
    id_especialidad INT,
    FOREIGN KEY (id_especialidad) REFERENCES especialidades(id_especialidad)
);

CREATE TABLE pacientes (
    id_paciente INT AUTO_INCREMENT PRIMARY KEY,
    nombre VARCHAR(100),
    dni VARCHAR(20),
    telefono VARCHAR(20)
);

CREATE TABLE turnos (
    id_turno INT AUTO_INCREMENT PRIMARY KEY,
    fecha_turno DATETIME,
    id_medico INT,
    id_paciente INT,
    FOREIGN KEY (id_medico) REFERENCES medicos(id_medico),
    FOREIGN KEY (id_paciente) REFERENCES pacientes(id_paciente)
);

CREATE TABLE log_pacientes (
    id_log INT AUTO_INCREMENT PRIMARY KEY,
    mensaje VARCHAR(200),
    fecha_registro DATETIME,
    usuario VARCHAR(50)
);

-- 3. CARGA DE DATOS INICIALES (DML)
INSERT INTO especialidades (nombre_esp) VALUES 
('Cardiología'), ('Pediatría'), ('Traumatología'), ('Dermatología'), ('Oftalmología');

INSERT INTO medicos (nombre, matricula, id_especialidad) VALUES 
('Dr. Gaston Villaro', 'MAT-123', 1), 
('Dra. Laura Sosa', 'MAT-456', 2), 
('Dr. Carlos Gomez', 'MAT-789', 3), 
('Dra. Maria Perez', 'MAT-101', 4), 
('Dr. Jose Lopez', 'MAT-202', 5);

INSERT INTO pacientes (nombre, dni, telefono) VALUES 
('Juan Perez', '30123456', '2615001122'), 
('Maria Lopez', '32987654', '2616003344'), 
('Roberto Sanchez', '28456123', '2617005566'), 
('Ana Torres', '35789456', '2618007788'),
('Lucia Fernandez', '33111222', '2619001100');

-- 4. PROGRAMACIÓN Y AUTOMATIZACIÓN (PROCEDURES)
DELIMITER //
CREATE PROCEDURE sp_generar_turnos_masivos()
BEGIN
    DECLARE i INT DEFAULT 1;
    WHILE i <= 1000 DO
        INSERT INTO turnos (fecha_turno, id_medico, id_paciente) 
        VALUES (DATE_ADD('2026-01-01', INTERVAL FLOOR(RAND() * 365) DAY), FLOOR(1 + RAND() * 5), FLOOR(1 + RAND() * 5));
        SET i = i + 1;
    END WHILE;
END //
DELIMITER ;

CALL sp_generar_turnos_masivos();

-- 5. REPORTES (VIEWS)
CREATE VIEW v_turnos_por_medico AS
SELECT m.nombre AS Medico, COUNT(t.id_turno) AS Cantidad_Turnos
FROM medicos m JOIN turnos t ON m.id_medico = t.id_medico GROUP BY m.nombre;

CREATE VIEW v_demanda_especialidades AS
SELECT e.nombre_esp AS Especialidad, COUNT(t.id_turno) AS Total_Turnos
FROM especialidades e JOIN medicos m ON e.id_especialidad = m.id_especialidad
JOIN turnos t ON m.id_medico = t.id_medico GROUP BY e.nombre_esp ORDER BY Total_Turnos DESC;

-- 6. LÓGICA PERSONALIZADA (FUNCTIONS)
DELIMITER //
CREATE FUNCTION fn_nivel_demanda(p_id_medico INT) RETURNS VARCHAR(20) DETERMINISTIC
BEGIN
    DECLARE v_cantidad INT;
    SELECT COUNT(*) INTO v_cantidad FROM turnos WHERE id_medico = p_id_medico;
    IF v_cantidad > 210 THEN RETURN 'CRÍTICO';
    ELSEIF v_cantidad > 190 THEN RETURN 'ALTO';
    ELSE RETURN 'NORMAL';
    END IF;
END //
DELIMITER ;

-- 7. AUDITORÍA (TRIGGERS)
DELIMITER //
CREATE TRIGGER tr_nuevo_paciente_log AFTER INSERT ON pacientes FOR EACH ROW
BEGIN
    INSERT INTO log_pacientes (mensaje, fecha_registro, usuario)
    VALUES (CONCAT('Nuevo paciente: ', NEW.nombre, ' DNI: ', NEW.dni), NOW(), USER());
END //
DELIMITER ;
