extends Node2D

@export var frame: int

func _ready():
	$AnimatedSprite2D.frame = frame

func _process(delta: float) -> void:
	$AnimatedSprite2D.frame = frame
	#position.y -= delta
