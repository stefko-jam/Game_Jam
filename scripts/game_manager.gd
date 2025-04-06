extends Node

var score = 5
var highscore = 0
@onready var score_label: Label = $Highscore
	
func _process(delta: float) -> void:
	var player_position = %Player.position.y +28
	if player_position < highscore:
		highscore = player_position
	score_label.text = str(abs(int(highscore)))


func add_point():
	score += 1
	$pollutometer.frame = score
	
	if score == 7:
		score = 5
		$pollutometer.frame = score
		%Player.JUMP_VELOCITY = -800
		
		# Start a 7-second timer
		await get_tree().create_timer(7.0).timeout
		
		# Reset jump velocity after 7 seconds
		%Player.JUMP_VELOCITY = -400


func substract_point():
	score -= 1
	$pollutometer.frame = score
	if score == 0:
		score = 5
		$pollutometer.frame = score


#To Do: Health Bar with Score. Health Bar Frame 1, 2, 3 then if it reaches max you neutralise it
