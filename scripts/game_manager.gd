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
	score = min(score + 1, 11) 
	handleChange()

func substract_point():
	score = max(score - 1,0) 
	handleChange()
		
func handleChange():
	if score < 5:
		$Pollution.frame = score
		$Pollution.visible = true
	if score >= 5:
		$Pollution.visible = false
	if score == 11:
		score = 5
		handleBoost()
	$pollutometer.frame = score
		
func handleBoost():
	%Player.JUMP_VELOCITY = -800
	await get_tree().create_timer(7.0).timeout
	%Player.JUMP_VELOCITY = -400 # reset
