extends CharacterBody2D

const SPEED = 300.0
@export var JUMP_VELOCITY = -400.0

@onready var anim_sprite: AnimatedSprite2D = $AnimatedSprite2D
@onready var jump_timer: Timer = $JumpTimer
@export var x_position: float

var pending_jump := false
var was_on_floor := false
var input_enabled := false  # ✅ Moved up here

func _ready():
	jump_timer.timeout.connect(_on_jump_timer_timeout)

func _physics_process(delta: float) -> void:
	if input_enabled and not is_on_floor():
		velocity += get_gravity() * delta
		anim_sprite.play("jump")

	# Detect fresh landing
	if input_enabled and is_on_floor() and not was_on_floor and !pending_jump:
		anim_sprite.play("on floor")
		$sound_frog.play()
		jump_timer.start()
		pending_jump = true
	
	if input_enabled:
			
		was_on_floor = is_on_floor()
		
		var keyboardInput = Input.get_axis("left", "right");
		var direction = touchInput if touchInput != 0 else keyboardInput
		if direction:
			velocity.x = direction * SPEED
		else:
			velocity.x = move_toward(velocity.x, 0, SPEED)
		move_and_slide()
		
	x_position = position.x

func _on_jump_timer_timeout():
	pending_jump = false
	velocity.y = JUMP_VELOCITY

func enable_input():
	input_enabled = true

var touchInput := 0  # -1 for left, 1 for right, 0 for none

func _unhandled_input(event):
	if event is InputEventScreenTouch or event is InputEventScreenDrag:
		var screen_half = get_viewport_rect().size.x / 2
		touchInput = -1 if event.position.x < screen_half else 1
			
	if event is InputEventScreenTouch and not event.pressed:
		touchInput = 0 # Stop moving on release
