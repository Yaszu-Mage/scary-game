extends Node3D
@onready var animation = $AnimationPlayer


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func anim(anim_name : String):
	match anim_name:
		"walk":
			animation.play("walking")
		"run":
			animation.play("run")
		"idle":
			animation.play("idle")
		"die":
			animation.play("death")


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
