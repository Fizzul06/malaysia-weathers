extends Node

var Main_node

func Queue_Weather(Location_id):
	Main_node.Queue_Weather(Location_id)

var Date

var current_date = Time.get_datetime_dict_from_system()

# Accessing individual components
var year = current_date["year"]
var month = current_date["month"]
var day = current_date["day"]
var weekday = current_date["weekday"]

func _ready():
	var formatted_date = "%d-%02d-%02d" % [year, month, day]
	Date = formatted_date

func get_weekday():
	var weekdays = ["Sunday", "Monday", "Tuesday", "Wednesday", "Thursday", "Friday", "Saturday"]
	return weekdays[weekday]
