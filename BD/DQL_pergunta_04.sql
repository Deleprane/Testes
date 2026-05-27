-- PERGUNTA 4
-- Clubes mandantes que venceram em casa e cuja média de escanteios
-- nas vitórias ficou acima da média geral dos mandantes vencedores.
-- Exibe: clube, média de escanteios, quantidade de vitórias.
-- Ordenado da maior para menor média.

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
