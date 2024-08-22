CREATE DATABASE IF NOT EXISTS ecomerce;
USE ecomerce;

-- Criação das tabelas
CREATE TABLE Cliente (
    cliente_id INT AUTO_INCREMENT PRIMARY KEY,
    nome VARCHAR(100) NOT NULL,
    email VARCHAR(100) UNIQUE NOT NULL,
    telefone VARCHAR(15),
    tipo ENUM('PF', 'PJ') NOT NULL
);

CREATE TABLE Pessoa_Fisica (
    cliente_id INT PRIMARY KEY,
    cpf VARCHAR(14) UNIQUE NOT NULL,
    FOREIGN KEY (cliente_id) REFERENCES Cliente(cliente_id) ON DELETE CASCADE
);

CREATE TABLE Pessoa_Juridica (
    cliente_id INT PRIMARY KEY,
    cnpj VARCHAR(18) UNIQUE NOT NULL,
    FOREIGN KEY (cliente_id) REFERENCES Cliente(cliente_id) ON DELETE CASCADE
);

CREATE TABLE Produto (
    produto_id INT AUTO_INCREMENT PRIMARY KEY,
    nome VARCHAR(100) NOT NULL,
    descricao TEXT,
    preco DECIMAL(10, 2) NOT NULL
);

CREATE TABLE Fornecedor (
    fornecedor_id INT AUTO_INCREMENT PRIMARY KEY,
    nome VARCHAR(100) NOT NULL,
    contato VARCHAR(100)
);

CREATE TABLE Estoque (
    estoque_id INT AUTO_INCREMENT PRIMARY KEY,
    produto_id INT NOT NULL,
    quantidade INT NOT NULL,
    FOREIGN KEY (produto_id) REFERENCES Produto(produto_id) ON DELETE CASCADE
);

CREATE TABLE Pedido (
    pedido_id INT AUTO_INCREMENT PRIMARY KEY,
    cliente_id INT NOT NULL,
    data_pedido DATE NOT NULL,
    status VARCHAR(50),
    FOREIGN KEY (cliente_id) REFERENCES Cliente(cliente_id) ON DELETE CASCADE
);

CREATE TABLE Pedido_Produto (
    pedido_id INT NOT NULL,
    produto_id INT NOT NULL,
    quantidade INT NOT NULL,
    preco_unitario DECIMAL(10, 2) NOT NULL,
    PRIMARY KEY (pedido_id, produto_id),
    FOREIGN KEY (pedido_id) REFERENCES Pedido(pedido_id) ON DELETE CASCADE,
    FOREIGN KEY (produto_id) REFERENCES Produto(produto_id) ON DELETE CASCADE
);

CREATE TABLE Pagamento (
    pagamento_id INT AUTO_INCREMENT PRIMARY KEY,
    pedido_id INT NOT NULL,
    forma_pagamento VARCHAR(50),
    FOREIGN KEY (pedido_id) REFERENCES Pedido(pedido_id) ON DELETE CASCADE
);

CREATE TABLE Entrega (
    entrega_id INT AUTO_INCREMENT PRIMARY KEY,
    pedido_id INT NOT NULL,
    status VARCHAR(50),
    codigo_rastreio VARCHAR(50),
    FOREIGN KEY (pedido_id) REFERENCES Pedido(pedido_id) ON DELETE CASCADE
);

CREATE TABLE Fornecedor_Produto (
    fornecedor_id INT NOT NULL,
    produto_id INT NOT NULL,
    PRIMARY KEY (fornecedor_id, produto_id),
    FOREIGN KEY (fornecedor_id) REFERENCES Fornecedor(fornecedor_id) ON DELETE CASCADE,
    FOREIGN KEY (produto_id) REFERENCES Produto(produto_id) ON DELETE CASCADE
);

-- Criação da tabela de histórico para clientes excluídos
CREATE TABLE Cliente_Historico (
    cliente_id INT,
    nome VARCHAR(100),
    email VARCHAR(100),
    telefone VARCHAR(15),
    tipo ENUM('PF', 'PJ'),
    data_exclusao TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Criação da tabela de histórico para alterações de salário
-- Supondo que há uma tabela Funcionario para o exemplo
CREATE TABLE Funcionario (
    funcionario_id INT AUTO_INCREMENT PRIMARY KEY,
    nome VARCHAR(100) NOT NULL,
    salario DECIMAL(10, 2)
);

CREATE TABLE Salario_Historico (
    funcionario_id INT,
    salario DECIMAL(10, 2),
    data_atualizacao TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (funcionario_id) REFERENCES Funcionario(funcionario_id)
);

-- Criação da tabela para novos colaboradores
CREATE TABLE Novo_Colaborador (
    funcionario_id INT,
    data_admissao TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (funcionario_id) REFERENCES Funcionario(funcionario_id)
);


CREATE OR REPLACE VIEW ProjetoDepartament AS
SELECT 
    p.Pname AS Projeto,
    d.Dname AS Departamento,
    e.Fname AS GerenteNome,
    e.Lname AS GerenteSobrenome
FROM 
    project p
JOIN 
    department d ON p.Dnum = d.Dnumber
LEFT JOIN 
    employee e ON d.Mgr_ssn = e.Ssn;

-- View para empregados com dependentes e se são gerentes
CREATE OR REPLACE VIEW EmpregadosEGerentes AS
SELECT 
    e.Fname AS NomeEmpregado,
    e.Lname AS SobrenomeEmpregado,
    d.Dependent_name AS NomeDependente,
    CASE 
        WHEN e.Ssn IN (SELECT Mgr_ssn FROM department) THEN 'Sim'
        ELSE 'Não'
    END AS EGerente
FROM 
    employee e
LEFT JOIN 
    dependent d ON e.Ssn = d.Essn;
    