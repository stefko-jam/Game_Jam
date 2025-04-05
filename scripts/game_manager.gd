extends Node

var score = 0
@onready var score_label: Label = $Score

func add_point():
	score += 1
	score_label.text = ("Your score: ") + str(score)
	print("accessed add point")
	if score == 5:
		score = 0

func substract_point():
	score -= 1
	score_label.text = ("Your score: ") + str(score)
	if score == -5:
		score = 0


#To Do: Health Bar with Score. Health Bar Frame 1, 2, 3 then if it reaches max you neutralise it
