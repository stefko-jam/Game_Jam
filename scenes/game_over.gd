extends Control

@onready var restart_button: Button = $HBoxContainer/RestartButton
@onready var quit_button: Button = $HBoxContainer/QuitButton
@onready var submit_name_button: Button = $SubmitNameButton
@onready var enter_user_name: LineEdit = $EnterUserName
@onready var highscore_label: Label = $HighscoreLabel
@onready var enter_name: Label = $EnterNameLabel
@onready var highscore_list_label: Label = $HighscoreListLabel
@onready var highscore_button: Button = $HighscoreListLabel/HighscoreButton
@onready var highscore_panel = $HighscorePanel
@onready var back_button = $HighscorePanel/BackButton
@onready var highscore_list: VBoxContainer = $HighscorePanel/HighscoreListContainer

var highscore: int

func _ready():
	visible = false
	enter_user_name.visible = false
	submit_name_button.visible = false
	enter_name.visible = false
	highscore_list_label.visible = false
	highscore_button.visible = false
	highscore_panel.visible = false
	back_button.pressed.connect(_on_back_button_pressed)
	restart_button.pressed.connect(_on_restart_pressed)
	quit_button.pressed.connect(_on_quit_pressed)
	submit_name_button.pressed.connect(_on_submit_button_pressed)
	highscore_button.pressed.connect(_on_highscore_button_pressed)

	

	# Connect to highscore result signals
	HighscoreManager.highscore_accepted.connect(_on_score_accepted)
	HighscoreManager.highscore_rejected.connect(_on_score_rejected)
	HighscoreManager.highscores_fetched.connect(_on_highscores_fetched)

func show_game_over():
	print("📺 Showing Game Over Screen")
	visible = true
	highscore = HighscoreManager.highscore
	highscore_label.text = "Highscore: " + str(abs(highscore))
	highscore_list_label.visible = true
	highscore_button.visible = true
	highscore_panel.visible = false
	HighscoreManager.check_if_qualifies_for_highscore()


func _on_score_accepted():
	enter_name.visible = true
	enter_user_name.visible = true
	submit_name_button.visible = true
	print("you're in the top 10")
	#$FeedbackLabel.text = "🎉 You're in the Top 10!"

func _on_score_rejected():
	enter_user_name.visible = false
	submit_name_button.visible = false
	print("not enough")
	#$FeedbackLabel.text = "⬇️ Not enough for the Top 10."


func _on_submit_button_pressed():
	var player_name = enter_user_name.text.strip_edges()
	if player_name != "":
		HighscoreManager.set_player_name(player_name)
		HighscoreManager.submit_score()
		enter_user_name.editable = false
		submit_name_button.disabled = true
	else:
		print("❗Bitte gib einen Namen ein.")

func _on_highscore_button_pressed():
	HighscoreManager.fetch_highscores()  
	highscore_panel.visible = true      

func _on_back_button_pressed():
	highscore_panel.visible = false
	


func _on_highscores_fetched(data: Array):
	if not is_instance_valid(highscore_list):
		print("❌ Highscore list not ready!")
		return

	# Clear previous list
	for child in highscore_list.get_children():
		highscore_list.remove_child(child)
		child.queue_free()

	# Add new entries
	for i in data.size():
		var name = str(data[i][0])
		var score = str(data[i][1])
		var label = Label.new()
		label.text = "%d. %s – %s" % [i + 1, name, score]
		highscore_list.add_child(label)



func _on_quit_pressed():
	get_tree().quit()

func _on_restart_pressed():
	get_tree().reload_current_scene()
	AudioServer.set_bus_mute(AudioServer.get_bus_index("Master"), false)
	
	#ToDo
	#is_dead = false
	#reset highscore
