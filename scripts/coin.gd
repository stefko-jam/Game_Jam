extends Area2D

@export var animation_player: AnimationPlayer
@export var game_manager: Node

@export var coin_type: int

func _ready() -> void:
	#print("ready", %GameManager)
	$AnimatedSprite2D.frame = coin_type
	

func _on_body_entered(body: Node2D) -> void:
	game_manager.add_point()
	print($AnimationPlayer)
	print("+ 1 coin")
	$AnimationPlayer.play("pickup")
