ALTER SESSION SET CURRENT_SCHEMA = TMT;

CREATE TABLE People (
  person_id NUMBER,
  first_name VARCHAR2(50) NOT NULL,
  last_name VARCHAR2(50) NOT NULL,
  birthdate DATE NOT NULL,
  country VARCHAR2(50) NOT NULL
);

CREATE TABLE Players (
  player_id NUMBER,
  person_id NUMBER NOT NULL,
  is_captain NUMBER(1) NOT NULL
);

CREATE TABLE Coaches (
  coach_id NUMBER,
  person_id NUMBER NOT NULL
);

CREATE TABLE Referees (
  referee_id NUMBER,
  person_id NUMBER NOT NULL
);

CREATE TABLE Teams (
  team_id NUMBER,
  team_name VARCHAR2(100) NOT NULL,
  is_active NUMBER(1) NOT NULL,
  coach_id NUMBER NOT NULL
);

CREATE TABLE Matches (
  match_id NUMBER,
  duration NUMBER NOT NULL,
  match_date DATE NOT NULL,
  round VARCHAR2(50) NOT NULL,
  referee_id NUMBER NOT NULL,
  mvp_player_id NUMBER
);

CREATE TABLE MatchTeam (
  match_id NUMBER NOT NULL,
  team_id NUMBER NOT NULL,
  is_home_team NUMBER(1) NOT NULL,
  score NUMBER NOT NULL
);

CREATE TABLE TeamPlayer (
  team_id NUMBER NOT NULL,
  player_id NUMBER NOT NULL,
  is_starter NUMBER(1) NOT NULL,
  score NUMBER NOT NULL
);

CREATE TABLE MatchEvent (
  event_id NUMBER,
  match_id NUMBER NOT NULL,
  player_id NUMBER NOT NULL,
  event_time NUMBER NOT NULL,
  event_type VARCHAR2(50) NOT NULL
);


