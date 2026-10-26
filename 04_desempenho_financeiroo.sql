    -- Pergunta 4: Quais faturas tiveram um valor acima da média geral de todas as faturas da empresa?
-- Objetivo: Identificar faturas de alto valor que superam o comportamento padrão de consumo.

-- 'WITH' para criar a tabela com o numero da invoice e a média do valor total de todas elas juntas
WITH tab_sumario_media AS (
SELECT InvoiceId AS t1, -- 'AS' para renomear a tabela de coluna para não ter duplicidade de coluna
       AVG(total) AS media 
FROM Invoice
)

SELECT InvoiceId,
       Total,
       ROUND(((total - media) / media) * 100) AS diff_porcentagem -- fórmula da porcentagem de diferença do valor da média
FROM invoice, tab_sumario_media
WHERE Total > media 
-- 'WHERE' para filtrar os valores totais por invoice maiores que o valor da media juntando todas
ORDER BY Total DESC 
