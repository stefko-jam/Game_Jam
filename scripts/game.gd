extends Node2D

@onready var player = $Player

func _ready():
	HighscoreManager.set_player_reference(player)

func _unhandled_input(event):
	if event.is_action_pressed("ui_cancel"):
		print("Pause menu is currently disabled.")

func enable_player_input():
	player.enable_input()
