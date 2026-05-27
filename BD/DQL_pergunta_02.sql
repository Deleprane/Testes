-- PERGUNTA 2
-- Média de posse de bola e média de passes dos vencedores por ano.
-- Exibe apenas os anos cuja média de posse ficou acima da média geral.
-- NULLIF trata registros com posse_de_bola vazia (evita erro de cast).

WITH medias_anuais AS (
    SELECT
        EXTRACT(YEAR FROM j.data)                                                        AS ano,
        AVG(CAST(NULLIF(REPLACE(e.posse_de_bola, '%', ''), '') AS NUMERIC))             AS media_posse,
        AVG(e.passes)                                                                    AS media_passes
    FROM jogos j
    JOIN estatisticas e ON e.partida_id = j.id AND e.clube = j.vencedor
    WHERE j.vencedor IS NOT NULL AND j.vencedor <> ''
    GROUP BY EXTRACT(YEAR FROM j.data)
),
media_geral AS (
    SELECT AVG(CAST(NULLIF(REPLACE(e.posse_de_bola, '%', ''), '') AS NUMERIC)) AS media_geral_posse
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
