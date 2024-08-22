
-- Use o banco de dados correto
USE ecomerce;

-- Criar a procedure para manipulação de dados
DELIMITER //

CREATE PROCEDURE ManipularDados(
    IN p_acao INT, -- 1 para inserir, 2 para atualizar, 3 para excluir
    IN p_cliente_id INT,
    IN p_nome VARCHAR(100),
    IN p_email VARCHAR(100),
    IN p_telefone VARCHAR(15),
    IN p_tipo ENUM('PF', 'PJ'),
    IN p_produto_id INT,
    IN p_nome_produto VARCHAR(100),
    IN p_descricao TEXT,
    IN p_preco DECIMAL(10, 2)
)
BEGIN
    IF p_acao = 1 THEN
        -- Inserir dados
        IF p_cliente_id IS NOT NULL THEN
            -- Inserir um novo cliente
            INSERT INTO Cliente (nome, email, telefone, tipo) 
            VALUES (p_nome, p_email, p_telefone, p_tipo);
        END IF;
        
        IF p_produto_id IS NOT NULL THEN
            -- Inserir um novo produto
            INSERT INTO Produto (nome, descricao, preco) 
            VALUES (p_nome_produto, p_descricao, p_preco);
        END IF;
    
    ELSEIF p_acao = 2 THEN
        -- Atualizar dados
        IF p_cliente_id IS NOT NULL THEN
            -- Atualizar um cliente existente
            UPDATE Cliente 
            SET nome = p_nome, email = p_email, telefone = p_telefone, tipo = p_tipo
            WHERE cliente_id = p_cliente_id;
        END IF;
        
        IF p_produto_id IS NOT NULL THEN
            -- Atualizar um produto existente
            UPDATE Produto 
            SET nome = p_nome_produto, descricao = p_descricao, preco = p_preco
            WHERE produto_id = p_produto_id;
        END IF;
    
    ELSEIF p_acao = 3 THEN
        -- Excluir dados
        IF p_cliente_id IS NOT NULL THEN
            -- Excluir um cliente existente
            DELETE FROM Cliente 
            WHERE cliente_id = p_cliente_id;
        END IF;
        
        IF p_produto_id IS NOT NULL THEN
            -- Excluir um produto existente
            DELETE FROM Produto 
            WHERE produto_id = p_produto_id;
        END IF;
    END IF;
END //

DELIMITER ;
