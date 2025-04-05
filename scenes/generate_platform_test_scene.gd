extends Node2D

func _ready():
	for i in range(10):
		var x = randi_range(-3, 3)
		var y = randi_range(-10, 1)
		var platform = generatePlatform(x * 100, y * 20)
		add_child(platform)
	
	
func generatePlatform(x: int, y: int) -> Node:
	var PlatformScene = preload("res://scenes/platform.tscn")
	var platform = PlatformScene.instantiate()
	platform.position = Vector2(x, y)
	return platform
	
