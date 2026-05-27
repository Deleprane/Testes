-- PERGUNTA 5
-- Técnicos com maior número de vitórias totais,
-- considerando partidas como mandante e visitante.
-- Exibe: nome do técnico, total de vitórias.

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
