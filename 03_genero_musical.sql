-- 3º pergunta = "Qual é o gênero musical (Rock, Jazz, Pop, etc.) mais vendido em volume de faixas?

-- 'WITH' para criar uma mini tabela dentro da query com as informações dentro do parentêse
-- No 'SELECT' selecionei a coluna para interligar no JOIN, o numero do genero musical e o nome correspondente ao número do mesmo
-- No 'JOIN' eu interliguei a tabela que continha o número do gênero e o nome do proprio gênero musical
WITH tab_genero_musica AS (
 
SELECT t1.TrackId,
       t1.GenreId,
       t2.Name
FROM Track AS t1

LEFT JOIN Genre AS t2
ON t1.GenreId = t2.GenreId

)

SELECT t3.Name,
       SUM(t4.Quantity) AS qtdegenerovendido
FROM tab_genero_musica AS t3
-- No 'SELECT' selecionei o nome e somei a quantidade total

LEFT JOIN InvoiceLine AS t4
ON t3.TrackId = t4.TrackId

-- NO 'JOIN' eu interliguei a tabela da quantidade vendida por genero com essa que construimos agora

-- 'WHERE' para retirar os valores nulos
WHERE t4.InvoiceLineId IS NOT NULL

-- Agrupei por nome de gênero
GROUP BY t3.GenreId

-- Ordenei para ficar mais claro
ORDER BY qtdegenerovendido DESC

