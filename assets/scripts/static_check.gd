extends Node2D
@onready var anim = $AnimationPlayer
var checker = false
var currentarea
var passed = false
# Called when the node enters the scene tree for the first time.
func _ready():
	anim.play("check")


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if Input.is_action_just_pressed("dash"):
		_ready()
	if Input.is_action_just_pressed("check") and checker == true:
		print("check passed")
		passed = true

func _on_area_2d_area_entered(area):
	if area.is_in_group("checker"):
		checker = true
		currentarea = area


func _on_area_2d_area_exited(area):
	if area == currentarea:
		checker = false


func _on_animation_player_animation_finished(anim_name):
	if passed == false:
		print("check failed")
