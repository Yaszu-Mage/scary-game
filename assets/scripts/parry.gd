extends Area3D
var canparry = true
var isparrying = false
# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func _input(event):
	if Input.is_action_just_pressed("parry") and canparry:
		print("parry!")
		canparry = false
		isparrying = true
		await get_tree().create_timer(0.5)
		isparrying = false
		canparry = true

func _on_body_entered(body):
	if body.is_in_group("parryable"):
		if Input.is_action_just_pressed("parry") and canparry or isparrying and canparry:
			body.parried = true
			canparry = true
			print("hit parry!")
