extends Area2D

@onready var game_manager: Node = %GameManager
@onready var animation_player: AnimationPlayer = $AnimationPlayer

@export var coin_type: int

func _ready() -> void:
	print("ready")
	$AnimatedSprite2D.frame = coin_type
	
	
func _on_body_entered(body: Node2D) -> void:
	game_manager.substract_point()
	print("- 1 coin")
	animation_player.play("pickup")
