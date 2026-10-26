-- 1º pergunta = 'Quantos clientes a empresa possui em cada país?'

-- Seleciona quantidade máxima de clientes e os países
-- 'ROUND' eu utilizei para descobrir a porcentagem de cada país
SELECT COUNT(CustomerId) AS Clientes,
       Country AS País,
       ROUND(COUNT(CustomerId)) * 100 / (SELECT  COUNT(*) FROM Customer) AS porcentual
       
FROM Customer

-- Agrupei por países a quantidade maxima de cliente e ordenei
GROUP BY Country 
ORDER BY Clientes DESC