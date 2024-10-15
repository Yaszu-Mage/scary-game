extends Node


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func initiate(type: int, port : int, ip : String, scene : String):
	print("started initiation!")
	if type == 0:
		print("Hosting...")
		get_tree().change_scene_to_file("res://assets/scenes/loader.tscn")
		var sceneinit = load(scene).instantiate()
		add_sibling(sceneinit)
		multi.host(Vector3(0,100,0),port,sceneinit.cont)
		
		
	else:
		print("Joining...")
		get_tree().change_scene_to_file("res://assets/scenes/loader.tscn")
		var sceneinit = load(scene).instantiate()
		add_sibling(sceneinit)
		multi.join(Vector3(0,100,0),port,sceneinit.cont,ip)
