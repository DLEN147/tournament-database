ALTER SESSION SET CURRENT_SCHEMA = TMT;

-- Insertar personas
INSERT ALL
  INTO People (person_id, first_name, last_name, birthdate, country)
  VALUES (1, 'Juan', 'Pérez', TO_DATE('1990-05-10', 'YYYY-MM-DD'), 'Colombia')
  INTO People (person_id, first_name, last_name, birthdate, country)
  VALUES (2, 'Ana', 'Gómez', TO_DATE('1985-11-15', 'YYYY-MM-DD'), 'Argentina')
  INTO People (person_id, first_name, last_name, birthdate, country)
  VALUES (3, 'Luis', 'Martínez', TO_DATE('1988-06-20', 'YYYY-MM-DD'), 'España')
  INTO People (person_id, first_name, last_name, birthdate, country)
  VALUES (4, 'María', 'López', TO_DATE('1992-07-12', 'YYYY-MM-DD'), 'Chile')
  INTO People (person_id, first_name, last_name, birthdate, country)
  VALUES (5, 'Carlos', 'Ruiz', TO_DATE('1994-08-18', 'YYYY-MM-DD'), 'México')
  INTO People (person_id, first_name, last_name, birthdate, country)
  VALUES (6, 'Sofía', 'Castro', TO_DATE('1987-09-10', 'YYYY-MM-DD'), 'Colombia')
SELECT * FROM DUAL;

-- Insertar jugadores
INSERT ALL
  INTO Players (player_id, person_id, is_captain)
  VALUES (1, 1, 1)
  INTO Players (player_id, person_id, is_captain)
  VALUES (2, 3, 0)
  INTO Players (player_id, person_id, is_captain)
  VALUES (3, 4, 0)
  INTO Players (player_id, person_id, is_captain)
  VALUES (4, 5, 0)
SELECT * FROM DUAL;

-- Insertar entrenadores
INSERT ALL
  INTO Coaches (coach_id, person_id)
  VALUES (1, 2)
  INTO Coaches (coach_id, person_id)
  VALUES (2, 6)
SELECT * FROM DUAL;

-- Insertar árbitros
INSERT ALL
  INTO Referees (referee_id, person_id)
  VALUES (1, 3)
  INTO Referees (referee_id, person_id)
  VALUES (2, 4)
SELECT * FROM DUAL;

-- Insertar equipos
INSERT ALL
  INTO Teams (team_id, team_name, is_active, coach_id)
  VALUES (1, 'Tigres FC', 1, 1)
  INTO Teams (team_id, team_name, is_active, coach_id)
  VALUES (2, 'Leones FC', 1, 2)
SELECT * FROM DUAL;

-- Insertar partidos
INSERT ALL
  INTO Matches (match_id, duration, match_date, round, referee_id, mvp_player_id)
  VALUES (1, 90, TRUNC(SYSDATE) + 2, 'Cuartos de final', 1, NULL)
  INTO Matches (match_id, duration, match_date, round, referee_id, mvp_player_id)
  VALUES (2, 120, TRUNC(SYSDATE) + 7, 'Semifinal', 2, NULL)
SELECT * FROM DUAL;

-- Insertar equipos en partidos
INSERT ALL
  INTO MatchTeam (match_id, team_id, is_home_team, score)
  VALUES (1, 1, 1, 2)
  INTO MatchTeam (match_id, team_id, is_home_team, score)
  VALUES (1, 2, 0, 1)
  INTO MatchTeam (match_id, team_id, is_home_team, score)
  VALUES (2, 1, 1, 3)
  INTO MatchTeam (match_id, team_id, is_home_team, score)
  VALUES (2, 2, 0, 2)
SELECT * FROM DUAL;

-- Insertar jugadores en equipos
INSERT ALL
  INTO TeamPlayer (team_id, player_id, is_starter, score)
  VALUES (1, 1, 1, 2)
  INTO TeamPlayer (team_id, player_id, is_starter, score)
  VALUES (1, 4, 0, 0)
  INTO TeamPlayer (team_id, player_id, is_starter, score)
  VALUES (2, 3, 1, 1)
  INTO TeamPlayer (team_id, player_id, is_starter, score)
  VALUES (2, 2, 1, 0)
SELECT * FROM DUAL;

-- Insertar eventos en partidos
INSERT ALL
  INTO MatchEvent (event_id, match_id, player_id, event_time, event_type)
  VALUES (1, 1, 1, 45, 'Punto')
  INTO MatchEvent (event_id, match_id, player_id, event_time, event_type)
  VALUES (2, 1, 3, 78, 'Falta')
  INTO MatchEvent (event_id, match_id, player_id, event_time, event_type)
  VALUES (3, 1, 1, 85, 'Punto')
  INTO MatchEvent (event_id, match_id, player_id, event_time, event_type)
  VALUES (4, 2, 2, 20, 'Falta')
  INTO MatchEvent (event_id, match_id, player_id, event_time, event_type)
  VALUES (5, 2, 3, 55, 'Punto')
  INTO MatchEvent (event_id, match_id, player_id, event_time, event_type)
  VALUES (6, 2, 4, 90, 'Punto')
  INTO MatchEvent (event_id, match_id, player_id, event_time, event_type)
  VALUES (7, 2, 1, 110, 'Falta')
SELECT * FROM DUAL;
