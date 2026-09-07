CREATE DATABASE POKEMON;
CREATE USER 'pokemon'@'%' IDENTIFIED BY 'pk1234';
GRANT ALL PRIVILEGES ON POKEMON.* TO 'pokemon'@'%';
FLUSH PRIVILEGES;
USE POKEMON;

CREATE TABLE pokemon (
    id   INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(10) NOT NULL UNIQUE,

    hp  INT NOT NULL,
    atk INT NOT NULL,
    def INT NOT NULL,
    spa INT NOT NULL,
    spd INT NOT NULL,
    spe INT NOT NULL
);

CREATE TABLE type (
    id   INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(5) NOT NULL UNIQUE
);

CREATE TABLE pokemon_type (
    pokemon_id INT NOT NULL,
    type_id    INT NOT NULL,
    type_order INT NOT NULL,

    PRIMARY KEY (pokemon_id, type_id),
    FOREIGN KEY (pokemon_id) REFERENCES pokemon(id),
    FOREIGN KEY (type_id)    REFERENCES type(id)
);

CREATE TABLE skill (
    id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(10) NOT NULL UNIQUE,

    type_id  INT NOT NULL,
    power    INT,
    accuracy INT,
    pp       INT NOT NULL,

    FOREIGN KEY (type_id) REFERENCES type(id)
);

CREATE TABLE pokemon_skill (
    pokemon_id  INT NOT NULL,
    skill_id    INT NOT NULL,

    PRIMARY KEY (pokemon_id, skill_id),
    FOREIGN KEY (pokemon_id) REFERENCES pokemon(id),
    FOREIGN KEY (skill_id)   REFERENCES skill(id)
);