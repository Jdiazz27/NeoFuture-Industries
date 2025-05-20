extends Node2D

@onready var beast_sprite_2d: AnimatedSprite2D = $beastSprite2D

func take_damage(amount: int) -> void:
	beast_sprite_2d.play_animation("hurt")
