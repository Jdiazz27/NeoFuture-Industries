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

	# Crear archivo si no existe, con encabezado
	if not FileAccess.file_exists(ruta_csv):
		var archivo_nuevo := FileAccess.open(ruta_csv, FileAccess.WRITE)
		if archivo_nuevo:
			archivo_nuevo.store_line("Usuario,Contraseña")
			archivo_nuevo.close()

	# Verificar si el usuario ya existe
	var archivo := FileAccess.open(ruta_csv, FileAccess.READ)
	if archivo == null:
		print("No se pudo abrir el archivo.")
		return

	archivo.get_line()  # Saltar encabezado
	while not archivo.eof_reached():
		var linea = archivo.get_line()
		var datos = linea.strip_edges().split(",")
		if datos.size() >= 1 and datos[0] == usuario:
			print("El usuario ya está registrado.")
			archivo.close()
			return
	archivo.close()

	# Registrar nuevo usuario
	var nueva_linea = usuario + "," + contrasena
	self.agregar_linea_csv(ruta_csv, nueva_linea)

	print("Registro exitoso.")
	get_tree().change_scene_to_file("res://Scenes/niveles/start.tscn")

func agregar_linea_csv(ruta: String, nueva_linea: String) -> void:
	var contenido := ""

	# Si el archivo ya existe, leer su contenido
	if FileAccess.file_exists(ruta):
		var archivo_lectura := FileAccess.open(ruta, FileAccess.READ)
		if archivo_lectura:
			contenido = archivo_lectura.get_as_text()
			archivo_lectura.close()

	# Agregar la nueva línea
	contenido += nueva_linea + "\n"

	# Reescribir todo el contenido, incluida la nueva línea
	var archivo_escritura := FileAccess.open(ruta, FileAccess.WRITE)
	if archivo_escritura:
		archivo_escritura.store_string(contenido)
		archivo_escritura.close()
