extends Node2D

var highestPlayerPosition = 0
var highestPlatformPostiion = 200
var maxDiff = 200
var createPlatform = false
var createMovingTiles = false

# LIFECYCLE HOOKS
func _ready():
	initializePlatforms()
	await get_tree().create_timer(5.0).timeout
	createMovingTiles = true

func _process(delta: float) -> void:
	updateHighestPlayerPosition()
	if shouldGeneratePlatform():
		spawnNewPlatform()

# CUSTOM METHODS
func initializePlatforms():
	for i in range(10):
		spawnNewPlatform()

func updateHighestPlayerPosition():
	#var game = get_tree().get_root().find_node("Platforms", true, false)
	#if game:
		var player = get_parent().get_node("Player")
		if player and player.position.y < highestPlayerPosition:
			highestPlayerPosition = player.position.y

func shouldGeneratePlatform():
	return abs(highestPlatformPostiion) - abs(highestPlayerPosition) < maxDiff

func generatePlatform(x: int, y: int) -> Node:
	var sceneType = randi_range(0, 1 if createMovingTiles else 0)
	var platformBase = preload("res://scenes/platform.tscn")
	var platformMoving = preload("res://scenes/platform_moving.tscn")
	var platform
	if sceneType == 0:
		platform = platformBase
	if sceneType == 1:
		platform = platformMoving
	var instance = platform.instantiate()
	instance.position = Vector2(x, y)
	return instance

func spawnNewPlatform():
	var x = randi_range(-100, 100)
	var y = highestPlatformPostiion - randi_range(2, 10) * 5
	highestPlatformPostiion = y;
	var platform = generatePlatform(x, y)

	var createCoin = randi_range(0, 3) == 1;
	if (createCoin):
		var coinScene = preload("res://scenes/coin.tscn")
		var negativeCoinScene = preload("res://scenes/negative_coin.tscn")
		var coin;
		if (randi_range(0, 1) == 1):
			coin = coinScene.instantiate()
		else:
			coin = negativeCoinScene.instantiate()
		
		#randi_range(0, 1) == 1 if coinScene.instantiate() else negativeCoinScene.instantiate();
		coin.position = Vector2(0, -10)
		coin.coin_type = randi_range(0, 1)
		coin.game_manager = %GameManager
		platform.add_child(coin)
		
	add_child(platform)
	
