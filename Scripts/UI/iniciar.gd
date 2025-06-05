extends Button

@onready var userdata = get_parent().get_node("userdata")
@onready var passdata = get_parent().get_node("passdata")

var ruta_csv = "res://Archivos/usuarios.csv"

func _on_pressed() -> void:
	var usuario = userdata.text.strip_edges()
	var contrasena = passdata.text.strip_edges()

	if usuario == "" or contrasena == "":
		print("Por favor, completa ambos campos.")
		return

	if not FileAccess.file_exists(ruta_csv):
		print("No hay usuarios registrados.")
		return

	var archivo := FileAccess.open(ruta_csv, FileAccess.READ)
	if archivo == null:
		print("No se pudo abrir el archivo.")
		return

	# Leer encabezado
	archivo.get_line()

	var inicio_exitoso = false
	while not archivo.eof_reached():
		var linea = archivo.get_line()
		var datos = linea.strip_edges().split(",")

		if datos.size() >= 2 and datos[0] == usuario and datos[1] == contrasena:
			inicio_exitoso = true
			break

	archivo.close()

	if inicio_exitoso:
		get_tree().change_scene_to_file("res://Scenes/start.tscn")
