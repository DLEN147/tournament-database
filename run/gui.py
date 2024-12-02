import tkinter as tk
from tkinter import messagebox, ttk
from net import connect


def show_results(title, query_function):
    try:
        query = query_function()
        results = db_manager.execute_query(query)

        result_window = tk.Toplevel(root)
        result_window.title(title)
        result_window.geometry("600x400")

        tree = ttk.Treeview(result_window, show="headings")
        tree.pack(expand=True, fill=tk.BOTH)

        if results:
            columns = [f"Columna {i + 1}" for i in range(len(results[0]))]
            tree["columns"] = columns
            for col in columns:
                tree.heading(col, text=col)
                tree.column(col, anchor="center", width=100)

            for row in results:
                tree.insert("", tk.END, values=row)
        else:
            messagebox.showinfo("Sin Resultados", "La consulta no devolvió resultados.")
    except Exception as e:
        messagebox.showerror("Error", f"No se pudo ejecutar la consulta:\n{str(e)}")


def open_query_interface():
    query_window = tk.Toplevel(root)
    query_window.title("Consultas")
    query_window.geometry("400x300")

    buttons = [
        ("Ranking de Jugadores", connect.ranking_players),
        ("Equipos", connect.teams),
        ("Encuentros", connect.matches),
        ("Último MVP", connect.last_mvp),
        ("Encuentros Última Ronda", connect.last_round_matches),
        ("Ranking de Equipos", connect.team_ranking),
    ]

    for text, query_func in buttons:
        btn = tk.Button(query_window, text=text, command=lambda q=query_func: show_results(text, q), width=30)
        btn.pack(pady=5)


def open_manage_interface():
    manage_window = tk.Toplevel(root)
    manage_window.title("Gestión de Datos")
    manage_window.geometry("400x300")

    tk.Label(manage_window, text="Especifica la tabla en la que deseas insertar datos:").pack(pady=10)
    table_name_entry = tk.Entry(manage_window, width=30)
    table_name_entry.pack(pady=5)

    tk.Label(manage_window, text="Inserta los valores (separados por comas):").pack(pady=10)
    values_entry = tk.Entry(manage_window, width=50)
    values_entry.pack(pady=5)

    def insert_data():
        table_name = table_name_entry.get().strip()
        values = values_entry.get().strip()
        if not table_name or not values:
            messagebox.showerror("Error", "Todos los campos son obligatorios.")
            return


        values_list = [v.strip() for v in values.split(",")]

        try:
            placeholders = ", ".join([":" + str(i + 1) for i in range(len(values_list))])
            query = f"INSERT INTO {table_name} VALUES ({placeholders})"

            db_manager.execute_query(query, values_list)
            messagebox.showinfo("Éxito", "Datos insertados correctamente.")
        except Exception as e:
            messagebox.showerror("Error", f"No se pudo insertar:\n{str(e)}")

    insert_button = tk.Button(manage_window, text="Insertar Datos", command=insert_data, width=20)
    insert_button.pack(pady=20)


# Conectar a la base de datos
try:
    db_manager = connect.DatabaseManager(user="TMT", password="tmt", host="localhost", port=1521, service_name="XE")
except Exception as e:
    messagebox.showerror("Error de Conexión", f"No se pudo conectar a la base de datos:\n{str(e)}")
    exit()

# Interfaz Principal
root = tk.Tk()
root.title("Gestión de Torneos de Videojuegos")
root.geometry("400x300")

# Botones principales
btn_consultar = tk.Button(root, text="Consultar", command=open_query_interface, width=30, height=2)
btn_consultar.pack(pady=20)

btn_gestionar = tk.Button(root, text="Gestionar", command=open_manage_interface, width=30, height=2)
btn_gestionar.pack(pady=20)

# Iniciar la interfaz
root.mainloop()
