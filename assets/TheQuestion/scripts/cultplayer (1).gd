extends CharacterBody3D

var sel = 0
var cooled = true
const SPEED = 5.0
const JUMP_VELOCITY = 4.5
@onready var yapui = $UI/yap
@onready var yapico = $UI/yapico
var dashing = false
var selected = []
var select = null
# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/3d/default_gravity")
func _ready():
	yapui.visible = false
	yapico.visible = false

func _physics_process(delta):
	# Add the gravity.
	
	if not is_on_floor():
		velocity.y -= gravity * delta

	# Handle jump.

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var input_dir = Input.get_vector("left", "right", "up", "down")
	var direction = (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	if direction:
		if dashing:
			velocity.x = direction.x * (SPEED + 5)
			velocity.z = direction.z * (SPEED + 5)
		else:
			velocity.x = direction.x * SPEED
			velocity.z = direction.z * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		velocity.z = move_toward(velocity.z, 0, SPEED)

	move_and_slide()



func _input(event):
	if event.is_action_pressed("dash"):
		if cooled:
			cooled = false
			dashing = true
			global.statuschange.emit()
			global.dashed = true
			await get_tree().create_timer(0.4).timeout
			dashing = false
			coolfunc(0.5)
			
			global.dashed = false
			global.statuschange.emit()
	if event.is_action_pressed("switch"):
		sel = wrapi(sel,0,selected.size() + 1)
		select = selected[sel]
		sel += sel + 1
		sel = wrapi(sel, 0, selected.size() + 1)
		print(sel)
		print(sel," ",select," ",selected)
		
			
func coolfunc(x):
	await get_tree().create_timer(x).timeout
	cooled = true
