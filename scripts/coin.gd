extends Area2D

#@onready var game_manager: Node = %GameManager
#@onready var animation_player: AnimationPlayer = $AnimationPlayer


func _on_body_entered(body: Node2D) -> void:
	%GameManager.add_point()
	$AnimationPlayer.animation_player.play("pickup")
