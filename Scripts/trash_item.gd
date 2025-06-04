extends Area2D

@export var trash_sprites: Array[Texture2D]
@onready var sprite: Sprite2D = $Sprite2D

func _ready():
	if trash_sprites.is_empty():
		push_error("No hay sprites definidos en trash_sprites.")
		return

	sprite.texture = trash_sprites.pick_random()
