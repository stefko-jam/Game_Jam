extends Node

var score = 5
@onready var score_label: Label = $Score

func add_point():
	score += 1
	score_label.text = ("Your score: ") + str(score)
	print("accessed add point")
	$pollutometer.frame = score
	if score == 11:
		score = 5
		$pollutometer.frame = score

func substract_point():
	score -= 1
	score_label.text = ("Your score: ") + str(score)
	$pollutometer.frame = score
	if score == 0:
		score = 5
		$pollutometer.frame = score


#To Do: Health Bar with Score. Health Bar Frame 1, 2, 3 then if it reaches max you neutralise it
