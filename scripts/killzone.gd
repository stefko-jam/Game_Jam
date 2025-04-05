extends Area2D

#@onready var timer: Timer = $Timer #drag and drop and hold control


func _on_body_entered(body: Node2D) -> void:
	#print("You died!")
	#Engine.time_scale = 0.5 #we go at half speed
	#body.get_node("CollisionShape2D").queue_free() #accessing player, getting the collsion shape node and removing it
	#print("killzone script")
	#timer.start()
	if body.name == ("Player"):
		print ("You died")
		#body.queue_free()
		#game_over_ui.visible = true


#func _on_timer_timeout() -> void:
	#Engine.time_scale = 1 # we go back to normal speed
	#get_tree().reload_current_scene()
