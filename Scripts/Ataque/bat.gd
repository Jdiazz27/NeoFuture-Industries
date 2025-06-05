extends Node2D

@onready var collision_shape_2d: CollisionShape2D = $hit_box/CollisionShape2D

@export var damage = 20

func enable_hitbox():
	collision_shape_2d.disabled = false

func disable_hitbox():
	collision_shape_2d.disabled = true
