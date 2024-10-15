extends CharacterBody3D
@onready var agent = $NavigationAgent3D

const SPEED = 5.0
const JUMP_VELOCITY = 4.5
var naving = false
var bod = null
# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/3d/default_gravity")
func _process(delta):
	if bod:
		agent.target_position = bod.position

func _physics_process(delta):
	if bod and naving:
		var current_location = global_transform.origin
		var next_location = agent.get_next_path_position()
		var new_velocity = (next_location - current_location).normalized() * SPEED
		velocity = new_velocity
		move_and_slide()
	if not is_on_floor():
		velocity.y -= gravity * delta
	move_and_slide()
	


func _on_area_3d_body_entered(body):
	if body.is_in_group("player"):
		naving = true
		agent.target_position = body.position
		bod = body
		print(bod)
		print("naving")
