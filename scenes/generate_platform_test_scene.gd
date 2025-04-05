extends Node2D

var highestPlayerPosition = 0;
var highestPlatformPostiion = 0;
var maxDiff = 20;
var createPlatform = false;

func _ready():
	for i in range(10):
		var x = randi_range(-3, 3)
		var y = randi_range(-10, 1)
		var platform = generatePlatform(x * 20, y * 10)
		add_child(platform)
	
func _process(delta: float) -> void:
	var player = get_node("Player")
	if (player.position.y < highestPlayerPosition):
		highestPlayerPosition = player.position.y
		
	if (abs(highestPlatformPostiion) - abs(highestPlayerPosition) < maxDiff):
		print("new position", highestPlayerPosition)
		spawnNewPlatform(highestPlayerPosition)
	
func generatePlatform(x: int, y: int) -> Node:
	var PlatformScene = preload("res://scenes/platform.tscn")
	var platform = PlatformScene.instantiate()
	platform.position = Vector2(x, y)
	return platform

func spawnNewPlatform(position):
	var x = randi_range(-3, 3) * 5
	var y = highestPlayerPosition - randi_range(2, 10) * 10
	highestPlatformPostiion = y;
	add_child(generatePlatform(x, y))
