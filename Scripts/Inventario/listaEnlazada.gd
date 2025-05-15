# ListaEnlazada.gd
class_name ListaEnlazada
extends Resource

var cabeza: Nodo = null

func agregar_al_inicio(item: InventoryItem) -> void:
	var nuevo = Nodo.new(item)
	nuevo.siguiente = cabeza
	cabeza = nuevo

func agregar_al_final(item: InventoryItem) -> void:
	var nuevo = Nodo.new(item)
	if cabeza == null:
		cabeza = nuevo
		return
	var actual = cabeza
	while actual.siguiente != null:
		actual = actual.siguiente
	actual.siguiente = nuevo

func recorrer_lista() -> Array:
	var actual = cabeza
	var items = []
	while actual != null:
		items.append(actual.item)
		actual = actual.siguiente
	return items
