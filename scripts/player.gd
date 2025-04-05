extends CharacterBody2D

const SPEED = 300.0
const JUMP_VELOCITY = -400.0

@onready var anim_sprite: AnimatedSprite2D = $AnimatedSprite2D
@onready var jump_timer: Timer = $JumpTimer

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
		jump_timer.start()
		pending_jump = true
	
	if input_enabled:
			
		was_on_floor = is_on_floor()

		var direction := Input.get_axis("left", "right")
		if direction:
			velocity.x = direction * SPEED
		else:
			velocity.x = move_toward(velocity.x, 0, SPEED)

		move_and_slide()

func _on_jump_timer_timeout():
	pending_jump = false
	velocity.y = JUMP_VELOCITY

func enable_input():
	input_enabled = true
