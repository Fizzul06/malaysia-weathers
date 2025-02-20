extends Control
##TODO REDO ALL THIS, INSTEAD OF REQUEST, JUST STORE IT AND SEARCH THROUGH AN ARRAY
@onready var httpreq = $HTTPRequest

var api_base_url = "https://api.data.gov.my/weather/forecast"
var key
var quered_key
var listed = []
var search_reset = false

func _ready():
	$Date.text = "Current Date: %s, %s" %[Global.Date, Global.get_weekday()]
	var query_url = "%s?contains=%s@date" % [api_base_url,Global.Date]
	httpreq.request(query_url)
	print(query_url)

#func _on_text_edit_text_changed():
	#httpreq.cancel_request()
	#if key != capitalize_each_word(u_input.text):
		#clear()
		#key = capitalize_each_word(u_input.text)
		#var query_url = "%s?contains=%s@location__location_name" % [api_base_url, key]
		#httpreq.request(query_url)
		#print(query_url)
	#pass # Replace with function body.

@onready var uline_input = $UlineInput
func _on_line_edit_text_submitted(new_text):
	httpreq.cancel_request()
	clear()
	key = capitalize_each_word(new_text)
	var query_url = "%s?contains=%s@location__location_name" % [api_base_url, key]
	httpreq.request(query_url)
	print(query_url)
	pass # Replace with function body.


func clear():
	listed.clear()
	for child in results.get_children():
		child.queue_free()



func _on_http_request_request_completed(_result, response_code, _headers, body):
	if response_code == 200:  # Check if the response is successful
		var json_parser = JSON.new()
		var parse_result = json_parser.parse(body.get_string_from_utf8())
		if parse_result == OK:
			var weather_data = json_parser.get_data()  # Get the parsed JSON data
			parse_weather_data(weather_data)
			print("done")
		else:
			print("Failed to parse JSON response.")
	else:
		print("HTTP Request failed with code:", response_code)
	pass # Replace with function body.

var Scard = preload("res://Search_Page/search_page_card.tscn")
@onready var results = $ScrollContainer/VBoxContainer

func parse_weather_data(weather_data):
	for item in weather_data:
		var location_info = item.get("location", {})
		var location_name = location_info.get("location_name", "Unknown")
		var location_id = location_info.get("location_id", "Unknown")
		if !listed.has(location_id):
			listed.append(location_id)
			var card = Scard.instantiate()
			print(location_id, location_name)
			card.setNameID(location_name, location_id)
			results.add_child(card)
	if weather_data.is_empty() :
		search_id()
	pass

func capitalize_each_word(text: String) -> String:
	var words = text.strip_edges().split(" ")  # Split the string into words
	for i in range(words.size()):
		if words[i].length() > 0:  # Ensure the word is not empty
			words[i] = words[i][0].to_upper() + words[i].substr(1).to_lower()
	return " ".join(words)




func _on_search_pressed():
	httpreq.cancel_request()
	key = capitalize_each_word(uline_input.text)
	clear()
	var query_url = "%s?contains=%s@location__location_name" % [api_base_url, key]
	httpreq.request(query_url)
	print(query_url)
	pass # Replace with function body.

func search_id():
	if !search_reset:
		httpreq.cancel_request()
		var query_url = "%s?contains=%s@location__location_id" % [api_base_url, key]
		httpreq.request(query_url)
		search_reset = true
	else:
		print("no location ID and Name found.")


func _on_uline_input_text_changed(new_text):
	search_reset = false
	if new_text == "":
		httpreq.cancel_request()
		key = capitalize_each_word(uline_input.text)
		clear()
		var query_url = "%s?contains=%s@location__location_name" % [api_base_url, key]
		httpreq.request(query_url)
		print(query_url)
	pass # Replace with function body.
