DROP DATABASE IF EXISTS filarmonica;

CREATE DATABASE sociedades_filarmonicas CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci;

USE filarmonisca;

CREATE TABLE musico(
	dni CHAR(9) PRIMARY KEY NOT NULL,
    nombre	VARCHAR(80)	NOT NULL
)ENGINE=InnoDB;

CREATE TABLE sociedad(
	nif	CHAR(9)	PRIMARY KEY	NOT NULL,
    domicilio	VARCHAR(120)	NOT NULL,
    presupuesto	DECIMAL(12,2)	NOT NULL, -- 100.000,00
    CONSTRAINT chck_presupuesto	CHECK(presupuesto >= 0)
)ENGINE=InnoDB;




-- 2. Tablas con claves ajenas

CREATE TABLE idiomas(
	dni	CHAR(9) NOT NULL,
    idioma	VARCHAR(30)	NOT NULL,
    CONSTRAINT pk_idiomas	PRIMARY KEY(dni, idioma),
    CONSTRAINT fk_idiomas_musico FOREIGN KEY (dni) REFERENCES musico(dni) 
		ON DELETE CASCADE ON UPDATE CASCADE 
        -- Mantener el idioma una vez borrado musico es inutil
        -- Conviene actualizar en cascada porque depende de musico
)ENGINE=InnoDB;

CREATE TABLE metal(
	dni	CHAR(9)	PRIMARY KEY NOT NULL,
    tipo	VARCHAR(30)	NOT NULL,
    CONSTRAINT fk_metal_musico FOREIGN KEY (dni) REFERENCES musico(dni) 
		ON DELETE CASCADE ON UPDATE CASCADE

)ENGINE=InnoDB;

CREATE TABLE madera(
	dni	CHAR(9)	PRIMARY KEY	NOT NULL,
    registro	VARCHAR(20),
    CONSTRAINT fk_madera_musico FOREIGN KEY (dni) REFERENCES musico(dni)
		ON DELETE CASCADE	ON UPDATE CASCADE
)ENGINE=InnoDB;

CREATE TABLE percusion(
	dni	CHAR(9)	PRIMARY KEY	NOT NULL,
    propietario BOOLEAN NOT NULL,
    CONSTRAINT fk_percusion_musico FOREIGN KEY (dni) REFERENCES musico(dni)
		ON DELETE CASCADE ON UPDATE CASCADE,
	CONSTRAINT chck_propietario CHECK (propietario IN (0,1))
)ENGINE=InnoDB;


-- 3. Relaciones con sociedad

CREATE TABLE contrato(
	dni	CHAR(9)	NOT NULL,
    nif	CHAR(9)	NOT NULL,
    fecha	DATE	NOT NULL,
    CONSTRAINT pk_contrato	PRIMARY KEY (dni, nif, fecha),
    CONSTRAINT fk_contrato_musico	FOREIGN KEY (dni) REFERENCES musico(dni)	
		ON DELETE RESTRICT	ON UPDATE CASCADE,
    CONSTRAINT fk_contrato_sociedad	FOREIGN KEY (nif) REFERENCES sociedad(nif)	
		ON DELETE RESTRICT ON UPDATE CASCADE
)ENGINE=InnoDB;


CREATE TABLE disco (
	issn	CHAR(9)	PRIMARY KEY	NOT NULL,
    titulo	VARCHAR(120)	NOT NULL,
	duracioni_total	TIME NOT NULL,
    nif_sociedad	CHAR(9)	NOT NULL,
    CONSTRAINT fk_disco_sociedad FOREIGN KEY (nif_sociedad) REFERENCES sociedad(nif) 
		ON UPDATE CASCADE
)ENGINE=InnoDB;

CREATE TABLE pista(
	issn	CHAR(9)	NOT NULL,
    orden	TINYINT	UNSIGNED	AUTO_INCREMENT NOT NULL,
    duracion	TIME	NOT NULL,
    CONSTRAINT pk_pista PRIMARY KEY (issn, orden),
    CONSTRAINT chck_orden CHECK (orden >= 1),
    CONSTRAINT fk_pista_disco FOREIGN KEY (issn) REFERENCES disco(issn)	
		ON DELETE CASCADE ON UPDATE CASCADE
	
)ENGINE=InnoDB;