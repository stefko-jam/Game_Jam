extends Area2D

@export var game_manager: Node;

@export var coin_type: int

func _ready() -> void:
	print("ready")
	$AnimatedSprite2D.frame = coin_type
	
func _on_body_entered(body: Node2D) -> void:
	if (game_manager != null):
		game_manager.substract_point()
		print("-1 coin")
		$AnimationPlayer.play("pickup")
