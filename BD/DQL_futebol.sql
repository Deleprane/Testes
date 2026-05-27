-- DQL - Design e Desenvolvimento de Banco de Dados I
-- Universidade Vila Velha - 2026/1
-- Avaliação 2º Bimestre

-- ============================================================
-- PERGUNTA 1
-- Clubes com maior total de cartões (amarelos + vermelhos)
-- recebidos em partidas que venceram.
-- ============================================================
WITH cartoes_vitorias AS (
    SELECT
        j.vencedor              AS clube,
        COUNT(c.id)             AS total_cartoes,
        COUNT(DISTINCT j.id)    AS quantidade_vitorias
    FROM jogos j
    JOIN cartoes c ON c.partida_id = j.id AND c.clube = j.vencedor
    WHERE j.vencedor IS NOT NULL AND j.vencedor <> ''
    GROUP BY j.vencedor
)
SELECT clube, total_cartoes, quantidade_vitorias
FROM cartoes_vitorias
WHERE total_cartoes = (SELECT MAX(total_cartoes) FROM cartoes_vitorias)
ORDER BY clube;


-- ============================================================
-- PERGUNTA 2
-- Média de posse de bola e passes dos vencedores por ano.
-- Exibir apenas os anos acima da média geral de posse.
-- ============================================================
WITH medias_anuais AS (
    SELECT
        EXTRACT(YEAR FROM j.data)                                           AS ano,
        AVG(CAST(REPLACE(e.posse_de_bola, '%', '') AS NUMERIC))            AS media_posse,
        AVG(e.passes)                                                       AS media_passes
    FROM jogos j
    JOIN estatisticas e ON e.partida_id = j.id AND e.clube = j.vencedor
    WHERE j.vencedor IS NOT NULL AND j.vencedor <> ''
    GROUP BY EXTRACT(YEAR FROM j.data)
),
media_geral AS (
    SELECT AVG(CAST(REPLACE(e.posse_de_bola, '%', '') AS NUMERIC)) AS media_geral_posse
    FROM jogos j
    JOIN estatisticas e ON e.partida_id = j.id AND e.clube = j.vencedor
    WHERE j.vencedor IS NOT NULL AND j.vencedor <> ''
)
SELECT
    ma.ano,
    ROUND(ma.media_posse, 2)            AS media_posse_bola,
    ROUND(ma.media_passes::NUMERIC, 2)  AS media_passes
FROM medias_anuais ma
CROSS JOIN media_geral mg
WHERE ma.media_posse > mg.media_geral_posse
ORDER BY ma.ano;


-- ============================================================
-- PERGUNTA 3
-- Jogadores com maior quantidade de gols contra.
-- Em caso de empate, todos são exibidos.
-- ============================================================
WITH gols_contra AS (
    SELECT
        atleta,
        clube,
        COUNT(*) AS qtd_gols_contra
    FROM gols
    WHERE tipo_de_gol ILIKE '%contra%'
    GROUP BY atleta, clube
)
SELECT atleta, clube, qtd_gols_contra
FROM gols_contra
WHERE qtd_gols_contra = (SELECT MAX(qtd_gols_contra) FROM gols_contra)
ORDER BY atleta;


-- ============================================================
-- PERGUNTA 4
-- Mandantes vencedores cuja média de escanteios nas vitórias
-- supera a média geral dos mandantes vencedores.
-- Ordenado da maior para menor média.
-- ============================================================
WITH escanteios_por_clube AS (
    SELECT
        j.mandante          AS clube,
        AVG(e.escanteios)   AS media_escanteios,
        COUNT(j.id)         AS quantidade_vitorias
    FROM jogos j
    JOIN estatisticas e ON e.partida_id = j.id AND e.clube = j.mandante
    WHERE j.vencedor = j.mandante
    GROUP BY j.mandante
),
media_geral AS (
    SELECT AVG(e.escanteios) AS media_geral
    FROM jogos j
    JOIN estatisticas e ON e.partida_id = j.id AND e.clube = j.mandante
    WHERE j.vencedor = j.mandante
)
SELECT
    ec.clube,
    ROUND(ec.media_escanteios, 2) AS media_escanteios,
    ec.quantidade_vitorias
FROM escanteios_por_clube ec
CROSS JOIN media_geral mg
WHERE ec.media_escanteios > mg.media_geral
ORDER BY ec.media_escanteios DESC;


-- ============================================================
-- PERGUNTA 5
-- Técnicos com maior número de vitórias totais
-- (como mandante ou visitante).
-- ============================================================
WITH vitorias AS (
    SELECT tecnico_mandante AS tecnico, COUNT(*) AS total
    FROM jogos
    WHERE vencedor = mandante AND vencedor IS NOT NULL AND vencedor <> ''
    GROUP BY tecnico_mandante

    UNION ALL

    SELECT tecnico_visitante AS tecnico, COUNT(*) AS total
    FROM jogos
    WHERE vencedor = visitante AND vencedor IS NOT NULL AND vencedor <> ''
    GROUP BY tecnico_visitante
),
total_por_tecnico AS (
    SELECT tecnico, SUM(total) AS total_vitorias
    FROM vitorias
    GROUP BY tecnico
)
SELECT tecnico, total_vitorias
FROM total_por_tecnico
WHERE total_vitorias = (SELECT MAX(total_vitorias) FROM total_por_tecnico)
ORDER BY tecnico;


-- ============================================================
-- PERGUNTA 6
-- Partidas em que o clube com maior posse de bola foi derrotado.
-- ============================================================
SELECT
    j.mandante,
    j.visitante,
    e_m.posse_de_bola   AS posse_mandante,
    e_v.posse_de_bola   AS posse_visitante,
    j.vencedor,
    ABS(
        CAST(REPLACE(e_m.posse_de_bola, '%', '') AS NUMERIC) -
        CAST(REPLACE(e_v.posse_de_bola, '%', '') AS NUMERIC)
    )                   AS diferenca_percentual
FROM jogos j
JOIN estatisticas e_m ON e_m.partida_id = j.id AND e_m.clube = j.mandante
JOIN estatisticas e_v ON e_v.partida_id = j.id AND e_v.clube = j.visitante
WHERE j.vencedor IS NOT NULL AND j.vencedor <> ''
  AND (
        (CAST(REPLACE(e_m.posse_de_bola, '%', '') AS NUMERIC) >
         CAST(REPLACE(e_v.posse_de_bola, '%', '') AS NUMERIC)
         AND j.vencedor = j.visitante)
        OR
        (CAST(REPLACE(e_v.posse_de_bola, '%', '') AS NUMERIC) >
         CAST(REPLACE(e_m.posse_de_bola, '%', '') AS NUMERIC)
         AND j.vencedor = j.mandante)
      )
ORDER BY diferenca_percentual DESC;


-- ============================================================
-- PERGUNTA 7
-- Partidas entre as 5 maiores quantidades totais de cartões.
-- Inclui empates de posição (DENSE_RANK).
-- ============================================================
WITH cartoes_por_partida AS (
    SELECT
        partida_id,
        COUNT(*) AS total_cartoes
    FROM cartoes
    GROUP BY partida_id
),
ranking AS (
    SELECT
        partida_id,
        total_cartoes,
        DENSE_RANK() OVER (ORDER BY total_cartoes DESC) AS posicao
    FROM cartoes_por_partida
)
SELECT
    j.mandante,
    j.visitante,
    r.total_cartoes,
    j.vencedor,
    j.rodada
FROM ranking r
JOIN jogos j ON j.id = r.partida_id
WHERE r.posicao <= 5
ORDER BY r.total_cartoes DESC, j.rodada;


-- ============================================================
-- PERGUNTA 8
-- Partidas em que o vencedor recebeu ao menos um cartão vermelho.
-- ============================================================
SELECT
    j.vencedor                                                  AS clube_vencedor,
    CASE
        WHEN j.vencedor = j.mandante THEN j.visitante
        ELSE j.mandante
    END                                                         AS adversario,
    CONCAT(j.mandante_placar, ' x ', j.visitante_placar)       AS placar,
    COUNT(c.id)                                                 AS cartoes_vermelhos,
    j.rodada
FROM jogos j
JOIN cartoes c ON c.partida_id = j.id
    AND c.clube = j.vencedor
    AND c.cartao ILIKE '%vermelho%'
WHERE j.vencedor IS NOT NULL AND j.vencedor <> ''
GROUP BY
    j.id, j.vencedor, j.mandante, j.visitante,
    j.mandante_placar, j.visitante_placar, j.rodada
ORDER BY j.rodada;
