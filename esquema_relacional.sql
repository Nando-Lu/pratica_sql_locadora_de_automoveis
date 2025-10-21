CREATE DATABASE locadora_automoveis;
USE locadora_automoveis;
CREATE TABLE cliente(
	cpf CHAR(11) PRIMARY KEY,
    nome VARCHAR(100),
    municipio VARCHAR(80),
    telefone VARCHAR(15)
);

CREATE TABLE automovel (
	chassi VARCHAR(30) PRIMARY KEY,
    placa VARCHAR(15),
    modelo VARCHAR(80),
    marca VARCHAR(50),
    ano_fabricacao INT,
    ano_modelo INT
);

CREATE TABLE reserva (
	rid INT PRIMARY KEY AUTO_INCREMENT,
    cliente_cpf CHAR(11) NOT NULL,
    datainicio DATE,
    datatermino DATE,
    multa DECIMAL(10,2),
    FOREIGN KEY (cliente_cpf) REFERENCES cliente(cpf) ON DELETE CASCADE ON UPDATE CASCADE
);

CREATE TABLE reserva_automovel (
	reserva_rid INT NOT NULL,
    automovel_chassi VARCHAR(30) NOT NULL,
    PRIMARY KEY(reserva_rid, automovel_chassi),
    FOREIGN KEY (reserva_rid) REFERENCES reserva (rid)
		ON DELETE CASCADE ON UPDATE CASCADE,
    FOREIGN KEY (automovel_chassi) REFERENCES automovel(chassi)
		ON DELETE CASCADE ON UPDATE CASCADE
);