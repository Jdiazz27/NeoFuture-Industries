extends Node2D

func _input(event):
	if event is InputEventKey and event.pressed and event.keycode == KEY_ESCAPE:
		if DisplayServer.window_get_mode() == DisplayServer.WINDOW_MODE_FULLSCREEN:
			# Cambiar a modo ventana
			DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED)
			# Ajustar tamaño de la ventana (por ejemplo, 800x600)
			DisplayServer.window_set_size(Vector2i(1000, 700))
			
var ListaEnlazada = preload("res://Scripts/ListaEnlazada.gd")
var nodo = preload("res://Scripts/nodoMultiple.gd")
var partida = ListaEnlazada.new()

var monedas_list: ListaEnlazada
var enemigos_list: ListaEnlazada
var basura_list: ListaEnlazada
var puntaje_list: ListaEnlazada

var nMonedas = 0
var nEnemigos = 0
var nBasura = 0

func _ready():
	var monedas = nodo.new("Monedas")
	var enemigos = nodo.new("Enemigos")
	var basura = nodo.new("Basura")
	var puntaje = nodo.new("Puntaje")

	partida.agregar_al_final(monedas)
	partida.agregar_al_final(enemigos)
	partida.agregar_al_final(basura)
	partida.agregar_al_final(puntaje)
	
	monedas_list = ListaEnlazada.new()
	enemigos_list = ListaEnlazada.new()
	basura_list = ListaEnlazada.new()
	puntaje_list = ListaEnlazada.new()

	partida.agregar_hijo(monedas, monedas_list)
	partida.agregar_hijo(enemigos, enemigos_list)
	partida.agregar_hijo(basura, basura_list)
	partida.agregar_hijo(puntaje, puntaje_list)

func add(list:String, data:String):
	if data == "moneda":
		data = data + str(nMonedas)
		nMonedas = nMonedas + 1
	elif data == "enemigo":
		data = data + str(nEnemigos)
		nEnemigos = nEnemigos + 1
	elif data == "basura":
		data = data + str(nBasura)
		nBasura = nBasura + 1
		
	var new_node = nodo.new(data)
	match list:
		"monedas_list":
			monedas_list.agregar_al_final(new_node)
		"enemigos_list":
			enemigos_list.agregar_al_final(new_node)
		"basura_list":
			basura_list.agregar_al_final(new_node)
		"puntaje_list":
			puntaje_list.agregar_al_final(new_node)

func getData():
	var puntaje = (nEnemigos * 50) + (nMonedas * 25)
	return [puntaje, nEnemigos, nMonedas, nBasura]
