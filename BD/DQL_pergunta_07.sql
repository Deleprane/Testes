-- PERGUNTA 7
-- Partidas que pertencem ao grupo das 5 maiores quantidades
-- totais de cartões distribuídos (amarelos + vermelhos).
-- Inclui empates de posição via DENSE_RANK.
-- Exibe: mandante, visitante, total de cartões, vencedor, rodada.

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
