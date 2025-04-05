extends CanvasLayer  # Or Control, depending on your node type

#connected to quit button
func _on_quit_pressed() -> void:
	get_tree().quit()

#connected to retry button
func _on_restart_pressed() -> void:
	get_tree().reload_current_scene()
