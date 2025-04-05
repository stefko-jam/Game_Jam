extends Area2D

@onready var timer: Timer = $Timer #drag and drop and hold control

func _on_body_entered(body: Node2D) -> void:
	print("You died!")
	Engine.time_scale = 0.5 #we go at half speed
	body.get_node("CollisionShape2D").queue_free() #accessing player, getting the collsion shape node and removing it
	timer.start()


func _on_timer_timeout() -> void:
	Engine.time_scale = 1 # we go back to normal speed
	get_tree().reload_current_scene()
