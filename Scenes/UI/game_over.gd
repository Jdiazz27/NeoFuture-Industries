extends Control

func _input(event):
	if event is InputEventKey and event.pressed and event.keycode == KEY_ESCAPE:
		if DisplayServer.window_get_mode() == DisplayServer.WINDOW_MODE_FULLSCREEN:
			# Cambiar a modo ventana
			DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED)
			# Ajustar tamaño de la ventana (por ejemplo, 800x600)
			DisplayServer.window_set_size(Vector2i(800, 600))
