DROP DATABASE IF EXISTS biblioteca;

CREATE DATABASE biblioteca CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci;

USE biblioteca;

CREATE TABLE socio(
	dni	CHAR(9) PRIMARY KEY NOT NULL,
    nombre	VARCHAR(80)	NOT NULL
);

-- Corregir id para que sea puesto por el sistema
CREATE TABLE autor(
	id	INT AUTO_INCREMENT PRIMARY KEY,
    nombre	VARCHAR(80)	NOT NULL,
    pais	VARCHAR(100)	NOT NULL
);

CREATE TABLE articulo(
	codigo	CHAR(10)	PRIMARY KEY	NOT NULL,
    titulo	VARCHAR(80)	NOT NULL,
    id_autor	CHAR(10)	NOT NULL,
    tipo	ENUM('Libro', 'CD', 'Pelicula')	NOT NULL,
	paginas	SMALLINT UNSIGNED,
    duracion	SMALLINT UNSIGNED,
	CONSTRAINT chk_tipo	CHECK(
		(tipo='Libro' AND paginas IS NOT NULL AND duracion IS NULL) OR
		(tipo='CD' AND paginas IS NULL AND duracion IS NULL) OR
		(tipo='Pelicula' AND paginas IS NULL AND duracion IS NOT NULL)    
    ),
    CONSTRAINT fk_articulo_autor	FOREIGN KEY (id_autor)	REFERENCES autor(id),
    CONSTRAINT chk_codigo	CHECK (codigo REGEXP '^L-[0-9]{8}$')

);

CREATE TABLE palabra_clave(
	codigo_articulo CHAR(10)	NOT NULL,
    palabra	VARCHAR(80)	NOT NULL,
    CONSTRAINT pk_palabra_clave	PRIMARY KEY (codigo_articulo, palabra),
    CONSTRAINT	fk_palabra_clave_articulo	FOREIGN KEY (codigo_articulo) REFERENCES articulo(codigo)
);

CREATE TABLE prestamo(
	dni_socio	CHAR(9)	NOT NULL,
    codigo_articulo	CHAR(10)	NOT NULL,
    fecha	DATE	NOT NULL,
    CONSTRAINT pk_prestamo PRIMARY KEY (dni_socio, codigo_articulo, fecha),
    CONSTRAINT fk_prestamo_socio	FOREIGN KEY (dni_socio)	REFERENCES socio(dni),
    CONSTRAINT fk_prestamo_articulo	FOREIGN KEY (codigo_articulo)	REFERENCES articulo(codigo)
);

CREATE TABLE compra(
	codigo_articulo	CHAR(10)	NOT NULL,
    dni_socio	CHAR(9)	NOT NULL,
    CONSTRAINT pk_compra	PRIMARY KEY (codigo_articulo, dni_socio),
    CONSTRAINT fk_compra_articulo	FOREIGN KEY (codigo_articulo)	REFERENCES articulo(codigo),
    CONSTRAINT fk_compra_socio	FOREIGN KEY (dni_socio)	REFERENCES	socio(dni)
);


SET NAMES utf8mb4;
USE biblioteca;

-- 1. Filas válidas: todas deben entrar ------------------------------------

INSERT INTO socio VALUES
  ('12345678Z', 'Carmen Ortega'), ('23456789D', 'Javier Luna'), ('34567890V', 'Nuria Peral');
INSERT INTO autor (nombre, pais) VALUES
  ('Carmen Laforet', 'España'), ('Rosalía', 'España'), ('Pedro Almodóvar', 'España'),
  ('Ursula K. Le Guin', 'Estados Unidos');
INSERT INTO articulo VALUES
  ('L-00000001', 'Nada',                     1, 'Libro',    320,  NULL),
  ('L-00000002', 'Los desposeídos',          4, 'Libro',    416,  NULL),
  ('C-00000001', 'El mal querer',            2, 'CD',       NULL, NULL),
  ('P-00000001', 'Mujeres al borde de un ataque de nervios', 3, 'Pelicula', NULL, 88);
INSERT INTO palabra_clave VALUES
  ('L-00000001', 'posguerra'), ('L-00000001', 'Barcelona'), ('L-00000002', 'utopía');
INSERT INTO prestamo VALUES
  ('12345678Z', 'L-00000001', '2026-09-01'),
  ('12345678Z', 'L-00000001', '2026-10-15'),   -- el mismo artículo en otra fecha
  ('23456789D', 'P-00000001', '2026-10-20');
INSERT INTO compra VALUES ('C-00000001', '23456789D');

-- 2. Filas que una solución correcta debe rechazar ------------------------

-- Tipo fuera de la lista
INSERT INTO articulo VALUES ('R-00000001', 'Revista Muy Interesante', 1, 'Revista', 98, NULL);
-- Libro sin páginas
INSERT INTO articulo VALUES ('L-00000003', 'Sin páginas', 1, 'Libro', NULL, NULL);
-- Libro con duración
INSERT INTO articulo VALUES ('L-00000004', 'Audiolibro mal clasificado', 1, 'Libro', 200, 340);
-- Película con páginas
INSERT INTO articulo VALUES ('P-00000002', 'Película con páginas', 3, 'Pelicula', 100, 95);
-- CD con duración
INSERT INTO articulo VALUES ('C-00000002', 'CD con duración', 2, 'CD', NULL, 45);
-- Páginas o duración no positivas
INSERT INTO articulo VALUES ('L-00000005', 'Cero páginas', 1, 'Libro', 0, NULL);
-- Artículo sin autor o con un autor inexistente
INSERT INTO articulo (codigo, titulo, tipo, paginas) VALUES ('L-00000006', 'Anónimo', 'Libro', 120);
INSERT INTO articulo VALUES ('L-00000007', 'Autor fantasma', 99, 'Libro', 120, NULL);
-- El mismo préstamo dos veces el mismo día
INSERT INTO prestamo VALUES ('12345678Z', 'L-00000001', '2026-09-01');
-- Un artículo comprado dos veces
INSERT INTO compra VALUES ('C-00000001', '12345678Z');
-- Baja de un socio con préstamos o con compras
DELETE FROM socio WHERE dni = '12345678Z';
DELETE FROM socio WHERE dni = '23456789D';

-- 3. Debe funcionar: un socio sin préstamos ni compras se puede borrar
DELETE FROM socio WHERE dni = '34567890V';
SELECT COUNT(*) AS socios FROM socio;          -- 2


