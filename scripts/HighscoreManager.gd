extends Node

var highscore: int = 0  # Best (lowest) Y-position (more negative = better)
var http_request: HTTPRequest
var score_submitted: bool = false
var checking_for_submission: bool = false
const API_URL := "https://script.google.com/macros/s/AKfycbwLFaqetk8wkU-O_35-CTeO4EM6U0ID_k-SDU7WkY_tDlXk1mDgA5hx9O1m_2I4ysT1ZA/exec"
var player: Node2D = null  # Store reference

func set_player_reference(p: Node2D):
	player = p

func _process(delta: float) -> void:
	if player:
		var player_position = player.position.y + 28
		if player_position < highscore:
			highscore = abs(player_position)

func _ready():
	score_submitted = false
	checking_for_submission = false

	http_request = get_node_or_null("/root/Game/Highscore/HighscoreManager/HTTPRequest")

	if http_request:
		http_request.request_completed.connect(_on_http_request_request_completed)
		print("✅ HTTPRequest connected.")
	else:
		print("❌ HTTPRequest not found!")




# Call this ONCE from game over to trigger GET + (if qualified) POST
func submit_score():
	if score_submitted:
		print("❌ Score already submitted.")
		return

	if http_request and http_request.get_http_client_status() == HTTPClient.STATUS_DISCONNECTED:
		checking_for_submission = true
		print("🔎 Checking if highscore qualifies...")
		http_request.request(API_URL, [], HTTPClient.METHOD_GET, "")
	else:
		print("❌ Cannot submit – HTTP busy or missing.")

# Internal: handle GET or POST completion
func _on_http_request_request_completed(result: int, response_code: int, headers: PackedStringArray, body: PackedByteArray) -> void:
	print("✅ Request completed. Response code:", response_code)

	if response_code != 200:
		print("❌ Fehler beim HTTP-Request: ", response_code)
		return

	var response_string = body.get_string_from_utf8()

	# Only interested in JSON responses from GET
	if !response_string.begins_with("["):
		print("ℹ️ Kein JSON – vermutlich POST-Antwort.")
		return

	var json = JSON.new()
	if json.parse(response_string) != OK:
		print("❌ Fehler beim JSON-Parsing")
		return

	var data = json.data
	print("🔝 Aktuelle Highscores:")
	for i in data.size():
		print("%d. %s – %s" % [i + 1, data[i][0], data[i][1]])

	# Only proceed if we're actually checking to submit
	if !checking_for_submission or score_submitted:
		return

	checking_for_submission = false

	# Find lowest score in Top 10
	var lowest_score = INF
	for row in data:
		var score = int(row[1])
		if score < lowest_score:
			lowest_score = score

	if data.size() < 10 or highscore > lowest_score:
		print("✅ Neuer Highscore wird eingereicht:", highscore)
		score_submitted = true
		_send_score_to_server()
	else:
		print("❌ Nicht gut genug für Top 10.")

# Actually send the POST
func _send_score_to_server():
	var player_name = "Test5"  # Replace with user input if needed
	var body = "name=" + player_name.uri_encode() + "&score=" + str(highscore)
	var headers = ["Content-Type: application/x-www-form-urlencoded"]

	if http_request.get_http_client_status() == HTTPClient.STATUS_DISCONNECTED:
		http_request.request(API_URL, headers, HTTPClient.METHOD_POST, body)
	else:
		print("❌ HTTP busy, could not send POST.")
