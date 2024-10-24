extends Node3D
var bullet = preload("res://assets/scenes/bullet.tscn")
@onready var parent = $".."
# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_timer_timeout():
		var bulletscene = bullet.instantiate()
		parent.get_parent().add_child(bulletscene)
		var angle = self.get_rotation().y
		var tanangle = self.get_rotation().x
		bulletscene.position = $Marker3D.global_position
		bulletscene.dir = -Vector3(sin(angle),-tan(tanangle),cos(angle))
		bulletscene.variablesinstantiated = true
