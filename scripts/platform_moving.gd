extends Node2D

@export var move_distance: float = 100
@export var move_speed: float = 60

var direction := 1
var start_x := 0.0

func _ready():
	start_x = position.x 
	if (randf() > 0.5):
		direction = -1

func _physics_process(delta: float) -> void:
	updatePosition(delta);
	handleDirectionChange();
	
func updatePosition(delta):
	position.x += direction * move_speed * delta;
	
func handleDirectionChange():
	if position.x > start_x + move_distance:
		direction = -1
	elif position.x < start_x - move_distance:
		direction = 1
