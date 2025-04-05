extends Camera2D

var highest_y := 0.0
var fixed_x := 0.0

func _ready():
	highest_y = global_position.y
	fixed_x = global_position.x  # Lock the initial horizontal position

func _physics_process(_delta):
	if get_parent().global_position.y < highest_y:
		highest_y = get_parent().global_position.y

	global_position.y = highest_y
	global_position.x = fixed_x  # Prevent the camera from moving sideways
