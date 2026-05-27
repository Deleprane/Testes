-- PERGUNTA 3
-- Jogadores com maior quantidade de gols contra no campeonato.
-- Em caso de empate, todos os atletas empatados são exibidos.
-- Exibe: atleta, clube, quantidade de gols contra.

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
