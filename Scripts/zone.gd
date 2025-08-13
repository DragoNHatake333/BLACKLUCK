extends Label

func _ready():
	var http := HTTPRequest.new()
	add_child(http)
	# Connect the signal so our callback runs when the request finishes
	http.request_completed.connect(_on_request_completed)
	# Send the request
	var err = http.request("http://ip-api.com/json/")
	if err != OK:
		print("Request failed:", err)

func _on_request_completed(result: int, response_code: int, headers: PackedStringArray, body: PackedByteArray) -> void:
	if response_code != 200:
		print("HTTP Error:", response_code)
		return

	var json_str := body.get_string_from_utf8()
	var data = JSON.parse_string(json_str)
	if typeof(data) == TYPE_DICTIONARY:
		var country = data.get("country", "Unknown Country")
		var region = data.get("regionName", "Unknown Region")
		var ip = data.get("query", "Unknown IP")
		var lat = data.get("lat", 0.0)
		var lon = data.get("lon", 0.0)

		print("Country:", country)
		print("Region:", region)
		print("IP:", ip)
		print("Latitude:", lat, "Longitude:", lon)

		text = "%s, %s\n %s\nLat: %.4f, Lon: %.4f" % [region, country, ip, lat, lon]
	else:
		print("Invalid JSON response")

func _on_game_manager_call_typing() -> void:
	var tween: Tween = create_tween()
	tween.tween_property(self, "visible_ratio", 1.0, 3.0).from(0.0)
