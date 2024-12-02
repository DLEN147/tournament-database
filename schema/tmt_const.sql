ALTER SESSION SET CURRENT_SCHEMA = TMT;

--People
ALTER TABLE People
ADD CONSTRAINT pk_person PRIMARY KEY (person_id);


ALTER TABLE People
ADD CONSTRAINT unique_person UNIQUE (first_name, last_name, birthdate);

--Players
ALTER TABLE Players
ADD CONSTRAINT pk_player PRIMARY KEY (player_id);

ALTER TABLE Players
ADD CONSTRAINT fk_player_person FOREIGN KEY (person_id) REFERENCES People(person_id);

ALTER TABLE Players
ADD CONSTRAINT chk_is_captain CHECK (is_captain IN (0, 1));

--Coaches
ALTER TABLE Coaches
ADD CONSTRAINT pk_coach PRIMARY KEY (coach_id);

ALTER TABLE Coaches
ADD CONSTRAINT fk_coach_person FOREIGN KEY (person_id) REFERENCES People(person_id);

--Referees
ALTER TABLE Referees
ADD CONSTRAINT pk_referee PRIMARY KEY (referee_id);

ALTER TABLE Referees
ADD CONSTRAINT fk_referee_person FOREIGN KEY (person_id) REFERENCES People(person_id);

--Teams
ALTER TABLE Teams
ADD CONSTRAINT pk_team PRIMARY KEY (team_id);

ALTER TABLE Teams
ADD CONSTRAINT fk_team_coach FOREIGN KEY (coach_id) REFERENCES Coaches(coach_id);

ALTER TABLE Teams
ADD CONSTRAINT chk_is_active CHECK (is_active IN (0, 1));

--Matches
ALTER TABLE Matches
ADD CONSTRAINT pk_match PRIMARY KEY (match_id);

ALTER TABLE Matches
ADD CONSTRAINT fk_match_referee FOREIGN KEY (referee_id) REFERENCES Referees(referee_id);

ALTER TABLE Matches
ADD CONSTRAINT fk_match_mvp FOREIGN KEY (mvp_player_id) REFERENCES Players(player_id);

ALTER TABLE Matches
ADD CONSTRAINT chk_duration CHECK (duration > 0);

--MatchTeam
ALTER TABLE MatchTeam
ADD CONSTRAINT pk_matchteam PRIMARY KEY (match_id, team_id);

ALTER TABLE MatchTeam
ADD CONSTRAINT fk_matchteam_match FOREIGN KEY (match_id) REFERENCES Matches(match_id);

ALTER TABLE MatchTeam
ADD CONSTRAINT fk_matchteam_team FOREIGN KEY (team_id) REFERENCES Teams(team_id);

ALTER TABLE MatchTeam
ADD CONSTRAINT chk_is_home_team CHECK (is_home_team IN (0, 1));

ALTER TABLE MatchTeam
ADD CONSTRAINT chk_score CHECK (score >= 0);

--TeamPlayer
ALTER TABLE TeamPlayer
ADD CONSTRAINT pk_teamplayer PRIMARY KEY (team_id, player_id);

ALTER TABLE TeamPlayer
ADD CONSTRAINT fk_teamplayer_team FOREIGN KEY (team_id) REFERENCES Teams(team_id);

ALTER TABLE TeamPlayer
ADD CONSTRAINT fk_teamplayer_player FOREIGN KEY (player_id) REFERENCES Players(player_id);

ALTER TABLE TeamPlayer
ADD CONSTRAINT chk_is_starter CHECK (is_starter IN (0, 1));

ALTER TABLE TeamPlayer
ADD CONSTRAINT chk_teamplayer_score CHECK (score >= 0);

ALTER TABLE TeamPlayer
ADD CONSTRAINT unique_player_per_team UNIQUE (player_id, team_id);

--MatchEvent
ALTER TABLE MatchEvent
ADD CONSTRAINT pk_matchevent PRIMARY KEY (event_id);

ALTER TABLE MatchEvent
ADD CONSTRAINT fk_matchevent_match FOREIGN KEY (match_id) REFERENCES Matches(match_id);

ALTER TABLE MatchEvent
ADD CONSTRAINT fk_matchevent_player FOREIGN KEY (player_id) REFERENCES Players(player_id);

ALTER TABLE MatchEvent
ADD CONSTRAINT chk_event_time CHECK (event_time >= 0);
