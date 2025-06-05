extends Node
class_name Datos

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
		
func crear_csv(ruta: String):
	var archivo := FileAccess.open(ruta, FileAccess.WRITE)
	if archivo:
		archivo.store_line("Partida,puntos,enemigos,oxigeno,basura")
		archivo.close()

func buscarUltimaPartida() -> int:
	var archivo := FileAccess.open("res://Archivos/datos.csv", FileAccess.READ)
	if archivo == null:
		push_error("No se pudo abrir el archivo.")
	
	# Saltar el encabezado
	if not archivo.eof_reached():
		archivo.get_line()  # Ignorar primera línea

	var ultima_linea = ""
	while not archivo.eof_reached():
		ultima_linea = archivo.get_line()
	archivo.close()

	var partes = ultima_linea.split(",")
	if partes.size() > 0 and partes[0].is_valid_int():
		return int(partes[0]) + 1
	return 1
