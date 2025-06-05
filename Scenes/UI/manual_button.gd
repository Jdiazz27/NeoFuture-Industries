extends Button

@onready var panel = get_parent().get_node("botonpanel")  

func _pressed():
	panel.visible = not panel.visible
