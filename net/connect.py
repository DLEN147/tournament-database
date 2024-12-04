import oracledb


class DatabaseManager:
    def __init__(self, user, password, host, port, service_name):
        self.dsn = oracledb.makedsn(host, port, service_name=service_name)
        try:
            self.connection = oracledb.connect(user=user, password=password, dsn=self.dsn)
            print("Conexión exitosa.")
        except oracledb.Error as e:
            print("Error de conexión", f"Hubo un error al conectar a la base de datos: {e}")
            raise

    def execute_query(self, query, params=None):
        try:
            with self.connection.cursor() as cursor:
                if params:
                    cursor.execute(query, params)
                else:
                    cursor.execute(query)
                if query.strip().upper().startswith("SELECT"):
                    # Obtener los nombres de las columnas
                    columns = [desc[0] for desc in cursor.description]
                    # Obtener los resultados de la consulta
                    rows = cursor.fetchall()
                    return columns, rows
                self.connection.commit()
                return []
        except Exception as e:
            print("Error al ejecutar consulta", f"Error: {e}")
            return []

    def close_connection(self):
        if self.connection:
            self.connection.close()
            print("Conexión cerrada.")


def ranking_players():
    return """
        SELECT p.first_name || ' ' || p.last_name AS player_name, 
               SUM(tp.score) AS total_score
        FROM Players pl
        JOIN TeamPlayer tp ON pl.player_id = tp.player_id
        JOIN People p ON pl.person_id = p.person_id
        GROUP BY p.first_name, p.last_name
        ORDER BY total_score DESC
    """


def teams():
    return """
    SELECT team_id, team_name AS team_name, 
           CASE WHEN is_active = 1 THEN 'Activo' ELSE 'Inactivo' END AS status
    FROM Teams
    ORDER BY team_name
    """


def matches():
    return """
    SELECT m.match_id, m.match_date, m.round, 
           home_team.team_name AS home_team, 
           away_team.team_name AS away_team,
           mt_home.score AS home_score,
           mt_away.score AS away_score
    FROM Matches m
    JOIN MatchTeam mt_home ON m.match_id = mt_home.match_id AND mt_home.is_home_team = 1
    JOIN Teams home_team ON mt_home.team_id = home_team.team_id
    JOIN MatchTeam mt_away ON m.match_id = mt_away.match_id AND mt_away.is_home_team = 0
    JOIN Teams away_team ON mt_away.team_id = away_team.team_id
    ORDER BY m.match_date DESC
    """


def last_mvp():
    return """
    SELECT p.first_name || ' ' || p.last_name AS player_name, 
           m.match_date
    FROM Matches m
    JOIN Players pl ON m.mvp_player_id = pl.player_id
    JOIN People p ON pl.person_id = p.person_id
    WHERE m.match_date = (SELECT MAX(match_date) FROM Matches)
    FETCH FIRST 1 ROWS ONLY
    """


def last_round_matches():
    return """
    SELECT m.match_id, m.match_date, m.round, 
           home_team.team_name AS home_team, 
           away_team.team_name AS away_team,
           mt_home.score AS home_score,
           mt_away.score AS away_score
    FROM Matches m
    JOIN MatchTeam mt_home ON m.match_id = mt_home.match_id AND mt_home.is_home_team = 1
    JOIN Teams home_team ON mt_home.team_id = home_team.team_id
    JOIN MatchTeam mt_away ON m.match_id = mt_away.match_id AND mt_away.is_home_team = 0
    JOIN Teams away_team ON mt_away.team_id = away_team.team_id
    WHERE m.round = (SELECT MAX(round) FROM Matches)
    ORDER BY m.match_date DESC
    """


def team_ranking():
    return """
    SELECT t.team_name AS team_name, 
           ROUND(AVG(tp.score), 2) AS average_score
    FROM Teams t
    JOIN TeamPlayer tp ON t.team_id = tp.team_id
    GROUP BY t.team_name
    ORDER BY average_score DESC
    """
