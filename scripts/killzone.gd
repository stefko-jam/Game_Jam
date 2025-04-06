extends Area2D

#@onready var timer: Timer = $Timer #drag and drop and hold control

@onready var game_over: Control = $"../../../HUD/GameOver"

func _on_body_entered(body: Node2D) -> void:
	if body.name == "Player":
		print("You died")
		$dead_frog.play()
		if game_over:
			game_over.visible = true
		else:
			print("⚠️ GameOver node not found!")


#func _on_timer_timeout() -> void:
	#Engine.time_scale = 1 # we go back to normal speed
	#get_tree().reload_current_scene()
