extends Control
@onready var player = $AnimationPlayer


var loading = false

func start_load():
	loading = true
	
func _process(_delta):
	if loading:
		show()
		if !player.is_playing():
			player.play("Spin")
	else:
		hide()
		player.pause()

func stop_load():
	loading = false
