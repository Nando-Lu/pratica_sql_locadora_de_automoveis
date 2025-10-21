USE locadora_automoveis;
-- Consultas de nível básico
/* 1. Liste o nome e telefone de todos os clientes cadastrados.*/
SELECT nome, telefone
FROM cliente;

/* 2. Mostre o modelo, marca e ano de fabricação de todos os automóveis.*/
SELECT modelo, marca, ano_fabricacao AS `ano de fabricação`
FROM automovel;

/* 3. Exiba todas as reservas realizadas em 2025.*/
SELECT *
FROM reserva 
WHERE datainicio >= '2025-01-01' AND datainicio <= '2025-12-31';  

/* 4. Mostre o CPF dos clientes que possuem multa maior que 300 reais.*/
SELECT c.cpf, r.multa
FROM cliente c
INNER JOIN reserva r ON c.cpf = r.cliente_cpf
WHERE r.multa > 300;

/* 5. Liste os automóveis da marca “Fiat” ou “Toyota”.*/
SELECT *
FROM automovel
WHERE marca = 'Fiat' OR marca = 'Toyota';