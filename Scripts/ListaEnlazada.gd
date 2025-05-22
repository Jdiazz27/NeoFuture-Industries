extends Resource
class_name ListaEnlazada

var cabeza: NodoMultiple = null

func agregar_al_final(valor) -> void:
	var nuevo = NodoMultiple.new(valor)
	if cabeza == null:
		cabeza = nuevo
		return
	var actual = cabeza
	while actual.siguiente != null:
		actual = actual.siguiente
	actual.siguiente = nuevo
	nuevo.anterior = actual

func recorrer_lista() -> Array:
	var actual = cabeza
	var resultado = []
	while actual != null:
		resultado.append(actual.valor)
		actual = actual.siguiente
	return resultado

# Agrega un hijo a un nodo existente (sublista)
func agregar_hijo(padre_valor, hijo_valor) -> ListaEnlazada:
	var padre = buscar_nodo_por_valor(padre_valor)
	if padre == null:
		push_error("Padre no encontrado")
		return null

	var nuevo_hijo = NodoMultiple.new(hijo_valor)

	if padre.sub_lista == null:
		var nueva_sublista = ListaEnlazada.new()
		nueva_sublista.cabeza = nuevo_hijo
		padre.sub_lista = nueva_sublista
		return nueva_sublista
	else:
		var actual = padre.sub_lista.cabeza
		while actual.siguiente != null:
			actual = actual.siguiente
		actual.siguiente = nuevo_hijo
		nuevo_hijo.anterior = actual
		return padre.sub_lista

func buscar_nodo_por_valor(valor_buscado) -> NodoMultiple:
	var actual = cabeza
	while actual != null:
		if actual.valor == valor_buscado:
			return actual
		actual = actual.siguiente
	return null
