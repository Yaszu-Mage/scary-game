extends CharacterBody3D

var sizeclass = 1
const SPEED = 5.0
const JUMP_VELOCITY = 4.5
@onready var agent = $NavigationAgent3D


func _physics_process(delta):
	
	velocity = agent.velocity * SPEED
	move_and_slide()
	


func _on_area_3d_body_entered(body):
	if body.is_in_group("living"):
		if body.sizeclass > sizeclass:
			run(body)
		else:
			hunt(body)


func run(body):
	pass
func hunt(body):
	if body.is_in_group("player"):
		agent.target_position = body.position
	else:
		pass
