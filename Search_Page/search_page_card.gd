extends Control
@onready var Loc_name = $HBoxContainer/Info/Name
@onready var Loc_id = $HBoxContainer/Info/ID


var ready_name = ""
var ready_id = ""

func _ready():
	Loc_name.text = ready_name
	Loc_id.text = ready_id

func setNameID(Lname,id):
	ready_name = str(Lname)
	ready_id = str(id)

func _on_click_pressed():
	print(ready_id)
	Global.Queue_Weather(ready_id)
	pass # Replace with function body.
