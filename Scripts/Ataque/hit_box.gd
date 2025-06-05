extends Area2D

var damage = 0

func _ready():
	collision_layer = 2
	collision_mask = 0

	var parent = get_parent()
	damage = parent.damage
