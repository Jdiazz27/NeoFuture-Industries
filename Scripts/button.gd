extends Button

func _ready():
	self.pressed.connect(on_button_pressed)

func on_button_pressed():
	get_tree().change_scene_to_file("res://Scenes/niveles/start.tscn")
