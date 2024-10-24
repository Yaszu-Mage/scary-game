extends CharacterBody3D

@onready var agent = $NavigationAgent3D
@onready var timer = $Timer
var movement_delta: float
var bod
const SPEED = 5.0
var compvel
const JUMP_VELOCITY = 4.5
func _physics_process(delta):
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta
	#Set Velocity
	movement_delta = SPEED * delta
	var next_path_pos: Vector3 = agent.get_next_path_position()
	var next_path_vel: Vector3 = global_position.direction_to(next_path_pos) * movement_delta
	move_and_slide()
	if agent.avoidance_enabled:
		agent.set_velocity(next_path_vel)
	else:
		_on_navigation_agent_3d_velocity_computed(next_path_vel)
	if !bod:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		velocity.z = move_toward(velocity.z, 0, SPEED)
	move_and_slide()

func comp_agent():
	if bod:
		agent.target_position.x = bod.global_position.x
		agent.target_position.z = bod.global_position.z
	else:
		pass

func _on_navigation_agent_3d_velocity_computed(safe_velocity):
	global_position = global_position.move_toward(global_position + safe_velocity, movement_delta)


func _on_area_3d_body_entered(body):
	bod = body


func _on_timer_timeout():
	comp_agent()


func _on_area_3d_body_exited(body):
	bod = null
