USE locadora_automoveis;
-- Consultas de nível avançado
/*Exiba o nome do cliente que pagou o maior valor de multa*/
SELECT c.nome
FROM cliente c
JOIN reserva r ON c.cpf = r.cliente_cpf
GROUP BY c.cpf, c.nome
HAVING SUM(r.multa) = (SELECT MAX(soma_total)
					   FROM (SELECT SUM(r2.multa) AS soma_total
							FROM reserva r2
                            JOIN cliente c2 ON r2.cliente_cpf = c2.cpf
                            GROUP BY c2.cpf, c2.nome) AS soma
                       );

/*Mostre os automóveis mais reservados no sistema (pode haver empate)*/
SELECT a.chassi, COUNT(ra.reserva_rid)
FROM automovel a
JOIN reserva_automovel ra ON ra.automovel_chassi = a.chassi
GROUP BY a.chassi
HAVING COUNT(ra.reserva_rid) = (SELECT MAX(qtd_rid)
								FROM (SELECT COUNT(ra2.reserva_rid) AS qtd_rid 
									  FROM automovel a2
                                      JOIN reserva_automovel ra2 ON ra2.automovel_chassi = a2.chassi
                                      GROUP BY a2.chassi) as somas_rid
                                );

/*Exiba o cliente que mais fez reservas. */
SELECT c.nome, COUNT(r.rid) AS `qtd_rid`
FROM cliente c
JOIN reserva r ON c.cpf = r.cliente_cpf
GROUP BY c.cpf, c.nome
HAVING COUNT(r.rid) = (SELECT MAX(qtd_rid)
					   FROM (SELECT COUNT(r2.rid) as `qtd_rid`
							 FROM cliente c2
                             JOIN reserva r2 ON c2.cpf = r2.cliente_cpf
                             GROUP BY c2.cpf) as contagem_rid
                       );

/*Liste o(s) cliente(s) que já reservaram todos os automóveis disponíveis. */
/*Primeiro, criando uma situação em que o cliente 1 reservou todos os automoóveis:*/

INSERT INTO reserva (cliente_cpf, datainicio, datatermino, multa)
VALUES ('10000000010', '2025-10-01', '2025-10-10', 0.00);

INSERT INTO reserva_automovel (reserva_rid, automovel_chassi)
SELECT (SELECT MAX(rid) FROM reserva), chassi
FROM automovel;

SELECT c.cpf, c.nome
FROM cliente c
JOIN reserva r ON c.cpf = r.cliente_cpf
JOIN reserva_automovel ra ON r.rid = ra.reserva_rid
JOIN automovel a ON a.chassi = ra.automovel_chassi
GROUP BY c.cpf, c.nome
HAVING COUNT(DISTINCT a.chassi) = (SELECT COUNT(a2.chassi)
								   FROM automovel a2);
                                   
/*Exiba os modelos mais populares (os mais reservados entre todos os clientes)*/
SELECT a.modelo, COUNT(DISTINCT ra.reserva_rid) AS soma_rid
FROM automovel a
JOIN reserva_automovel ra ON a.chassi = ra.automovel_chassi
GROUP BY a.modelo
HAVING COUNT(DISTINCT ra.reserva_rid) = (SELECT MAX(qtd)
								FROM (SELECT COUNT(DISTINCT ra2.reserva_rid) AS qtd
									  FROM reserva_automovel ra2
                                      JOIN automovel a2 ON a2.chassi = ra2.automovel_chassi
                                      GROUP BY a2.modelo
									  ) AS soma
                                );