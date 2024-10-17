extends Node3D
var bod

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$AnimationPlayer.play("rot")
	Global.checkpassed.connect(kill) # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func kill():
	if bod:
		self.queue_free()
		Global.objfinished = Global.objfinished + 1

func _on_area_3d_body_entered(body: Node3D) -> void:
	if body.is_in_group("player"):
		Global.status_check(get_tree().root)
		bod = body
		


func _on_area_3d_body_exited(body: Node3D) -> void:
	bod = null
