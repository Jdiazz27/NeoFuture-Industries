extends Node

class_name Inventory

@onready var inventory_ui: InventoryUI = $"../InventoryUI"
@onready var on_screen_ui: OnScreenUI = $"../OnScreenUI"
#@onready var combat_system: CombatSystem = $"../CombatSystem"
@onready var animated_sprite_2d: AnimationController = $"../AnimatedSprite2D"
var ListaEnlazada = preload("res://Scripts/ListaEnlazada.gd")

const PICKUP_ITEM_SCENE = preload("res://Scenes/pickup_item.tscn")
# items currently in inventory
@export var items = ListaEnlazada.new()

var taken_inventory_slots_count = 0

func _ready() -> void:
	inventory_ui.equip_item.connect(on_item_equipped)
	inventory_ui.drop_item_on_the_ground.connect(on_item_dropped)
	# No conectar spell_slot_clicked porque ya no existe

func _input(_event: InputEvent) -> void:
	if Input.is_action_just_pressed("toggle_inventory"):
		inventory_ui.toggle()

func add_item(item: InventoryItem, stacks: int):
	if stacks && item.max_stacks > 1:
		add_stackable_item_to_inventory(item, stacks)
	else:
		items.agregar_al_final(item)
		inventory_ui.add_item(item)
 
func add_stackable_item_to_inventory(item: InventoryItem, stacks: int):
	var actual = items.cabeza
	var encontrado = false
	
	while actual != null:
		if actual.item != null and actual.item.name == item.name:
			encontrado = true
		# Verifica si hay espacio en la pila actual
			if actual.item.stacks + stacks <= item.max_stacks:
				actual.item.stacks += stacks
				# Actualiza la UI aquí si tienes un índice o referencia al slot
			else:
				var stacks_diff = actual.item.stacks + stacks - item.max_stacks
				actual.item.stacks = item.max_stacks
				var nuevo_item = item.duplicate(true)
				nuevo_item.stacks = stacks_diff
				items.agregar_al_final(nuevo_item)
				inventory_ui.add_item(nuevo_item)
			break
		actual = actual.siguiente
	
	if not encontrado:
		item.stacks = stacks
		items.agregar_al_final(item)
		inventory_ui.add_item(item)

func on_item_equipped(idx: int, slot_to_equip: String):
	var item_to_equip = get_item_at_index(idx)
	if item_to_equip == null:
		return
	on_screen_ui.equip_item(item_to_equip, slot_to_equip)
	#combat_system.set_active_weapon(item_to_equip.weapon_item, slot_to_equip)

func on_item_dropped(idx: int):
	var item_to_drop = get_item_at_index(idx)
	if item_to_drop == null:
		return
	clear_inventory_slot(idx)
	eject_item_into_the_ground(idx)

func clear_inventory_slot(idx: int):
	taken_inventory_slots_count -= 1
	inventory_ui.clear_slot_at_index(idx)
	set_item_at_index(idx, null)

func eject_item_into_the_ground(idx: int):
	var inventory_item_to_eject = get_item_at_index(idx)
	if inventory_item_to_eject == null:
		return
	
	var item_to_eject_as_pickup = PICKUP_ITEM_SCENE.instantiate() as PickUpItem
	item_to_eject_as_pickup.inventory_item = inventory_item_to_eject
	item_to_eject_as_pickup.stacks = inventory_item_to_eject.stacks
	
	get_tree().root.add_child(item_to_eject_as_pickup)
	item_to_eject_as_pickup.disable_collision()
	item_to_eject_as_pickup.global_position = get_parent().global_position
	
	var eject_direction = animated_sprite_2d.item_eject_direction
	if eject_direction.x == 0:
		eject_direction.x = randf_range(-1, 1)
	else:
		eject_direction.y = randf_range(-1, 1)
	
	var eject_position = get_parent().global_position + Vector2(20, 20) * eject_direction
	var ejection_tween = get_tree().create_tween()
	ejection_tween.set_trans(Tween.TRANS_BOUNCE)
	ejection_tween.tween_property(item_to_eject_as_pickup, "global_position", eject_position, 0.2)
	ejection_tween.finished.connect(func(): item_to_eject_as_pickup.enable_collision())
	
	#if combat_system.right_weapon == inventory_item_to_eject.weapon_item:
		#combat_system.right_weapon = null
		#on_screen_ui.right_hand_slot.set_equipment_texture(null)
	#
	#if combat_system.left_weapon == inventory_item_to_eject.weapon_item:
		#combat_system.left_weapon = null
		#on_screen_ui.left_hand_slot.set_equipment_texture(null)

# Devuelve el ítem en la posición idx (0 basado)
func get_item_at_index(idx: int) -> InventoryItem:
	var actual = items.cabeza
	var contador = 0
	while actual != null:
		if contador == idx:
			return actual.item
		contador += 1
		actual = actual.siguiente
	return null

# Cambia el ítem en la posición idx
func set_item_at_index(idx: int, new_item: InventoryItem) -> void:
	var actual = items.cabeza
	var contador = 0
	while actual != null:
		if contador == idx:
			actual.item = new_item
			return
		contador += 1
		actual = actual.siguiente
