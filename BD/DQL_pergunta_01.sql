-- PERGUNTA 1
-- Clubes com maior total de cartões (amarelos + vermelhos)
-- recebidos em partidas que venceram.
-- Exibe: clube, total de cartões, quantidade de vitórias.

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
