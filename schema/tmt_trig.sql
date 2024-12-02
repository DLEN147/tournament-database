ALTER SESSION SET CURRENT_SCHEMA = TMT;

CREATE OR REPLACE TRIGGER one_captain_per_team
BEFORE INSERT OR UPDATE ON TeamPlayer
FOR EACH ROW
DECLARE
  v_count NUMBER;
BEGIN
  IF :NEW.is_starter = 1 THEN
    SELECT COUNT(*)
    INTO v_count
    FROM TeamPlayer tp
    JOIN Players p ON tp.player_id = p.player_id
    WHERE tp.team_id = :NEW.team_id
      AND p.is_captain = 1;

    IF v_count > 1 THEN
      RAISE_APPLICATION_ERROR(-20006, 'Un equipo no puede tener más de un capitán.');
    END IF;
  END IF;
END;
/

CREATE OR REPLACE TRIGGER validate_active_team
BEFORE INSERT OR UPDATE ON MatchTeam
FOR EACH ROW
DECLARE
  v_is_active NUMBER;
BEGIN
  SELECT is_active
  INTO v_is_active
  FROM Teams
  WHERE team_id = :NEW.team_id;

  IF v_is_active = 0 THEN
    RAISE_APPLICATION_ERROR(-20005, 'No se pueden registrar equipos inactivos en un partido.');
  END IF;
END;
/

CREATE OR REPLACE TRIGGER validate_match_date
BEFORE INSERT OR UPDATE ON Matches
FOR EACH ROW
BEGIN
  IF :NEW.match_date < TRUNC(SYSDATE) THEN
    RAISE_APPLICATION_ERROR(-20004, 'La fecha del partido no puede ser en el pasado.');
  END IF;
END;
/

CREATE OR REPLACE TRIGGER validate_coach
BEFORE INSERT OR UPDATE ON Teams
FOR EACH ROW
DECLARE
  v_count NUMBER;
BEGIN
  SELECT COUNT(*)
  INTO v_count
  FROM Coaches
  WHERE coach_id = :NEW.coach_id;

  IF v_count = 0 THEN
    RAISE_APPLICATION_ERROR(-20003, 'El entrenador asignado no existe.');
  END IF;
END;
/

CREATE OR REPLACE TRIGGER unique_team_player
BEFORE INSERT OR UPDATE ON TeamPlayer
FOR EACH ROW
DECLARE
  v_count NUMBER;
BEGIN
  SELECT COUNT(*)
  INTO v_count
  FROM TeamPlayer
  WHERE player_id = :NEW.player_id
    AND team_id != :NEW.team_id;

  IF v_count > 0 THEN
    RAISE_APPLICATION_ERROR(-20002, 'Un jugador no puede pertenecer a más de un equipo simultáneamente.');
  END IF;
END;
/

CREATE OR REPLACE TRIGGER validate_mvp_player
BEFORE INSERT OR UPDATE ON Matches
FOR EACH ROW
WHEN (NEW.mvp_player_id IS NOT NULL)
DECLARE
  v_count NUMBER;
BEGIN
  SELECT COUNT(*)
  INTO v_count
  FROM TeamPlayer tp
  JOIN MatchTeam mt ON tp.team_id = mt.team_id
  WHERE tp.player_id = :NEW.mvp_player_id
    AND mt.match_id = :NEW.match_id;

  IF v_count = 0 THEN
    RAISE_APPLICATION_ERROR(-20001, 'El MVP debe pertenecer a uno de los equipos que jugaron el partido.');
  END IF;
END;
/

CREATE OR REPLACE TRIGGER validate_match_teams
AFTER INSERT OR DELETE ON MatchTeam
FOR EACH ROW
DECLARE
  v_team_count NUMBER;
BEGIN
  IF INSERTING THEN
    SELECT COUNT(*)
    INTO v_team_count
    FROM MatchTeam
    WHERE match_id = :NEW.match_id;

  ELSIF DELETING THEN
    SELECT COUNT(*)
    INTO v_team_count
    FROM MatchTeam
    WHERE match_id = :OLD.match_id;
  END IF;

  IF v_team_count != 2 THEN
    RAISE_APPLICATION_ERROR(-20007, 'Un partido debe tener exactamente dos equipos registrados.');
  END IF;
END;
/


CREATE OR REPLACE TRIGGER check_birthdate
BEFORE INSERT OR UPDATE ON People
FOR EACH ROW
BEGIN
  IF :NEW.birthdate >= SYSDATE THEN
    RAISE_APPLICATION_ERROR(-20007, 'La fecha de nacimiento debe ser anterior a la fecha actual.');
  END IF;
END;
/
