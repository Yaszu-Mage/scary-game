extends Node
var static_check = preload("res://assets/scenes/static_check.tscn")
var score = 0
var objfinished = 0
signal checkpassed
# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func status_check(nodehead : Node):
	var check = static_check.instantiate()
	nodehead.add_child(check)
	if check.passed == true:
		checkpassed.emit()
	
