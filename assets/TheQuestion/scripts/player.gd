extends CharacterBody2D

var cooling = false
const SPEED = 300.0
var dashincrease = 200
var dashing = false
var speedincrease = 0
const JUMP_VELOCITY = -400.0
var dir = null
# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

func _ready():
	global.statuschange.connect(checkchange)


func checkchange():
	global.dashed = dashing

func _physics_process(delta):
	# Add the gravity.
	if Input.is_action_just_pressed("dash") and dashing == false and cooling == false:
		dashing = true
		global.statuschange.emit()
		await get_tree().create_timer(0.2).timeout
		dashing = false
		global.statuschange.emit()
		coolfunc()
	
	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var direction = Input.get_vector("left","right","up","down")
	if direction:
		if dashing:
			velocity = direction * (SPEED+dashincrease)
		else:
			velocity = direction * SPEED
			dir = direction
			global.dir = direction
	else:
		velocity = Vector2.ZERO
		dir = Vector2.ZERO
	move_and_slide()

func coolfunc():
	if cooling == false:
		cooling = true
		await get_tree().create_timer(2.0).timeout
		cooling = false
		global.statuschange.emit()


func _input(event):
	if event.is_action_pressed("shoot"):
		var knifeinit = load("res://assets/scenes/knifes.tscn").instantiate()
		var parent = get_parent()
		parent.add_child(knifeinit)
		knifeinit.transform = $Marker2D/gun/Marker2D.global_transform
		knifeinit.look_at($Marker2D/gun/Marker2D.global_position)
