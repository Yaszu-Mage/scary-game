extends TextureRect
@onready var icon = $icon
var ability = null
@onready var timer = $Timer
@onready var timertext = $timer
var cooldowntimer = null
var cool = 0

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if timer.is_stopped():
		timertext.visible = false
		$disabled.visible = false
	else:
		timertext.visible = true
		$disabled.visible = true
	$timer.clear()
	timertext.add_text(str(timer.time_left))
	


func _input(event):
	if cool == 0:
		pass


func registerinput():
	pass


func _on_timer_timeout():
	timer.stop()
