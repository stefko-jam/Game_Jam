extends CharacterBody2D

const SPEED = 300.0
const JUMP_VELOCITY = -500.0

@onready var camera: Camera2D = $Camera2D

var screen_half_width := 0.0

func _ready():
	await get_tree().process_frame  # Wait for viewport to be ready

	# Get actual screen width in world units (important!)
	screen_half_width = get_viewport().get_visible_rect().size.x * camera.zoom.x * 0.5

func _physics_process(delta: float) -> void:
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta

	# Handle jump.
	if is_on_floor():
		velocity.y = JUMP_VELOCITY

	# Handle horizontal movement
	var direction := Input.get_axis("left", "right")
	if direction:
		velocity.x = direction * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)

	move_and_slide()

	handle_horizontal_wrap()


func handle_horizontal_wrap():
	var cam_x = camera.global_position.x
	var player_x = global_position.x
	var left_edge = cam_x - screen_half_width
	var right_edge = cam_x + screen_half_width

	if player_x < left_edge:
		global_position.x = right_edge
	elif player_x > right_edge:
		global_position.x = left_edge
