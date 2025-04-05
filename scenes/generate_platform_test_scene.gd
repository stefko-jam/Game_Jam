extends Node2D

var hightestPlayerPosition = 0;

func _ready():
	for i in range(10):
		var x = randi_range(-3, 3)
		var y = randi_range(-10, 1)
		var platform = generatePlatform(x * 100, y * 20)
		add_child(platform)
	
func _process(delta: float) -> void:
	var player = get_node("Player")
	if (player.position.y < hightestPlayerPosition):
		print("new position", hightestPlayerPosition)
		hightestPlayerPosition = player.position.y
		spawnNewPlatform(hightestPlayerPosition)
	
func generatePlatform(x: int, y: int) -> Node:
	var PlatformScene = preload("res://scenes/platform.tscn")
	var platform = PlatformScene.instantiate()
	platform.position = Vector2(x, y)
	return platform

func spawnNewPlatform(position):
	var x = randi_range(-3, 3) * 10
	var y = hightestPlayerPosition - randi_range(0, 10) * 10
	add_child(generatePlatform(x, y))
