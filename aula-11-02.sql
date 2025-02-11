-- Forma 1 : toda tabela tem que ter no minimo uma chave primaria
-- Forma 2: todos os atributos tem que ser dependentes da chave primaria
-- Forma 3: não pode atributos compostos ou transitorios (tirar todos os dados que repetem dos atributos e transformar em outra tabela) 


----------------------------------------------------------------------------------------


-- DDL (Data Definition Label)
-- Exemplo:
--CREATE TABLE END_CLIENTE(
--Logradouro,
--Numero,
--Cep,
--Estado, -- REPETE
--Cidade, -- REPETE
--Bairro, -- REPETE
--complemento, 
--pais, -- REPETE
--id_cliente
--);

-- Porem os dados se repetem (PAIS, ESTADO, CIDADE, BAIRRO) 
CREATE TABLE END_CLIENTE(
id_endereco NUMBER PRIMARY KEY,
cep NUMBER,
logradouro VARCHAR2(50),
numero NUMBER,
complemento VARCHAR2(50),
id_bairro NUMBER
);
ALTER TABLE END_CLIENTE
    ADD CONSTRAINT fk_END_CLIENTE FOREIGN KEY (id_bairro)
    REFERENCES BAIRRO (id_bairro);
    
    
CREATE TABLE PAIS(
id_pais INTEGER PRIMARY KEY,
nome_pais VARCHAR2(30)
);



CREATE TABLE CIDADE(
id_cidade NUMBER PRIMARY KEY,
nome_cidade VARCHAR(100),
id_estado NUMBER
);
ALTER TABLE CIDADE
    ADD CONSTRAINT fk_ESTADO FOREIGN KEY (id_estado)
    REFERENCES ESTADO (id_estado);
    
    
    
CREATE TABLE ESTADO(
id_estado INTEGER PRIMARY KEY,
nome_estado VARCHAR2,
id_pais NUMBER 
);
ALTER TABLE ESTADO
    ADD CONSTRAINT fk_ESTADO FOREIGN KEY (id_pais)
    REFERENCES PAIS (id_pais);


CREATE TABLE BAIRRO(
id_bairro NUMBER PRIMARY KEY,
nome_bairro VARCHAR(30),
id_cidade
);

ALTER TABLE BAIRRO
    ADD CONSTRAINT fk_CIDADE FOREIGN KEY (id_cidade)
    REFERENCES CIDADE (id_cidade);
    






