# Análise Financeira e Estratégica de Vendas — Banco de Dados Chinook

##  Contexto e Desafio de Negócio

> "A diretoria executiva da Chinook deseja reavaliar a estratégia de investimentos em marketing para o próximo trimestre. Para isso, é preciso entender quais países representam o maior volume de receita real, cruzando essa informação com o tíquete médio por cliente, identificando onde a empresa concentra seu faturamento e onde existem oportunidades inexploradas de expansão."

##  Abordagem e Estrutura do Repositório

Para responder a este desafio, a análise foi estruturada de forma progressiva, partindo de agregações fundamentais até consultas avançadas com **CTEs** e **Window Functions**.

* **Foco do README:** Apresentação dos resultados, gráficos mentais e recomendações de negócio geradas por cada consulta.
* **Códigos Completos:** Os scripts `.sql` comentados passo a passo estão organizados na pasta `/queries` para rápida consulta e auditoria.

---

## 1º pergunta = 'Quantos clientes a empresa possui em cada país?'
* Objetivo: Pergunta que faz entender a visão geográfica da empresa.

1º)) query

```sql
SELECT COUNT(CustomerId) AS Clientes,
       Country AS País
       
FROM Customer

GROUP BY Country 
ORDER BY Clientes DESC  
```

> Resultado: Podemos observar que EUA e Canadá juntos concentram 21 clientes (aproximadamente 35,6% de toda a base global);
> 15 países possuem apenas 1 cliente cadastrado. Isso mostra uma presença global pulverizada, porém com baixa densidade na maioria das regiões.
> O Brasil é o principal mercado da América do Sul com 5 clientes (empatado com a França e atrás apenas de EUA e Canadá)


## 2º pergunta = 'Quais são os 5 clientes que mais gastaram na loja no total?'
* Objetivo: Identificar os clientes de maior valor (VIPs / Curva A de faturamento) para compreender a concentração de receita individual.

2º)) query

```sql
SELECT t2.FirstName|| ' ' || t2.LastName AS Cliente,
       t2.country,
       ROUND(SUM(t1.Total), 2) AS quanto_gastou
FROM Invoice AS t1

LEFT JOIN Customer AS t2
ON t1.CustomerId = t2.CustomerId

GROUP BY t2.CustomerID

ORDER BY quanto_gastou DESC 

LIMIT 5
```

>> Resultado: USA por mais que tenha a maior quantidade de clientes, possui apenas 1 na lista dos 5 que mais gastaram na loja.
>> A Czech Republic possui apenas 2 clientes, porém uma delas é a 1º maior consumidora da loja, pode ser que a empresa possa olhar esse país com mais atenção para atrair outros potenciais consumidores.
>> Brasil e França ficaram empatados em 3º na quantidade de clientes, mas não teve nenhum cliente com maior gasto, vale a pena analisar e entender qual a demanda de produtos necessária para os clientes.

## 3º pergunta = "Qual é o gênero musical (Rock, Jazz, Pop, etc.) mais vendido em volume de faixas?
* Objetivo: Compreender a preferência musical dos clientes para otimizar o catálogo e estratégias de aquisição de novos lançamentos.

3º)) query

```sql
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

LEFT JOIN InvoiceLine AS t4
ON t3.TrackId = t4.TrackId

WHERE t4.InvoiceLineId IS NOT NULL

GROUP BY t3.GenreId

ORDER BY qtdegenerovendido DESC
```

>> Resultado: Podemos observar que o gênero do Rock é o mais vendido, mais que o dobro do segundo colocado.
>> Os 4 primeiro gêneros (rock,latin,Metal,Alternative & Punk) compõe aproximadamente 75% de vendas de todo o arsenal disponível. O que inidica forte concentração do público em géneros de nicho com base de fãs fiel.
>> Géneros populares no mercado global como Pop (28 vendas) e Hip Hop/Rap (17 vendas) possuem baixo volume nesta plataforma, indicando um perfil de consumidor muito específico na Chinook

## 4º pergunta: Quais faturas tiveram um valor acima da média geral de todas as faturas da empresa?
* Objetivo: Identificar faturas de alto valor que superam o comportamento padrão de consumo.

4º)) query

``` sql
WITH tab_sumario_media AS (
SELECT InvoiceId AS t1, 
       AVG(total) AS media 
FROM Invoice
)

SELECT InvoiceId,
       Total
       ROUND(((total - media) / media) * 100) AS diff_porcentagem
FROM invoice, tab_sumario_media
WHERE Total > media 

ORDER BY Total DESC 
```

>> Resultado: As 4 primeiras Invoices possui 20 ponto a mais da média total, o que significa que foram as melhores compras, comportamento padrão mais alto de consumo... vale a pena a empresa entender o que foi comprado e por quem para poder gerar novas estratégias.
>> A invoice '5' para baixo fica bem estagnado os valores, não gera muita diferença acima da média, o que leva a entender um comportamento padrão nesse total de '13.86' pontos a mais acima da média. 

## 5º pergunta: Qual é o gênero musical mais popular em cada país?
* Objetivo: Mapear a preferência cultural e regional de consumo, utilizando Window Functions para direcionar estratégias de marketing por mercado.

``` sql
WITH tab_paises AS (
SELECT t1.InvoiceId,
       t1.CustomerId,
       t2.Country
FROM Invoice AS t1
LEFT JOIN Customer AS t2
ON t1.CustomerId = t2.CustomerId
),

tab_sumario AS (
SELECT t3.Country,
       t6.Name,
       SUM(t4.Quantity) AS total_vendas
FROM tab_paises AS t3

LEFT JOIN InvoiceLine AS t4
ON t3.InvoiceId = t4.InvoiceId
JOIN track AS t5
ON t4.TrackId = t5.TrackId
JOIN genre AS t6
ON t5.GenreId = t6.GenreId
GROUP BY t3.Country, t6.GenreId
),

tab_ranking AS (
SELECT Country,
       name,
       total_vendas,
       ROW_NUMBER () OVER (PARTITION BY Country ORDER BY total_vendas DESC) AS ranking
FROM tab_sumario
)

SELECT *
FROM tab_ranking
WHERE ranking = 1 
ORDER BY total_vendas DESC 
```

>> Resultado: O gênero Rock é o mais vendido em todos os países, com a exceção de Sweden, que prefere o Latin... isso nos diz que o nicho da Chinnok é muito bem estabelecido.
>>Com esse resultado podemos estabelecer algumas estratégias para aumentar mais ainda a expansão do Rock e entender como o gênero mais vendido na Sweden é o Latin e com isso estipular mais ainda essa cultura.  

---

## Conclusões e Recomendação Executiva Final

Com base na análise integrada das 5 consultas realizadas no banco de dados Chinook, sintetizam-se as seguintes diretrizes para a diretoria:

1. **Foco e Retenção nos Mercados Consolidados:**
   * EUA, Canadá e Brasil lideram o volume financeiro e de vendas. O investimento em marketing nestas regiões deve ser focado em fidelização e recomendação personalizada, aproveitando a forte preferência pelo género Rock.

2. **Oportunidades Inexploradas (Expansão):**
   * Mercados como a Suécia demonstram um comportamento atípico relevante (preferência por Latin em vez de Rock). Campanhas regionalizadas e catálogos específicos devem ser testados nestes países para capturar procura não atendida.

3. **Estratégia de Ticket Médio e Vendas de Alto Valor:**
   * A análise de faturas acima da média revelou que as maiores transações superam em até 358% a média geral. Recomenda-se criar pacotes promocionais (*bundles*) e incentivos de volume para migrar clientes de consumo padrão (estagnados nos $13.86) para o grupo de alto valor.

---