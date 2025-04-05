extends Node2D

func _ready():
	
	var PlatformScene = preload("res://scenes/platform.tscn")
	var platform = PlatformScene.instantiate()
	platform.position = Vector2(100, 100)
	add_child(platform)
