extends Area2D
class_name HurtBox

func _ready() -> void:
	connect("area_entered", _on_area_entered)

func _on_area_entered(area: Area2D) -> void:
	if area is HitBox:
		var padre = get_parent()
		if padre.has_method("take_damage"):
			padre.take_damage(area.damage)
