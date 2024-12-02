-- People
INSERT ALL
    INTO People (person_id, first_name, last_name, birthdate, country) VALUES (1, 'John', 'Doe', DATE '1985-05-15', 'USA')
    INTO People (person_id, first_name, last_name, birthdate, country) VALUES (2, 'Jane', 'Smith', DATE '1990-08-22', 'Canada')
    INTO People (person_id, first_name, last_name, birthdate, country) VALUES (3, 'Carlos', 'Martinez', DATE '1982-12-01', 'Mexico')
    INTO People (person_id, first_name, last_name, birthdate, country) VALUES (4, 'Emily', 'Johnson', DATE '1995-03-05', 'UK')
    INTO People (person_id, first_name, last_name, birthdate, country) VALUES (5, 'Liam', 'Brown', DATE '1988-11-17', 'Australia')
SELECT * FROM DUAL;

-- Players
INSERT ALL
    INTO Players (player_id, person_id, is_captain) VALUES (1, 1, 1)
    INTO Players (player_id, person_id, is_captain) VALUES (2, 2, 0)
    INTO Players (player_id, person_id, is_captain) VALUES (3, 3, 0)
SELECT * FROM DUAL;

-- Coaches
INSERT ALL
    INTO Coaches (coach_id, person_id) VALUES (1, 4)
    INTO Coaches (coach_id, person_id) VALUES (2, 5)
SELECT * FROM DUAL;

-- Referees
INSERT ALL
    INTO Referees (referee_id, person_id) VALUES (1, 5)
SELECT * FROM DUAL;

-- Teams
INSERT ALL
    INTO Teams (team_id, team_name, is_active, coach_id) VALUES (1, 'Team Alpha', 1, 1)
    INTO Teams (team_id, team_name, is_active, coach_id) VALUES (2, 'Team Beta', 1, 2)
SELECT * FROM DUAL;

-- Matches
INSERT ALL
    INTO Matches (match_id, duration, match_date, round, referee_id, mvp_player_id) VALUES (1, 90, DATE '2024-10-01', 'Quarterfinals', 1, 1)
    INTO Matches (match_id, duration, match_date, round, referee_id, mvp_player_id) VALUES (2, 120, DATE '2024-10-10', 'Semifinals', 1, 2)
SELECT * FROM DUAL;

-- MatchTeam
INSERT ALL
    INTO MatchTeam (match_id, team_id, is_home_team, score) VALUES (1, 1, 1, 3)
    INTO MatchTeam (match_id, team_id, is_home_team, score) VALUES (1, 2, 0, 2)
    INTO MatchTeam (match_id, team_id, is_home_team, score) VALUES (2, 1, 0, 1)
    INTO MatchTeam (match_id, team_id, is_home_team, score) VALUES (2, 2, 1, 2)
SELECT * FROM DUAL;

-- TeamPlayer
INSERT ALL
    INTO TeamPlayer (team_id, player_id, is_starter, score) VALUES (1, 1, 1, 2)
    INTO TeamPlayer (team_id, player_id, is_starter, score) VALUES (1, 2, 0, 1)
    INTO TeamPlayer (team_id, player_id, is_starter, score) VALUES (2, 3, 1, 3)
SELECT * FROM DUAL;

-- MatchEvent
INSERT ALL
    INTO MatchEvent (event_id, match_id, player_id, event_time, event_type) VALUES (1, 1, 1, 15, 'Point')
    INTO MatchEvent (event_id, match_id, player_id, event_time, event_type) VALUES (2, 1, 3, 35, 'Foul')
    INTO MatchEvent (event_id, match_id, player_id, event_time, event_type) VALUES (3, 2, 2, 75, 'Point')
    INTO MatchEvent (event_id, match_id, player_id, event_time, event_type) VALUES (4, 2, 3, 110, 'Point')
SELECT * FROM DUAL;