extends CharacterBody3D
var interactable = false
var bod = null
var abilitycool = [false,false,false,false]
var moving = true
@onready var anim = $AnimatedSprite3D
var equipped = ["burninghands","fireball","none","none"]
var directionlooking = 0
var idletrack = {
	0: ["sideidle",true],
	1: ["sideidle", false],
	2: ["upidle",false],
	3: ["downidle",false],
}
var isnottalking = true
var vel = Vector3.ZERO
var dashing = false
var gravity = ProjectSettings.get_setting("physics/3d/default_gravity")
@onready var agent = $NavigationAgent3D
var movement_delta: float
var incombat = false

@export var movement_speed: float = 50.0
# Called when the node enters the scene tree for the first time.
func _ready():
	wandercycle()

func _physics_process(delta):
	if moving:
		if dashing:
			movement_speed = 100
		else:
			movement_speed = 50
		movement_delta = movement_speed * delta
		var next_path_position = agent.get_next_path_position()
		var new_velocity: Vector3 = global_position.direction_to(next_path_position) * movement_delta
		if agent.avoidance_enabled:
			agent.set_velocity(new_velocity)
		else:
			_on_navigation_agent_3d_velocity_computed(new_velocity)
	if !is_on_floor():
		velocity.y = gravity * -1
	
	if velocity.x <= 0 and velocity.x < velocity.z:
		directionlooking = 0
		anim.flip_h = true
		anim.play("sidewalk")
			
	elif velocity.x >= -0 and velocity.x > velocity.z:
		directionlooking = 1
		anim.flip_h = false
		anim.play("sidewalk")
	if velocity.z <= 0 and velocity.x < velocity.z:
		directionlooking = 2
		anim.flip_h = false
		anim.play("upwalk")
	elif velocity.z >= -0 and velocity.x < velocity.z:
		directionlooking = 3
		anim.flip_h = false
		anim.play("downwalk")
	if velocity.x == 0 and velocity.z == 0:
		anim.flip_h = idletrack[directionlooking][1]
		anim.play(str(idletrack[directionlooking][0]))
	move_and_slide()


func wandercycle():
	if incombat == false:
		await get_tree().create_timer(1.0).timeout
		moving = true
		npclogic.wander(agent,self,5.0,self.global_position,10,Vector3(0.0,0.569,-5.928))
		await get_tree().create_timer(5.0).timeout
		wandercycle()
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if bod:
		pass


func _on_area_3d_body_entered(body):
	if body.is_in_group("player"):
		bod = body
		print("tracking!")
		npclogic.track(agent,self,5,self.global_position,Vector3(0,-1.554,7.106),body.position)
		incombat = true
		if self.global_position.distance_to(body.position) > 10:
			dash()
		else:
			ability1()

func ability1():
	if abilitycool[0] == false:
		abilitycool[0] = true
		var ability = equipped[0]
		var dir = bod.global_position
		abilitycool[0] = false
		

func dash():
	dashing = true
	await get_tree().create_timer(0.3).timeout
	dashing = false
		


func _on_area_3d_body_exited(body):
	pass


func _on_navigation_agent_3d_navigation_finished():
	await get_tree().create_timer(10.0).timeout
	moving = false


func _on_navigation_agent_3d_velocity_computed(safe_velocity):
	velocity = safe_velocity
	move_and_slide()
