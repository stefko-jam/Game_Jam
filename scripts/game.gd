extends Node2D

@onready var player = $Player

func _ready():
	pass  # No pause menu to hide or configure

func _unhandled_input(event):
	if event.is_action_pressed("ui_cancel"):
		print("Pause menu is currently disabled.")

func enable_player_input():
	player.enable_input()  # ❌ This is incorrect
