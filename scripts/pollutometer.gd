extends Node2D

@export var frame: int

func _ready():
	update_position()
	$AnimatedSprite2D.frame = frame

func _process(delta: float) -> void:
	update_position()
	$AnimatedSprite2D.frame = frame

func update_position():
	var viewport_size = get_viewport_rect().size
	position.y = 0  # Top of the screen
	position.x = viewport_size.x / 2  # Optional: center it horizontally
