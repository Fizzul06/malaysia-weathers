extends Control

signal Finished_load(success:bool)

@onready var lname = %Lname
@onready var lid = %Lid


@onready var status_m = %status_m
@onready var status_a = %status_a
@onready var status_n = %status_n
@onready var temperature = %Temperature



var api_base_url = "https://api.data.gov.my/weather/forecast"


var weather:Array


	#RequestPageInformation("Rc018")

@onready var http_request = $HTTPRequest
func RequestPageInformation(location_id):
	
	var query_url = "%s?contains=%s@location__location_id" % [api_base_url, location_id]
	http_request.request(query_url)

func _on_http_request_request_completed(_result, response_code, _headers, body):
	if response_code == 200:  # Check if the response is successful
		var json_parser = JSON.new()
		var parse_result = json_parser.parse(body.get_string_from_utf8())
		if parse_result == OK:
			var weather_data = json_parser.get_data()  # Get the parsed JSON data
			parse_weather_data(weather_data)
			print("done")
			Finished_load.emit(true)
		else:
			print("Failed to parse JSON response.")
			Finished_load.emit(false)
	else:
		print("HTTP Request failed with code:", response_code)
		Finished_load.emit(false)
	pass # Replace with function body.

func parse_weather_data(weather_data):
	var location_name = weather_data[0].location.location_name
	var location_id = weather_data[0].location.location_id
	#print(weather_data)
	weather.clear()
	for item in weather_data:
		weather.append(item)
	
	for item in weather:
		print(item.summary_forecast)
	
	display_data()
	show_forecast()
	lname.text = location_name
	lid.text = "Location ID: %s" %[location_id]

func display_data():
	status_m.text = weather.back().morning_forecast
	status_a.text = weather.back().afternoon_forecast
	status_n.text = weather.back().night_forecast
	temperature.text = "Temperature Min: %s°C , Max: %s°C" % [weather[0].min_temp, weather[0].max_temp]

@onready var days = [%Day1, %Day2, %Day3, %Day4, %Day5, %Day6]

func show_forecast():
	var counts = 5
	for item in days:
		if weather[counts] != null:
			item.text = "%s \nSummary: %s \nWaktu: %s " % [weather[counts].date, weather[counts].summary_forecast, weather[counts].summary_when]
		else:
			item.text = "No Data"
		counts -= 1
