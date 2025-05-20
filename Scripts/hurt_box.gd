class_name hurt_box
extends Area2D

func _init() -> void:
	collision_layer = 0
	collision_mask = 2

func _ready() -> void:
	connect("area_entered", _on_area_entered)

func _on_area_entered(area: Area2D) -> void:
	if area is hit_box:
		var padre = get_parent()
		if padre.has_method("take_damage"):
			padre.take_damage(area.damage)
