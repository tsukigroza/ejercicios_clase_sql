DROP DATABASE IF EXISTS academia;

CREATE DATABASE academia CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci;

USE academia;

-- 1. Primero crear tablas sin claves ajenas
CREATE TABLE persona(
	dni	CHAR(9)	PRIMARY KEY	NOT NULL,
    nombre	VARCHAR(80)	NOT NULL
);

-- 2. Segundo crear tablas que dependan de las anteriores

CREATE TABLE alumno(
	dni	CHAR(9)	PRIMARY KEY	NOT NULL,
    CONSTRAINT fk_alumno_persona FOREIGN KEY (dni)	REFERENCES persona(dni)
);

CREATE TABLE alumno_email(
	dni	CHAR(9)	NOT NULL,
    email	VARCHAR(250)	NOT NULL,
    CONSTRAINT fk_alumno_mail_alumno FOREIGN KEY (dni)	REFERENCES alumno(dni),
    CONSTRAINT pk_alumno_email	PRIMARY KEY (dni, email)
);

CREATE TABLE profesor(
	dni	CHAR(9)	PRIMARY KEY	NOT NULL,
    puesto	VARCHAR(40)	NOT NULL,
    email	VARCHAR(250)	NOT NULL,
    CONSTRAINT	uq_profesor_email	UNIQUE(email),
    CONSTRAINT fk_profesor_persona FOREIGN KEY (dni)	REFERENCES persona(dni)
);

CREATE TABLE curso(
	codigo	CHAR(6)	PRIMARY KEY	NOT NULL,
    nombre	VARCHAR(50)	NOT NULL,
    coordinador	CHAR(9)	NOT NULL,
    CONSTRAINT	uq_curso_nombre	UNIQUE(nombre),
    CONSTRAINT fk_curso_profesor FOREIGN KEY (coordinador)	 REFERENCES profesor(dni)
);

CREATE TABLE matricula(
	dni_alumno	CHAR(9)	NOT NULL,
    codigo_curso	CHAR(6)	NOT NULL,
    anio	YEAR	NOT NULL,
    nota	DECIMAL(4,2) ,  -- NULL mientras no esté evaluado
    CONSTRAINT	chk_matricula_nota	CHECK(nota>=0 AND nota<=10),
    CONSTRAINT fk_matricula_alumno	FOREIGN KEY (dni_alumno)	REFERENCES alumno(dni),
    CONSTRAINT fk_matricula_curso	FOREIGN KEY (codigo_curso)	REFERENCES curso(codigo),
    CONSTRAINT pk_matricula	PRIMARY KEY (dni_alumno, codigo_curso, anio)
);

CREATE TABLE tutor(
	codigo_curso	CHAR(6)	NOT NULL,
    dni_profesor	CHAR(9)	NOT NULL,
    CONSTRAINT fk_tutor_curso	FOREIGN KEY (codigo_curso)	REFERENCES curso(codigo),
    CONSTRAINT fk_tutor_profesor	FOREIGN KEY (dni_profesor)	REFERENCES profesor(dni),
    CONSTRAINT	pk_tutor	PRIMARY KEY (codigo_curso, dni_profesor)
);

SHOW CREATE TABLE tutor;

SHOW VARIABLES LIKE 'character_set';
SHOW VARIABLES LIKE 'collation%';
