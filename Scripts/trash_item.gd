extends Area2D

class_name TrashItem
@export var trash_sprites: Array[Texture2D]
@onready var sprite: Sprite2D = $Sprite2D
@onready var collision_shape_2d: CollisionShape2D = $CollisionShape2D
@export var stacks: int = 1
@export var oxygen_restore: int = 15

func _ready() -> void:
	if trash_sprites.is_empty():
		push_error("No hay sprites definidos en trash_sprites.")
		return

	sprite.texture = trash_sprites.pick_random()
	connect("area_entered", Callable(self, "_on_area_entered"))

func _on_area_entered(_area: Area2D) -> void:
	queue_free()
