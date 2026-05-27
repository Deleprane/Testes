-- PERGUNTA 6
-- Partidas em que o clube com maior posse de bola foi derrotado.
-- Exibe: mandante, visitante, posse do mandante, posse do visitante,
--        vencedor e diferença percentual de posse entre os clubes.

SELECT
    j.mandante,
    j.visitante,
    e_m.posse_de_bola   AS posse_mandante,
    e_v.posse_de_bola   AS posse_visitante,
    j.vencedor,
    ABS(
        CAST(NULLIF(REGEXP_REPLACE(e_m.posse_de_bola, '[^0-9.]', '', 'g'), '') AS NUMERIC) -
        CAST(NULLIF(REGEXP_REPLACE(e_v.posse_de_bola, '[^0-9.]', '', 'g'), '') AS NUMERIC)
    )                   AS diferenca_percentual
FROM jogos j
JOIN estatisticas e_m ON e_m.partida_id = j.id AND e_m.clube = j.mandante
JOIN estatisticas e_v ON e_v.partida_id = j.id AND e_v.clube = j.visitante
WHERE j.vencedor IS NOT NULL AND j.vencedor <> ''
  AND e_m.posse_de_bola IS NOT NULL AND e_m.posse_de_bola <> ''
  AND e_v.posse_de_bola IS NOT NULL AND e_v.posse_de_bola <> ''
  AND (
        (CAST(NULLIF(REGEXP_REPLACE(e_m.posse_de_bola, '[^0-9.]', '', 'g'), '') AS NUMERIC) >
         CAST(NULLIF(REGEXP_REPLACE(e_v.posse_de_bola, '[^0-9.]', '', 'g'), '') AS NUMERIC)
         AND j.vencedor = j.visitante)
        OR
        (CAST(NULLIF(REGEXP_REPLACE(e_v.posse_de_bola, '[^0-9.]', '', 'g'), '') AS NUMERIC) >
         CAST(NULLIF(REGEXP_REPLACE(e_m.posse_de_bola, '[^0-9.]', '', 'g'), '') AS NUMERIC)
         AND j.vencedor = j.mandante)
      )
ORDER BY diferenca_percentual DESC;
