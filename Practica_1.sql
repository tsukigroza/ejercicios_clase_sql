-- Ejercicio 1

DROP DATABASE IF EXISTS alojamientos;

CREATE DATABASE alojamientos
	CHARACTER SET utf8mb4
    COLLATE utf8mb4_0900_ai_ci;

USE alojamientos;

CREATE TABLE apartamento(
	codigo	CHAR(6)	PRIMARY KEY	NOT NULL,
    nombre	VARCHAR(60)		UNIQUE	NOT NULL,
    telefono_contacto	VARCHAR(15)	NOT NULL,
    plazas	TINYINT	UNSIGNED	NOT NULL	DEFAULT 4,
    precio_noche	DECIMAL(6,2)	NOT NULL,
    CONSTRAINT	chck_apartamento_plazas	CHECK(plazas > 0),
    CONSTRAINT chck_apartamento_precio_noche	CHECK(precio_noche>0)
)ENGINE = InnoDB;

-- Datos de prueba (no modificar):

INSERT INTO apartamento (codigo, nombre, telefono_contacto, plazas, precio_noche) VALUES
  ('APT001', 'Sol Centro', '+34 600 111 222', 4, 85.50);

INSERT INTO apartamento (codigo, nombre, telefono_contacto, precio_noche) VALUES
  ('APT002', 'Mirador Norte', '0034910223344', 120.00);

SELECT * FROM apartamento;

-- Ejercicio 2

USE alojamientos;
DROP TABLE IF EXISTS apartamento;
DROP DATABASE IF EXISTS alojamientos;



CREATE DATABASE alojamientos
	CHARACTER SET utf8mb4
    COLLATE utf8mb4_0900_ai_ci;

USE alojamientos;

CREATE TABLE apartamento(
	codigo	CHAR(6)	PRIMARY KEY	NOT NULL,
    nombre	VARCHAR(60)		UNIQUE	NOT NULL,
    telefono_contacto	VARCHAR(15)	NOT NULL,
    plazas	TINYINT	UNSIGNED	NOT NULL	DEFAULT 4,
    precio_noche	DECIMAL(6,2)	NOT NULL,
    CONSTRAINT	chck_apartamento_plazas	CHECK(plazas > 0),
    CONSTRAINT chck_apartamento_precio_noche	CHECK(precio_noche>0)
)ENGINE = InnoDB;

CREATE TABLE reserva(
	codigo_apartamento	CHAR(6)	NOT NULL,
    fecha_entrada DATE	NOT NULL,
    dni_huesped	CHAR(9)	NOT NULL,
    fecha_salida	DATE	NOT NULL, 
    regimen	ENUM('solo_alojamiento', 'desayuno', 'media_pension')	NOT NULL	DEFAULT 'solo_alojamiento',
    importe_total	DECIMAL(7,2)	NOT NULL,
    descuento	DECIMAL(7,2),
    CONSTRAINT pk_reserva	PRIMARY KEY (codigo_apartamento, fecha_entrada),
    CONSTRAINT fk_reserva_apartamento FOREIGN KEY (codigo_apartamento)	REFERENCES apartamento(codigo),
    CONSTRAINT chck_reserva_fechas CHECK(fecha_salida >= fecha_entrada),
    CONSTRAINT chck_reserva_importe_total CHECK(importe_total > 0),
    CONSTRAINT chck_reserva_descuento	CHECK(descuento <= importe_total)
)ENGINE=InnoDB;


-- Datos de prueba (no modificar):
INSERT INTO apartamento (codigo, nombre, telefono_contacto, plazas, precio_noche) VALUES
  ('APT001', 'Sol Centro', '+34 600 111 222', 4, 85.50);

INSERT INTO apartamento (codigo, nombre, telefono_contacto, precio_noche) VALUES
  ('APT002', 'Mirador Norte', '0034910223344', 120.00);

INSERT INTO reserva (codigo_apartamento, fecha_entrada, dni_huesped, fecha_salida, regimen, importe_total, descuento) VALUES
  ('APT001', '2026-12-01', '11111111A', '2026-12-05', 'desayuno', 342.00, 20.00);

INSERT INTO reserva (codigo_apartamento, fecha_entrada, dni_huesped, fecha_salida, importe_total, descuento) VALUES
  ('APT002', '2026-12-10', '22222222B', '2026-12-12', 240.00, NULL);

SELECT * FROM apartamento;
SELECT * FROM reserva;
