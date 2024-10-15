extends Control
var health = 100
@onready var abilityaccess = {
	1:$"container/1",
	2:$"container/2",
	3:$"container/3",
	4:$"container/4",
	"1c": {
		1:$"container/1/disabled",
		2:$"container/1/timer",
		3:$"container/1/Timer",
	},
	"2c": {
		1:$"container/2/disabled",
		2:$"container/2/timer",
		3:$"container/2/Timer",
	},
	"3c": {
		1:$"container/3/disabled",
		2:$"container/3/timer",
		3:$"container/3/Timer",
	},
	"4c": {
		1:$"container/4/disabled",
		2:$"container/4/timer",
		3:$"container/4/Timer",
	},
}

func _ready():
	global.statuschange.connect(statuscheck)

func _process(delta):
	$TextureProgressBar.value = health

func statuscheck():
	if global.dashed:
		$dash.modulate = Color(0.609,0.609,0.609)
	else:
		$dash.modulate = Color(1,1,1)
		


func _input(event):
	if event is InputEventKey:
		pass
