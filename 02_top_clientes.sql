-- 2º pergunta = 'Quais são os 5 clientes que mais gastaram na loja no total?'

-- Seleciona o primeiro e ultimo nome do cliente e junta uma com a outra,
-- seleciona o país, e uitiliza o 'ROUND' para somar a quantidade de pontos
SELECT t2.FirstName|| ' ' || t2.LastName AS Cliente,
       t2.country,
       ROUND(SUM(t1.Total), 2) AS quanto_gastou
FROM Invoice AS t1

-- 'LEFT JOIN' para juntar a tabela 'Invoice' com os valores,
-- e a tabela 'Customer' com as informações do cliente
LEFT JOIN Customer AS t2
ON t1.CustomerId = t2.CustomerId

-- Agrupar o resultado da soma dos valores com o nome do cliente
GROUP BY t2.CustomerId

-- Ordernar para saber qual cliente mais gastou
ORDER BY quanto_gastou DESC 

-- Limit 5 para pegar apenas os 5 que mais gastou
LIMIT 5