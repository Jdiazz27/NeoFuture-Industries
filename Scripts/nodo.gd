extends Resource
# Nodo.gd
class_name Nodo

var item: InventoryItem
var siguiente: Nodo = null

func _init(_item: InventoryItem) -> void:
	item = _item
