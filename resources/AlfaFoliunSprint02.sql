CREATE DATABASE AlfaFolium;

USE AlfaFolium;

CREATE TABLE endereco (
	idEndereco INT PRIMARY KEY AUTO_INCREMENT,
    CEP CHAR(9),
    numEnd VARCHAR(10)
);


CREATE TABLE empresa (
	idEmpresa INT PRIMARY KEY AUTO_INCREMENT,
    nome VARCHAR (45),
    CNPJ CHAR (18),
    fkEndereco INT,
		CONSTRAINT fkEnderecoEmpresa FOREIGN KEY (fkEndereco)
			REFERENCES endereco(idEndereco)
);

-- Empresa padrão para que os donos do projeto possam acessar:
INSERT INTO empresa (nome, CNPJ) VALUES
	('Alfa Folium', '21.886.895/0001-83');

        
CREATE TABLE tipoUsuario (
	idTipoUsuario INT PRIMARY KEY AUTO_INCREMENT,
	tipo VARCHAR(45),
    descricao VARCHAR(200),
    CONSTRAINT chkTipoUsuario CHECK (tipo IN ('Master', 'Dono', 'Funcionario'))
);


-- Insert das funções pré-definidas:
INSERT INTO tipoUsuario (tipo,descricao) VALUES 
	('Master', 'Usuários pertencententes a equipe de desenvolvimento e produção'),
    ('Dono', 'Usuário/Cliente responsável pelo controle total da plataforma através da aplicação desenvolvida'),
    ('Funcionario', 'Usuário responsável pelo controle parcial da plataforma para análises e tomada de decisoes');
    

CREATE TABLE usuario (
	idUsuario INT PRIMARY KEY AUTO_INCREMENT,
    nome VARCHAR (45),
    CPF CHAR (14),
    email VARCHAR (45),
    senha VARCHAR(200),
    telFixo CHAR (13),
    telCelular CHAR (14),
    dataCriacao DATE,
    fkEmpresa INT,
    fkTipoUsuario INT,
    CONSTRAINT fkUsuarioTipoUsuario FOREIGN KEY (fkTipoUsuario)
		REFERENCES tipoUsuario(idTipoUsuario),
	CONSTRAINT fkUsuarioEmpresa FOREIGN KEY (fkEmpresa)
		REFERENCES empresa(idEmpresa)
);


    
CREATE TABLE parametro (
	idParametro INT PRIMARY KEY AUTO_INCREMENT,
    umidadeMin DECIMAL (4, 2),
    umidadeMax DECIMAL (4, 2),
    temperaturaMin DECIMAL (4, 2),
    temperaturaMax DECIMAL (4, 2)
); 	

insert into parametro values
	(default, 65.00, 80.00, 15.00, 28.00);

CREATE TABLE estufa (
	idEstufa INT PRIMARY KEY AUTO_INCREMENT,
	tamanho INT,
	status VARCHAR (25),
    condicao VARCHAR(25),
    fkEmpresa INT, 
	fkParametro INT,
		CONSTRAINT chkCondicao CHECK (condicao IN ('Estavel', 'Atencao', 'Alerta')),
		CONSTRAINT chkStatus CHECK (status IN ('Ativa', 'Inativa')),
		CONSTRAINT fkEstufaEmpresa FOREIGN KEY (fkEmpresa)
			REFERENCES empresa (idEmpresa),
		CONSTRAINT fkParametroEstufa FOREIGN KEY (fkParametro)
			REFERENCES parametro (idParametro)
);

select dados.*,
	condicao as condicao,
    umidadeMin,
    umidadeMax,
    temperaturaMin,
    temperaturaMax from dados join sensor
    on dados.fkSensor = sensor.idSensor join estufa
    on sensor.fkEstufa = estufa.idEstufa join parametro
    on estufa.fkParametro = parametro.idParametro
    order by idDados desc
    limit 1;
    
select * from estufa;

SELECT COUNT(idEstufa) AS totalEstufasCadastradas from estufa;

insert into estufa values
	(default, 5, 'Ativa', 'Estavel', 1, 1);

CREATE TABLE sensor (
	idSensor INT,
    nome VARCHAR (45),
    fkEstufa INT,
	PRIMARY KEY (idSensor, fkEstufa),
	FOREIGN KEY (fkEstufa) REFERENCES estufa (idEstufa)
);

insert into sensor values
	(1, 'DHT_11', 2);
            
CREATE TABLE dados (
	idDados INT AUTO_INCREMENT,
    temperatura DECIMAL (4, 2),
    umidade DECIMAL (4, 2),
    horario DATETIME,
    fkSensor INT,
		PRIMARY KEY (idDados, fkSensor),
	FOREIGN KEY (fkSensor) REFERENCES sensor (idSensor)
);

insert into dados values
	(default, 15.04, 83.05, now(), 1);

SELECT * FROM usuario;
SELECT * FROM endereco;
SELECT * FROM empresa;
SELECT * FROM tipoUsuario;
SELECT * FROM parametro;
SELECT * FROM estufa;
SELECT * FROM sensor;
SELECT * FROM dados;
            
SHOW TABLES;