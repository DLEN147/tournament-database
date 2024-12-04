from net import connect
import tkinter as tk
from tkinter import ttk, messagebox

# Conexión a la base de datos
db_manager = connect.DatabaseManager(host='localhost', port=1521, user='tmt', password='tmt', service_name="XE")


class App:
    def __init__(self, root):
        self.root = root
        self.root.title("Menú Principal")
        self.root.geometry("600x400")

        self.button_frame = tk.Frame(self.root)
        self.button_frame.pack(expand=True)

        self.manage_button = tk.Button(self.button_frame, text="Gestionar", width=30, height=3,
                                       font=("Arial", 16), command=self.open_insert_window,
                                       relief="solid", bd=3, fg="black", bg="#98FB98",
                                       activebackground="#90EE90", activeforeground="black",
                                       padx=10, pady=10)
        self.manage_button.pack(pady=30)

        self.query_button = tk.Button(self.button_frame, text="Consultar", width=30, height=3,
                                      font=("Arial", 16), command=self.open_query_window,
                                      relief="solid", bd=3, fg="black", bg="#ADD8E6",
                                      activebackground="#87CEFA", activeforeground="black",
                                      padx=10, pady=10)
        self.query_button.pack(pady=30)

    def open_insert_window(self):
        insert_window = tk.Toplevel(self.root)
        insert_window.title("Seleccionar tabla")
        insert_window.geometry("400x300")
        insert_window.configure(bg="#f5f5f5")

        frame = tk.Frame(insert_window, bg="#f5f5f5")
        frame.pack(padx=10, pady=10)

        # ComboBox para seleccionar la tabla
        tables = ["People", "Players", "Coaches", "Referees", "Teams"]
        table_combobox = ttk.Combobox(frame, values=tables, state="readonly", font=("Arial", 12))
        table_combobox.grid(row=0, column=0, padx=10, pady=10)
        table_combobox.set("Selecciona una tabla")

        def update_form(event=None):
            table_name = table_combobox.get()
            if table_name:
                for widget in frame.winfo_children():
                    widget.grid_forget()

                fields = {
                    "People": [("person_id", "ID"),
                            ("first_name", "Primer nombre"),
                        ("last_name", "Apellido"),
                        ("birthdate", "Fecha de nacimiento (YYYY-MM-DD)"),
                        ("country", "País")
                    ],
                    "Players": [("player_id", "ID de jugador"),
                        ("person_id", "ID de persona"),
                        ("is_captain", "¿Es capitán? (0 o 1)")
                    ],
                    "Coaches": [("coach_id", "ID de entrenador"),
                        ("person_id", "ID de persona")
                    ],
                    "Referees": [("referee_id", "ID de juez"),
                        ("person_id", "ID de persona")
                    ],
                    "Teams": [("team_id", "ID del equipo"),
                        ("team_name", "Nombre del equipo"),
                        ("is_active", "¿Está activo? (0 o 1)"),
                        ("coach_id", "ID del entrenador")
                    ]
                }

                entries = {}
                for idx, (field, label) in enumerate(fields[table_name]):
                    tk.Label(frame, text=label, bg="#f5f5f5", font=("Arial", 12)).grid(row=idx + 1, column=0,
                                                                                       sticky="w", pady=5)
                    entry = tk.Entry(frame, font=("Arial", 12), bg="#e8f4e8", bd=2, relief="solid")
                    entry.grid(row=idx + 1, column=1, pady=5)
                    entries[field] = entry

                def insert_data():
                    values = [entry.get() for entry in entries.values()]

                    if table_name == "People":
                        query = f"""
                        INSERT INTO People (person_id, first_name, last_name, birthdate, country)
                        VALUES ('{values[0]}', '{values[1]}', '{values[2]}', TO_DATE('{values[3]}', 'YYYY-MM-DD'), '{values[4]}')
                        """
                    elif table_name == "Players":
                        query = f"""
                        INSERT INTO Players (player_id, person_id, is_captain)
                        VALUES ({values[0]}, {values[1]}, {values[2]})
                        """
                    elif table_name == "Coaches":
                        query = f"""
                        INSERT INTO Coaches (coach_id, person_id)
                        VALUES ({values[0]}, {values[1]})
                        """
                    elif table_name == "Referees":
                        query = f"""
                        INSERT INTO Referees (referee_id, person_id)
                        VALUES ({values[0]}, {values[1]})
                        """
                    elif table_name == "Teams":
                        query = f"""
                        INSERT INTO Teams (team_id, team_name, is_active, coach_id)
                        VALUES ('{values[0]}', {values[1]}, {values[2]},{values[3]})
                        """

                    try:
                        db_manager.execute_query(query)
                        messagebox.showinfo("Éxito", f"Los datos se han insertado correctamente en {table_name}.")
                        insert_window.destroy()
                    except Exception as e:
                        messagebox.showerror("Error", f"Ocurrió un error al insertar los datos: {e}")

                tk.Button(frame, text="Insertar", command=insert_data, font=("Arial", 14), bg="#4CAF50", fg="black",
                          activebackground="#45a049", relief="solid", bd=3, padx=10, pady=10).grid(
                    row=len(fields[table_name]) + 1, column=0, columnspan=2, pady=20)

        table_combobox.bind("<<ComboboxSelected>>", update_form)

        tk.Button(insert_window, text="Cerrar", command=insert_window.destroy, font=("Arial", 14), bg="#f44336",
                  fg="black", activebackground="black", relief="solid", bd=3, padx=10, pady=10).pack(pady=10)

    def open_query_window(self):
        self.clear_window()
        self.create_query_buttons()

    def create_query_buttons(self):
        button_frame = tk.Frame(self.root)
        button_frame.pack(expand=True)

        back_button = tk.Button(button_frame, text="Volver", width=20, height=2, font=("Arial", 14),
                                command=self.return_to_main, relief="solid", bd=3, fg="black",
                                bg="#FFB6C1", activebackground="#FF69B4", activeforeground="black",
                                padx=10, pady=10)
        back_button.pack(side="top", anchor="w", padx=10, pady=10)

        # Botones para las consultas (con tamaño reducido)
        button1 = tk.Button(button_frame, text="Ranking de Jugadores", width=20, height=2, font=("Arial", 14),
                            command=lambda: self.show_query_result("ranking_players"), relief="solid", bd=3,
                            fg="black", bg="#ADD8E6", activebackground="#87CEFA", activeforeground="black",
                            padx=10, pady=10)
        button1.pack(pady=20)

        button2 = tk.Button(button_frame, text="Equipos", width=20, height=2, font=("Arial", 14),
                            command=lambda: self.show_query_result("teams"), relief="solid", bd=3,
                            fg="black", bg="#ADD8E6", activebackground="#87CEFA", activeforeground="black",
                            padx=10, pady=10)
        button2.pack(pady=20)

        button3 = tk.Button(button_frame, text="Partidos", width=20, height=2, font=("Arial", 14),
                            command=lambda: self.show_query_result("matches"), relief="solid", bd=3,
                            fg="black", bg="#ADD8E6", activebackground="#87CEFA", activeforeground="black",
                            padx=10, pady=10)
        button3.pack(pady=20)

        button4 = tk.Button(button_frame, text="Último MVP", width=20, height=2, font=("Arial", 14),
                            command=lambda: self.show_query_result("last_mvp"), relief="solid", bd=3,
                            fg="black", bg="#ADD8E6", activebackground="#87CEFA", activeforeground="black",
                            padx=10, pady=10)
        button4.pack(pady=20)

        button5 = tk.Button(button_frame, text="Últimos Partidos", width=20, height=2, font=("Arial", 14),
                            command=lambda: self.show_query_result("last_round_matches"), relief="solid", bd=3,
                            fg="black", bg="#ADD8E6", activebackground="#87CEFA", activeforeground="black",
                            padx=10, pady=10)
        button5.pack(pady=20)

        button6 = tk.Button(button_frame, text="Ranking de Equipos", width=20, height=2, font=("Arial", 14),
                            command=lambda: self.show_query_result("team_ranking"), relief="solid", bd=3,
                            fg="black", bg="#ADD8E6", activebackground="#87CEFA", activeforeground="black",
                            padx=10, pady=10)
        button6.pack(pady=20)

    def show_query_result(self, query_name):
        if query_name == "ranking_players":
            query = connect.ranking_players()
        elif query_name == "teams":
            query = connect.teams()
        elif query_name == "matches":
            query = connect.matches()
        elif query_name == "last_mvp":
            query = connect.last_mvp()
        elif query_name == "last_round_matches":
            query = connect.last_round_matches()
        elif query_name == "team_ranking":
            query = connect.team_ranking()

        columns, rows = db_manager.execute_query(query)

        self.clear_window()

        result_frame = tk.Frame(self.root)
        result_frame.pack(pady=20)

        tree = ttk.Treeview(result_frame, columns=columns, show="headings")

        for col in columns:
            tree.heading(col, text=col)
            tree.column(col, width=100)

        for row in rows:
            tree.insert("", "end", values=row)

        tree.pack(padx=20, pady=20)

        back_button = tk.Button(result_frame, text="Volver", width=20, height=2, font=("Arial", 14),
                                command=self.open_query_window,
                                relief="solid", bd=3, fg="black", bg="#FFB6C1", activebackground="#FF69B4",
                                activeforeground="black",
                                padx=10, pady=10)
        back_button.pack(side="top", anchor="w", padx=10, pady=10)

    def return_to_main(self):
        self.clear_window()
        self.__init__(self.root)

    def clear_window(self):
        for widget in self.root.winfo_children():
            widget.destroy()

    def close(self):
        db_manager.close_connection()
        self.root.quit()


root = tk.Tk()
app = App(root)
root.mainloop()
