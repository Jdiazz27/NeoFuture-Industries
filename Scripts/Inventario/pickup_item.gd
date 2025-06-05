extends Area2D

class_name PickUpItem
@onready var sprite_2d: Sprite2D = $Sprite2D
@onready var collision_shape_2d: CollisionShape2D = $CollisionShape2D
@export var stacks: int = 1
@export var oxygen_restore: int = 15
@export var inventory_item: InventoryItem

func _ready() -> void:
	connect("area_entered", Callable(self, "_on_area_entered"))
	sprite_2d.texture = inventory_item.texture
	collision_shape_2d.shape = inventory_item.ground_collision_shape

func _on_area_entered(_area: Area2D) -> void:
	var players = get_tree().get_nodes_in_group("player")
	var player = players[0]
	player.increase_oxygen(oxygen_restore)
	queue_free()
