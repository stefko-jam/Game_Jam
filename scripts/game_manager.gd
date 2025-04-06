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
	if score == 11:
		score = 5
		$pollutometer.frame = score

func substract_point():
	score -= 1
	$pollutometer.frame = score
	if score == 0:
		score = 5
		$pollutometer.frame = score


#To Do: Health Bar with Score. Health Bar Frame 1, 2, 3 then if it reaches max you neutralise it
