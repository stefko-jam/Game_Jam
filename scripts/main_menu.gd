extends Control

@onready var start_button = $VBoxContainer/StartButton
@onready var quit_button = $VBoxContainer/QuitButton

func _ready():
	start_button.pressed.connect(_on_start_pressed)
	quit_button.pressed.connect(_on_quit_pressed)

func _on_start_pressed():
	hide()
	get_tree().root.get_node("Game").enable_player_input()
	

func _on_quit_pressed():
	get_tree().quit()
