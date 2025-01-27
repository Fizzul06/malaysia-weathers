extends Control


@onready var search = $Search
@onready var weather_view = $Weather_view
@onready var loading_indicator = $Loading_indicator

var current_page = search

func _ready():
	Global.Main_node = self

func _on_weather_view_finished_load(success):
	loading_indicator.stop_load()
	if success:
		ChangePage(search,weather_view)
	else:
		print("fail")
	pass # Replace with function body.

func Queue_Weather(Location_id):
	weather_view.RequestPageInformation(Location_id)
	loading_indicator.start_load()
	
func ChangePage(oldPage,newPage):
	oldPage.hide()
	#oldPage.process_mode = Node.PROCESS_MODE_DISABLED
	newPage.show()
	#newPage.process_mode = Node.PROCESS_MODE_INHERIT
	current_page = newPage

func _notification(what):

	if what == NOTIFICATION_WM_GO_BACK_REQUEST and current_page == search:# For android`
		get_tree().quit() # default behavior`
	if what == NOTIFICATION_WM_GO_BACK_REQUEST and current_page == weather_view:# For android`
		ChangePage(weather_view, search)
		print("AAA")
	
func _unhandled_input(_event):
	if Input.is_action_just_pressed("Back") and current_page == weather_view:
		ChangePage(weather_view, search)
