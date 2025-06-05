extends Node2D

@export var hp: int = 100

@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D

func take_damage(dmg: int):
	hp -= dmg
	animated_sprite_2d.play("hit")

func die():
	animated_sprite_2d.play("die")
	await animated_sprite_2d.animation_finished
	queue_free()
