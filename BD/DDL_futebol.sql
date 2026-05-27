-- DDL - Design e Desenvolvimento de Banco de Dados I
-- Universidade Vila Velha - 2026/1

CREATE TABLE jogos (
    id               BIGINT PRIMARY KEY,
    rodada           INT,
    data             DATE,
    horario          TIME,
    mandante         VARCHAR(50),
    visitante        VARCHAR(50),
    formacao_mandante  VARCHAR(50),
    formacao_visitante VARCHAR(50),
    tecnico_mandante   VARCHAR(50),
    tecnico_visitante  VARCHAR(50),
    vencedor         VARCHAR(50),
    arena            VARCHAR(150),
    mandante_placar  INT,
    visitante_placar INT,
    mandante_estado  VARCHAR(2),
    visitante_estado VARCHAR(2)
);

CREATE TABLE cartoes (
    id         SERIAL PRIMARY KEY,
    partida_id BIGINT,
    rodada     INT,
    clube      VARCHAR(50),
    cartao     VARCHAR(50),
    atleta     VARCHAR(100),
    num_camisa INT,
    posicao    VARCHAR(50),
    minuto     VARCHAR(10)
);

CREATE TABLE gols (
    id          SERIAL PRIMARY KEY,
    partida_id  BIGINT,
    rodada      INT,
    clube       VARCHAR(50),
    atleta      VARCHAR(100),
    minuto      VARCHAR(10),
    tipo_de_gol VARCHAR(50)
);

CREATE TABLE estatisticas (
    id               SERIAL PRIMARY KEY,
    partida_id       BIGINT NOT NULL,
    rodada           INT,
    clube            VARCHAR(50),
    chutes           INT,
    chutes_no_gol    INT,
    posse_de_bola    VARCHAR(10),
    passes           INT,
    precisao_passes  VARCHAR(10),
    faltas           INT,
    cartao_amarelo   INT,
    cartao_vermelho  INT,
    impedimentos     INT,
    escanteios       INT
);
