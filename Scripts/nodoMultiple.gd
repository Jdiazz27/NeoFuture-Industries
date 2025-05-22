extends Resource
class_name NodoMultiple

var valor
var siguiente: NodoMultiple = null
var anterior: NodoMultiple = null
var sub_lista: ListaEnlazada = null  # Importante para la multilista
var item: InventoryItem

func _init(_valor = null, _item: InventoryItem = null) -> void:
	if _item != null:
		item = _item
	elif _valor != null:
		valor = _valor
