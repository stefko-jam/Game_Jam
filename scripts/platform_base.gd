extends Node2D

@export var isGoodTile: bool;

func _ready():
	var isGoodTile = randi_range(0, 1) == 1
	#var sprite = get_node("Sprite2D")
	if (isGoodTile):
		#sprite.region_rect = Rect2(15.7627, 47.3772, 32.4829, 10.3594)
		#Rect2(16.7261, 0.334061, 30.8097, 9.47992)
		$Sprite2D.region_rect = Rect2(16.5945, 15.7389, 31.2048, 10.4016)
	
