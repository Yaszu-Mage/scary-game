extends Node3D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	Global.checkpassed.connect(checkobj)
func checkobj():
	if Global.objfinished == 5:
		print("win!")
		$AudioStreamPlayer3D.play()
		await $AudioStreamPlayer3D.finished
		await get_tree().create_timer(1.0)
		get_tree().quit()

# Called every frame. 'delta' is the elapsed time since the previous frame.
