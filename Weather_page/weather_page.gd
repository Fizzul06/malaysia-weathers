extends Control

# sarawak and sabah start with 5
# town = 141, state = 13/15 S&S 501&502 RC = 26/28 S&S 501&502 , DS S=90 SS=67, DV=18 all SS 5

@onready var httpreq = $HTTPRequest
@onready var output_text = $RichTextLabel
@onready var location = $Location

#var weather_api_url := "https://api.data.gov.my/weather/forecast?limit=500"

var api_base_url = "https://api.data.gov.my/weather/forecast"
@export var location_ids = "St001"  # Replace with desired location ID

var current_location = "Location"

func _process(_delta):
	#location.text = current_location
	pass

func _on_button_pressed():
	httpreq.cancel_request()
	#var query_url = "%s?location_id=%s" % [api_base_url, location_id]
	#var query_url = "%s?contains=%s@location__location_id" % [api_base_url, location_id]
	var query_url = "%s?contains=%s" % [api_base_url, location_ids]
	print(query_url)
	httpreq.request(query_url)
	#httpreq.request(weather_api_url)
	pass # Replace with function body.

func parse_weather_data(weather_data):
	output_text.clear()
	for item in weather_data:
		var location_info = item.get("location", {})
		var location_name = location_info.get("location_name", "Unknown")
		var location_id = location_info.get("location_id", "Unknown")  # Get the location_id
		var morning_forecast = item.get("morning_forecast", "Unknown")
		var formatted_text = "Location: %s, Location ID: %s, Morning Forecast: %s\n" % [location_name, location_id, morning_forecast]
		output_text.append_text(formatted_text)
	
	#print(weather_data[0].location.location_name)
	location.text = str(weather_data[0].location.location_name)
	#print(weather_data)

func _on_http_request_request_completed(result, response_code, headers, body):
	if response_code == 200:  # Check if the response is successful
		var json_parser = JSON.new()
		var parse_result = json_parser.parse(body.get_string_from_utf8())
		if parse_result == OK:
			var weather_data = json_parser.get_data()  # Get the parsed JSON data
			parse_weather_data(weather_data)
		else:
			print("Failed to parse JSON response.")
	else:
		print("HTTP Request failed with code:", response_code)
	pass # Replace with function body.
	#print(headers, body)

@onready var location_input = $Location_input
func _on_location_input_text_changed():
	location_ids = location_input.text
	pass # Replace with function body.
