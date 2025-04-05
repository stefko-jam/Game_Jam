extends Control

@onready var restart_button: Button = $HBoxContainer/RestartButton
@onready var quit_button: Button = $HBoxContainer/QuitButton


func _ready():
	visible = false  # hide the game over menu on start
	restart_button.pressed.connect(_on_restart_pressed)
	quit_button.pressed.connect(_on_quit_pressed)

#connected to quit button
func _on_quit_pressed() -> void:
	get_tree().quit()

#connected to retry button
func _on_restart_pressed() -> void:
	get_tree().reload_current_scene()
