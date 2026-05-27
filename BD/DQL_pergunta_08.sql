-- PERGUNTA 8
-- Partidas em que o clube vencedor recebeu ao menos um cartão vermelho.
-- Exibe: clube vencedor, adversário, placar, quantidade de cartões
--        vermelhos recebidos pelo vencedor e rodada.

SELECT
    j.vencedor                                              AS clube_vencedor,
    CASE
        WHEN j.vencedor = j.mandante THEN j.visitante
        ELSE j.mandante
    END                                                     AS adversario,
    CONCAT(j.mandante_placar, ' x ', j.visitante_placar)   AS placar,
    COUNT(c.id)                                             AS cartoes_vermelhos,
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
