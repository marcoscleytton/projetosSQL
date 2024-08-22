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

-- Gatilho BEFORE DELETE para Cliente
DELIMITER //

CREATE TRIGGER before_cliente_delete
BEFORE DELETE ON Cliente
FOR EACH ROW
BEGIN
    INSERT INTO Cliente_Historico (cliente_id, nome, email, telefone, tipo)
    VALUES (OLD.cliente_id, OLD.nome, OLD.email, OLD.telefone, OLD.tipo);
END //

DELIMITER ;

-- Gatilho BEFORE UPDATE para atualização de salários na tabela Funcionario
DELIMITER //

CREATE TRIGGER before_salario_update
BEFORE UPDATE ON Funcionario
FOR EACH ROW
BEGIN
    IF OLD.salario <> NEW.salario THEN
        INSERT INTO Salario_Historico (funcionario_id, salario)
        VALUES (OLD.funcionario_id, OLD.salario);
    END IF;
END //

DELIMITER ;

-- Gatilho AFTER INSERT para novos colaboradores
DELIMITER //

CREATE TRIGGER after_colaborador_insert
AFTER INSERT ON Funcionario
FOR EACH ROW
BEGIN
    INSERT INTO Novo_Colaborador (funcionario_id)
    VALUES (NEW.funcionario_id);
END //

DELIMITER ;

-- Inserções de dados
INSERT INTO Cliente (nome, email, telefone, tipo) VALUES 
('Ana Silva', 'ana@exemplo.com', '123456789', 'PF'),
('João Santos', 'joao@exemplo.com', '987654321', 'PJ');

INSERT INTO Pessoa_Fisica (cliente_id, cpf) VALUES 
(1, '123.456.789-00');

INSERT INTO Pessoa_Juridica (cliente_id, cnpj) VALUES 
(2, '12.345.678/0001-90');
