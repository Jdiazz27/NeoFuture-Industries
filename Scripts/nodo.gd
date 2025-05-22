# Nodo.gd
extends Resource
class_name Nodo

var item: InventoryItem
var siguiente: Nodo = null
var anterior: Nodo = null  # Opcional, si quieres doblemente enlazada
var sub_lista: ListaEnlazada = null

func _init(_item: InventoryItem) -> void:
	item = _item
