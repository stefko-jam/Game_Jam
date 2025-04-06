extends Area2D

#@onready var timer: Timer = $Timer #drag and drop and hold control

@onready var game_over: Control = $"../../../HUD/GameOver"

func _on_body_entered(body: Node2D) -> void:
	if body.name == "Player":
		$dead_frog.play()
		print("You died")	
		if game_over:
			body.visible = false
			await get_tree().create_timer(0.5).timeout
			AudioServer.set_bus_mute(AudioServer.get_bus_index("Master"), true)
			game_over.visible = true
		else:
			print("⚠️ GameOver node not found!")


#func _on_timer_timeout() -> void:
	#Engine.time_scale = 1 # we go back to normal speed
	#get_tree().reload_current_scene()
