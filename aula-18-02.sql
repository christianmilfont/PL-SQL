-- Forma 1: Toda tabela deve ter, no mínimo, uma chave primária para garantir a unicidade dos registros e integridade dos dados.
-- Forma 2: Todos os atributos (colunas) devem ser dependentes da chave primária, ou seja, não pode haver dependências parciais ou transitivas.
-- Forma 3: Não pode haver atributos compostos ou transitórios. Ou seja, os dados repetidos devem ser removidos e transformados em outra tabela, criando relacionamentos entre elas.

----------------------------------------------------------------------------------------

-- DDL (Data Definition Language): Definição da estrutura das tabelas
-- Exemplo de criação de uma tabela de cliente, mas com dados repetidos como PAIS, ESTADO, CIDADE, BAIRRO.
-- Em vez de repetir esses dados, devemos normalizá-los criando tabelas separadas para cada um.

-- Criando a tabela PAIS
CREATE TABLE PAIS (
    id_pais INTEGER PRIMARY KEY,   -- Chave primária para identificar o país
    nome_pais VARCHAR2(30)         -- Nome do país
);

-- Criando a tabela ESTADO
CREATE TABLE ESTADO (
    id_estado INTEGER PRIMARY KEY, -- Chave primária para identificar o estado
    nome_estado VARCHAR2(50),      -- Nome do estado
    id_pais NUMBER                 -- Chave estrangeira referenciando a tabela PAIS
);
-- Definindo a chave estrangeira entre ESTADO e PAIS
ALTER TABLE ESTADO
    ADD CONSTRAINT fk_PAIS FOREIGN KEY (id_pais)
    REFERENCES PAIS (id_pais);

-- Criando a tabela CIDADE
CREATE TABLE CIDADE (
    id_cidade NUMBER PRIMARY KEY,  -- Chave primária para identificar a cidade
    nome_cidade VARCHAR(100),      -- Nome da cidade
    id_estado NUMBER               -- Chave estrangeira referenciando a tabela ESTADO
);
-- Definindo a chave estrangeira entre CIDADE e ESTADO
ALTER TABLE CIDADE
    ADD CONSTRAINT fk_ESTADO FOREIGN KEY (id_estado)
    REFERENCES ESTADO (id_estado);

-- Criando a tabela BAIRRO
CREATE TABLE BAIRRO (
    id_bairro NUMBER PRIMARY KEY,  -- Chave primária para identificar o bairro
    nome_bairro VARCHAR(30),       -- Nome do bairro
    id_cidade NUMBER              -- Chave estrangeira referenciando a tabela CIDADE
);
-- Definindo a chave estrangeira entre BAIRRO e CIDADE
ALTER TABLE BAIRRO
    ADD CONSTRAINT fk_CIDADE FOREIGN KEY (id_cidade)
    REFERENCES CIDADE (id_cidade);

-- Criando a tabela END_CLIENTE
CREATE TABLE END_CLIENTE (
    id_endereco NUMBER PRIMARY KEY,   -- Chave primária para identificar o endereço
    cep NUMBER,                       -- CEP do endereço
    logradouro VARCHAR2(50),          -- Logradouro (rua, avenida, etc.)
    numero NUMBER,                    -- Número do endereço
    complemento VARCHAR2(50),         -- Complemento (apartamento, bloco, etc.)
    id_bairro NUMBER                  -- Chave estrangeira referenciando a tabela BAIRRO
);
-- Definindo a chave estrangeira entre END_CLIENTE e BAIRRO
ALTER TABLE END_CLIENTE
    ADD CONSTRAINT fk_END_CLIENTE FOREIGN KEY (id_bairro)
    REFERENCES BAIRRO (id_bairro);

-- Caso precise dropar as tabelas (importante seguir a ordem inversa da criação para evitar erros de dependência)
DROP TABLE END_CLIENTE;
DROP TABLE BAIRRO;
DROP TABLE CIDADE;
DROP TABLE ESTADO;
DROP TABLE PAIS;

----------------------------------------------------------------------------------------

-- INSERTS: Inserindo dados nas tabelas

-- Inserindo dados na tabela PAIS
INSERT INTO PAIS (id_pais, nome_pais) 
VALUES (1, 'Brasil');

INSERT INTO PAIS (id_pais, nome_pais) 
VALUES (2, 'Argentina');

INSERT INTO PAIS (id_pais, nome_pais) 
VALUES (3, 'Rússia');

-- Inserindo dados na tabela ESTADO
INSERT INTO ESTADO (id_estado, nome_estado, id_pais) 
VALUES (1, 'São Paulo', 1); -- Relacionando o estado de São Paulo com o país Brasil (id_pais = 1)

INSERT INTO ESTADO (id_estado, nome_estado, id_pais) 
VALUES (2, 'Buenos Aires', 2); -- Relacionando o estado Buenos Aires com o país Argentina (id_pais = 2)

-- Inserindo dados na tabela CIDADE
INSERT INTO CIDADE (id_cidade, nome_cidade, id_estado) 
VALUES (1, 'São Paulo', 1); -- Relacionando a cidade São Paulo com o estado de São Paulo (id_estado = 1)

INSERT INTO CIDADE (id_cidade, nome_cidade, id_estado) 
VALUES (2, 'La Plata', 2); -- Relacionando a cidade La Plata com o estado Buenos Aires (id_estado = 2)

-- Inserindo dados na tabela BAIRRO
INSERT INTO BAIRRO (id_bairro, nome_bairro, id_cidade) 
VALUES (1, 'Centro', 1); -- Relacionando o bairro Centro com a cidade São Paulo (id_cidade = 1)

INSERT INTO BAIRRO (id_bairro, nome_bairro, id_cidade) 
VALUES (2, 'Villa Elisa', 2); -- Relacionando o bairro Villa Elisa com a cidade La Plata (id_cidade = 2)

-- Inserindo dados na tabela END_CLIENTE
INSERT INTO END_CLIENTE (id_endereco, cep, logradouro, numero, complemento, id_bairro) 
VALUES (1, 12345678, 'Rua das Flores', 100, 'Apt 101', 1); -- Relacionando o endereço com o bairro Centro (id_bairro = 1)

INSERT INTO END_CLIENTE (id_endereco, cep, logradouro, numero, complemento, id_bairro) 
VALUES (2, 23456789, 'Avenida Brasil', 200, 'Bloco B', 2); -- Relacionando o endereço com o bairro Villa Elisa (id_bairro = 2)

----------------------------------------------------------------------------------------

-- JOINS: Consultas com junção de tabelas

-- INNER JOIN: Retorna apenas os itens das tabelas que possuem correspondência
SELECT 
    A.NOME_PAIS AS PAIS,
    COUNT(B.NOME_ESTADO) AS "QDE ESTADOS"
FROM 
    PAIS A 
    INNER JOIN ESTADO B ON (A.id_pais = B.id_pais) -- Junção entre PAIS e ESTADO
GROUP BY
    A.NOME_PAIS;

-- LEFT JOIN: Retorna todos os itens da tabela da esquerda (PAIS), e os itens correspondentes da tabela da direita (ESTADO)
SELECT 
    A.NOME_PAIS AS PAIS,
    COUNT(B.NOME_ESTADO) AS "QDE ESTADOS"
FROM 
    PAIS A 
    LEFT JOIN ESTADO B ON (A.id_pais = B.id_pais) -- Junção entre PAIS e ESTADO
GROUP BY
    A.NOME_PAIS;

-- Consulta sem JOIN, usando o operador (+) para simular LEFT JOIN
SELECT 
    A.NOM_PAIS AS PAIS,
    COUNT(B.NOM_ESTADO) AS "QDE ESTADOS"
FROM
    pf1788.pais A,
    pf1788.estado B
WHERE
    A.COD_PAIS = B.COD_PAIS(+) -- Simula LEFT JOIN
GROUP BY
    A.NOM_PAIS;

-- Ordenando resultados: ASC (crescente) ou DESC (decrescente)
SELECT 
    A.NOME_PAIS AS PAIS,
    COUNT(B.NOME_ESTADO) AS "QDE ESTADOS"
FROM 
    PAIS A 
    LEFT JOIN ESTADO B ON (A.id_pais = B.id_pais)
GROUP BY
    A.NOME_PAIS
ORDER BY 2 DESC; -- Ordena pelo número de estados, de forma decrescente

-- Usando HAVING: Filtra os resultados após o agrupamento, semelhante ao WHERE, mas após a agregação
SELECT 
    A.NOME_PAIS AS PAIS,
    COUNT(B.NOME_ESTADO) AS "QDE ESTADOS"
FROM 
    PAIS A 
    LEFT JOIN ESTADO B ON (A.id_pais = B.id_pais)
GROUP BY
    A.NOME_PAIS
HAVING COUNT(B.NOME_ESTADO) BETWEEN 1 AND 5 -- Retorna países com entre 1 e 5 estados
ORDER BY 2 DESC;

-- Usando HAVING para filtrar estados maiores que 5
SELECT 
    A.NOME_PAIS AS PAIS,
    COUNT(B.NOME_ESTADO) AS "QDE ESTADOS"
FROM 
    PAIS A 
    LEFT JOIN ESTADO B ON (A.id_pais = B.id_pais)
GROUP BY
    A.NOME_PAIS
HAVING COUNT(B.NOME_ESTADO) > 5 -- Retorna países com mais de 5 estados
ORDER BY 2 DESC;


-- Seleciona informações de países, estados e cidades, e conta o número de cidades por estado
SELECT 
    a.nom_pais AS pais,  -- Seleciona o nome do país da tabela 'pais' e dá o alias 'pais' para exibição
    b.nom_estado AS estado,  -- Seleciona o nome do estado da tabela 'estado' e dá o alias 'estado' para exibição
    COUNT(c.nom_cidade) AS "qdt cidades"  -- Conta o número de cidades na tabela 'cidade' para cada estado, e dá o alias 'qdt cidades'
FROM
    pf1788.pais a  -- A tabela 'pais' está sendo referenciada com o alias 'a'
    JOIN pf1788.estado b ON (a.cod_pais = b.cod_pais)  -- Faz uma junção interna (INNER JOIN) entre a tabela 'pais' e 'estado', com base no código do país
    LEFT JOIN pf1788.cidade c ON (b.cod_estado = c.cod_estado)  -- Faz uma junção à esquerda (LEFT JOIN) entre a tabela 'estado' e 'cidade', com base no código do estado. Isso garante que, mesmo que não haja cidades associadas ao estado, ele será retornado na consulta.
GROUP BY 
    a.nom_pais,  -- Agrupa os resultados por nome do país
    b.nom_estado  -- Agrupa os resultados por nome do estado
ORDER BY 
    3 DESC,  -- Ordena o resultado pelo número de cidades (3ª coluna), de forma decrescente
    1,  -- Ordena em ordem crescente pelo nome do país (1ª coluna)
    2;  -- Ordena em ordem crescente pelo nome do estado (2ª coluna)



----------------------------------------------------------------------------------------

-- Entrando em PL/SQL PROCEDURE LANGUAGE 
-- O código abaixo é um exemplo simples utilizando a linguagem PL/SQL para declarar variáveis, atribuir valores e imprimir uma saída.

-- Ativando a saída no servidor para mostrar os resultados
SET SERVEROUTPUT ON;  -- Permite que a saída gerada pelo comando dbms_output.put_line seja exibida no console ou ambiente de execução.

DECLARE
    -- Declaração de variáveis que serão utilizadas no bloco PL/SQL.
    idade NUMBER;  -- Cria uma variável chamada 'idade' do tipo NUMBER. Essa variável será usada para armazenar a idade do usuário.
BEGIN
    -- Bloco BEGIN define onde a lógica PL/SQL começa.

    idade := 39;  -- Atribui o valor 39 à variável 'idade'.

    -- A função dbms_output.put_line é usada para imprimir a saída. Ela concatenará a string 'A IDADE INFORMADA É: ' com o valor da variável 'idade'.
    dbms_output.put_line(' A IDADE INFORMADA É: ' || idade);

    -- O operador '||' é utilizado para concatenar as strings em PL/SQL.
END;
-- Bloco END indica o fim do código PL/SQL.



---------------------------------------
SET SERVEROUTPUT ON;

DECLARE 
    idade NUMBER;
    nome VARCHAR2(30) := 'VERGS';
BEGIN
    idade := 39;
    dbms_output.put_line(' A IDADE INFORMADA É: ' || idade);
    dbms_output.put_line(' O NOME INFORMADA É: ' || nome);
END;
---------------------------------------
SET SERVEROUTPUT ON;
DECLARE
    IDADE NUMBER;
    NOME VARCHAR2(30) :='vergs';
    ENDEREÇO VARCHAR2(50) :='&ENDEREÇO';
BEGIN
    idade :=39;
    dbms_output.put_line('A IDADE INFORMADA É :'|| idade);
    dbms_output.put_line('o nome informado é :'|| nome);
    dbms_output.put_line('o endereço informado é :'|| ENDEREÇO);
END;



-- EXERCICIO
SET SERVEROUTPUT ON;
DECLARE
    salario_minimo NUMBER;
    salario_novo NUMBER;
BEGIN
    salario_minimo := 1500;
    salario_novo := salario_minimo * 1.25;
    dbms_output.put_line('A IDADE INFORMADA É :'|| salario_minimo);
    dbms_output.put_line('O NOVO SALARIO É DE :' || salario_novo);
END;

-- EXERCICIO
SET SERVEROUTPUT ON;
DECLARE
    valor_real NUMBER;
    valor_dolar NUMBER;
BEGIN
    valor_dolar := 10;
    valor_real := valor_dolar / 5;
    dbms_output.put_line('O VALOR DO DOLAR EM REAL SERIA :'|| valor_real);
END;

-- EXERCICIO
SET SERVEROUTPUT ON;
DECLARE
    valor_inicial_carro NUMBER :=&valor;
    parcelas FLOAT;
    parcelas_juros FLOAT;
    valor_final FLOAT;
BEGIN
    --valor_inicial_carro := 569000;
    parcelas_juros := 1.03;
    parcelas := valor_inicial_carro / 10;
    valor_final := parcelas * parcelas_juros;
    dbms_output.put_line('O VALOR DAS PARCELAS SERIAM :'|| parcelas);
    dbms_output.put_line('O VALOR TOTAL DAS PARCELAS COM O JUROS SERIAM :'|| valor_final);

END;
    