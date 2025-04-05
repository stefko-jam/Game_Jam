extends Node2D

var highestPlayerPosition = 0;
var highestPlatformPostiion = 200;
var maxDiff = 200;
var createPlatform = false;

# LIFECYCLE HOOKS
func _ready():
	initializePlatforms()

func _process(delta: float) -> void:
	updateHighestPlayerPosition()
	if shouldGeneratePlatform():
		spawnNewPlatform()

# CUSTOM METHODS
func initializePlatforms():
	for i in range(10):
		spawnNewPlatform()

func updateHighestPlayerPosition():
	var player = get_node("Player")
	if (player.position.y < highestPlayerPosition):
		highestPlayerPosition = player.position.y

func shouldGeneratePlatform():
	return abs(highestPlatformPostiion) - abs(highestPlayerPosition) < maxDiff
	
func generatePlatform(x: int, y: int) -> Node:
	print()
	
	var sceneType = randi_range(0, 1)
	var platformBase = preload("res://scenes/platform.tscn")
	var platformMoving = preload("res://scenes/platform_moving.tscn")
	var platform;
	if sceneType == 0:
		platform = platformBase
	if sceneType == 1:
		platform = platformMoving;
	var instance = platform.instantiate()
	instance.position = Vector2(x, y)
	return instance

func spawnNewPlatform():
	var x = randi_range(-100, 100)
	var y = highestPlatformPostiion - randi_range(2, 10) * 10
	highestPlatformPostiion = y;
	add_child(generatePlatform(x, y))
