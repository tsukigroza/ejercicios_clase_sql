DROP DATABASE IF EXISTS foro_tecnico;

CREATE DATABASE foro_tecnico CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci;

USE foro_tecnico;

CREATE TABLE usuario(
	id	INT AUTO_INCREMENT	PRIMARY KEY	NOT NULL,
    nombre	VARCHAR(50)	NOT NULL,
    email	VARCHAR(120)	UNIQUE NOT NULL
);

CREATE TABLE ocasional(
	id INT AUTO_INCREMENT	PRIMARY KEY	NOT NULL,
    numero_accesos	SMALLINT NOT NULL,
    CONSTRAINT fk_ocasional_usuario FOREIGN KEY (id) REFERENCES usuario(id),
    CONSTRAINT chck_numero_accesos CHECK (numero_accesos >= 0),
	CONSTRAINT chck_id CHECK (id >= 1)
);

CREATE TABLE experto(
	id INT AUTO_INCREMENT	PRIMARY KEY	NOT NULL,
    pagina	SMALLINT	NOT NULL,
    CONSTRAINT fk_experto_usuario FOREIGN KEY (id) REFERENCES usuario(id),
    CONSTRAINT chck_pagina CHECK (pagina >= 0),
    CONSTRAINT chck_id CHECK (id >= 1)

);

CREATE TABLE lenguaje(
	nombre	VARCHAR(80)	PRIMARY KEY	NOT NULL,
    descripcion VARCHAR(200)	NOT NULL,
    paradigma	VARCHAR(60)	NOT NULL
);