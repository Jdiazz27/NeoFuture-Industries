extends Area2D

class_name PickUpItem
@export var inventory_item: InventoryItem
@onready var sprite_2d: Sprite2D = $Sprite2D
@onready var collision_shape_2d: CollisionShape2D = $CollisionShape2D

@export var stacks: int = 1

func _ready() -> void:
	connect("area_entered", Callable(self, "_on_area_entered"))
	sprite_2d.texture = inventory_item.texture
	collision_shape_2d.shape = inventory_item.ground_collision_shape

func _on_area_entered(area: Area2D) -> void:
	if area.is_in_group("player"):
		queue_free()  # o lo que deba pasar al recoger la moneda
