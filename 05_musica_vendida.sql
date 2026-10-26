-- Qual é o gênero musical mais popular em cada país? 
-- 'WITH' para filtramos algumas colunas especificas e gerar uma 'mini tabela'
WITH tab_paises AS (
SELECT t1.InvoiceId,
       t1.CustomerId,
       t2.Country
FROM Invoice AS t1
-- JOIN interligando a tabela Customer com a que criei com 'WITH', para pegarmos o numero do cliente
LEFT JOIN Customer AS t2
ON t1.CustomerId = t2.CustomerId
),

tab_sumario AS (
SELECT t3.Country,
       t6.Name,
       SUM(t4.Quantity) AS total_vendas -- Somei todas as quantidades vendidas 
FROM tab_paises AS t3

LEFT JOIN InvoiceLine AS t4
ON t3.InvoiceId = t4.InvoiceId
JOIN track AS t5
ON t4.TrackId = t5.TrackId
JOIN genre AS t6
ON t5.GenreId = t6.GenreId
-- 'JOIN' interligando mais algumas tabelas e informações que precisamos, numero da invoice, numero da track e o gênero musical
GROUP BY t3.Country, t6.GenreId -- Agrupei todas as quantidades vendidas por paises e gêneros
),

tab_ranking AS (
SELECT Country,
       name,
       total_vendas,
       ROW_NUMBER () OVER (PARTITION BY Country ORDER BY total_vendas DESC) AS ranking
       --'ROW_NUMBER' para criar a coluna de ranking do gênero musical mais vendido (vai ser 1 e os outros que segue a sequencia de 2,3,4 e etc)
FROM tab_sumario
)

SELECT *
FROM tab_ranking
WHERE ranking = 1 -- filtrei através do ROW NUMBER() apenas os números '1' que significa que são os gêneros musicais mais vendidos
ORDER BY total_vendas DESC -- Ordernei pelo total de vendas para ficar fácil de visualizar 
