USE locadora_automoveis;
-- Consultas de nível intemediário
/* Mostre o nome dos clientes que já realizaram pelo menos uma reserva. */
SELECT c.nome
FROM cliente c
JOIN reserva r ON c.cpf = r.cliente_cpf;

/* Mostre o nome dos clientes que nunca realizaram uma reserva */
SELECT nome
FROM cliente 
WHERE cpf NOT IN (
	SELECT r.cliente_cpf
    FROM reserva r);
    
/*Liste os modelos de automóveis que foram reservados mais de uma vez.*/
SELECT a.modelo
FROM automovel a
JOIN reserva_automovel ra ON a.chassi = ra.automovel_chassi
GROUP BY a.modelo
HAVING COUNT(ra.reserva_rid)>1;

/*Exiba o total de reservas realizadas por cada cliente.*/
SELECT c.cpf, c.nome, COUNT(r.rid) AS `Total de reservas`
FROM cliente c 
JOIN reserva r ON c.cpf = r.cliente_cpf
GROUP BY c.cpf, c.nome;

/*Mostre o nome do cliente e o valor médio das multas que ele pagou. 
ROUND - Serve para fixar o número de casas depois da virgula*/
SELECT c.nome, ROUND(AVG(r.multa), 2) AS `Média de valor das multas`
FROM cliente c
INNER JOIN reserva r ON c.cpf = r.cliente_cpf
GROUP BY c.cpf, c.nome;

/*Liste os automóveis que ainda não foram reservados.*/
SELECT a.chassi, a.placa
FROM automovel a
WHERE a.chassi NOT IN (SELECT DISTINCT ra.automovel_chassi
						FROM reserva_automovel ra
						);

/*Mostre o nome e o número de reservas de cada cliente, ordenados do que mais reservou para o que menos.*/
SELECT c.cpf, c.nome, COUNT(r.rid) AS `Número de reservas`
FROM cliente c
JOIN reserva r ON c.cpf = r.cliente_cpf
GROUP BY c.cpf, c.nome
ORDER BY `Número de reservas` DESC;

/*Exiba os clientes que realizaram mais de 3 reservas.*/
SELECT c.cpf, c.nome, COUNT(r.rid)
FROM cliente c
JOIN reserva r ON c.cpf = r.cliente_cpf
GROUP BY c.cpf, c.nome
HAVING COUNT(r.rid)>3;

/*Mostre os automóveis que foram reservados por mais de 5 clientes diferentes. */
SELECT a.chassi, a.placa
FROM automovel a
JOIN reserva_automovel ra ON a.chassi = ra.automovel_chassi
JOIN reserva r ON ra.reserva_rid = r.rid
GROUP BY a.chassi, a.placa
HAVING COUNT(DISTINCT r.cliente_cpf) > 5;

/*2.1 Liste os clientes que nunca receberam multa.*/
SELECT c.cpf, c.nome
FROM cliente c
WHERE c.cpf NOT IN (SELECT r.cliente_cpf
					FROM reserva r
                    WHERE r.multa > 0);

/*2.2 Liste os clientes que nunca receberam multa e já fizeram reservas.*/
SELECT DISTINCT c.cpf, c.nome
FROM cliente c
JOIN reserva r ON c.cpf = r.cliente_cpf
WHERE c.cpf NOT IN (SELECT r2.cliente_cpf
					FROM reserva r2
                    WHERE r2.multa > 0);

/*Exiba o nome do cliente e a soma total de multas que ele já pagou.*/
SELECT c.nome, ROUND(SUM(r.multa), 2) AS `Valor total em multa`
FROM cliente c
JOIN reserva r ON r.cliente_cpf = c.cpf
GROUP BY c.cpf, c.nome;