extends Node

signal highscore_accepted
signal highscore_rejected
signal highscores_fetched(data: Array)

enum RequestType { NONE, GET_CHECK, POST_SCORE }

var highscore: int = 0
var http_request: HTTPRequest
var score_submitted: bool = false
var player_name: String = "Unnamed"
var player: Node2D = null
var current_request_type := RequestType.NONE

const API_URL := "https://script.google.com/macros/s/AKfycbxPKdodpBgNj-WnsFMl9AZIBMppA6pSVt7teZkFcRi2-HSvIt05-lBVK8QcZSfSKjDDcQ/exec"

func _ready():
	score_submitted = false

	http_request = get_node_or_null("/root/Game/Highscore/HighscoreManager/HTTPRequest")
	if http_request:
		if not http_request.request_completed.is_connected(_on_http_request_request_completed):
			http_request.request_completed.connect(_on_http_request_request_completed)
		print("✅ HTTPRequest connected.")
	else:
		print("❌ HTTPRequest not found!")

func set_player_reference(p: Node2D):
	player = p

func set_player_name(name: String):
	player_name = name

func _process(_delta):
	if player:
		var player_position = player.position.y + 28
		if player_position < highscore:
			highscore = player_position

# 🧠 Step 1: Check if score is good enough
func check_if_qualifies_for_highscore():
	if not http_request or http_request.get_http_client_status() != HTTPClient.STATUS_DISCONNECTED:
		print("❌ Cannot check – HTTP busy or missing.")
		return

	current_request_type = RequestType.GET_CHECK
	print("🔎 Checking highscore list...")
	http_request.request(API_URL, [], HTTPClient.METHOD_GET, "")

# 🧾 Step 2: Actually submit the name & score
func submit_score():
	if score_submitted:
		print("❌ Already submitted.")
		return

	if not http_request or http_request.get_http_client_status() != HTTPClient.STATUS_DISCONNECTED:
		print("❌ Cannot send POST – busy or missing.")
		return

	current_request_type = RequestType.POST_SCORE
	score_submitted = true

	var body_dict = {
		"name": player_name,
		"score": str(abs(highscore))
	}
	var form_encoded_string = ""
	for key in body_dict.keys():
		form_encoded_string += key.uri_encode() + "=" + str(body_dict[key]).uri_encode() + "&"
	form_encoded_string = form_encoded_string.trim_suffix("&")

	var headers = ["Content-Type: application/x-www-form-urlencoded"]

	print("🚀 Sending POST to:", API_URL)
	print("📦 Body:", form_encoded_string)

	http_request.request(API_URL, headers, HTTPClient.METHOD_POST, form_encoded_string)

# 🌐 Handle both GET and POST responses
func _on_http_request_request_completed(result: int, response_code: int, headers: PackedStringArray, body: PackedByteArray) -> void:
	print("✅ Request completed. Response code:", response_code)
	var response_text := body.get_string_from_utf8()
	print("🌐 Server response:", response_text)

	match current_request_type:
		RequestType.POST_SCORE:
			current_request_type = RequestType.NONE

			if response_code != 200:
				print("❌ Fehler beim Highscore-POST:", response_code)
				return

			if "Highscore added" in response_text:
				print("🏆 Highscore accepted!")
				emit_signal("highscore_accepted")
			elif "Score not high enough" in response_text:
				print("😢 Score not high enough for Top 10.")
				emit_signal("highscore_rejected")
			else:
				print("⚠️ Unbekannte Antwort:", response_text)

		RequestType.GET_CHECK:
			current_request_type = RequestType.NONE

			if response_code != 200:
				print("❌ Fehler beim Highscore-GET:", response_code)
				return

			if !response_text.begins_with("["):
				print("❌ Keine gültige JSON-Antwort")
				return

			var json = JSON.new()
			if json.parse(response_text) != OK:
				print("❌ Fehler beim JSON-Parsing")
				return

			var data = json.data
			print("📋 Highscore List:")
			for i in data.size():
				print("%d. %s – %s" % [i + 1, data[i][0], data[i][1]])

			emit_signal("highscores_fetched", data)

			# Compare current score
			var lowest_score = INF
			for row in data:
				var score = int(row[1])
				if score < lowest_score:
					lowest_score = score

			if data.size() < 10 or abs(highscore) > lowest_score:
				print("✅ You made it into the Top 10!")
				emit_signal("highscore_accepted")
			else:
				print("⬇️ Score not high enough.")
				emit_signal("highscore_rejected")

		_:
			print("⚠️ Kein Request-Typ gesetzt oder unbekannt.")

# 📥 Called to manually fetch highscore list for display (without checking score)
func fetch_highscores():
	if not http_request or http_request.get_http_client_status() != HTTPClient.STATUS_DISCONNECTED:
		print("❌ Cannot fetch – HTTP busy or missing.")
		return

	current_request_type = RequestType.GET_CHECK
	print("📥 Fetching highscore list for display...")
	http_request.request(API_URL, [], HTTPClient.METHOD_GET, "")
