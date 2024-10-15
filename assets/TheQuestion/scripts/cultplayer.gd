extends CharacterBody3D
const RAY_LENGTH = 1000
var sel = 0
var directionlooking = 0
var canshmack = true
var stun = false
var idletrack = {
	0: ["sideidle",true],
	1: ["sideidle", false],
	2: ["upidle",false],
	3: ["downidle",false],
}
var cooled = true
const SPEED = 5.0
@onready var anim = $AnimatedSprite3D
var health = 100
const JUMP_VELOCITY = 4.5
@onready var ui = $UI
var equipped = ["burninghands","fireball","none","none"]
@onready var yapui = $UI/yap
@onready var yapico = $UI/yapico
@onready var abilitytree = {
	1 : $"UI/container/1",
	2 : $"UI/container/2",
	3 : $"UI/container/3",
	4 : $"UI/container/4",
}
var dashing = false
var dir : Vector3
var selected = []
var select = null
# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/3d/default_gravity")
func _ready():
	var id = multiplayer.get_unique_id()
	if is_multiplayer_authority():
		yapui.visible = false
		yapico.visible = false
		applyequip()

@rpc("unreliable")
func animrpc(animation, bool):
	anim.flip_h = bool
	anim.play("anim")

func _process(delta):
	if is_multiplayer_authority():
		ui.health = health


func _physics_process(delta):
	# Add the gravity.
	if is_multiplayer_authority():
		$SpringArm3D/Camera3D.current = true
		$UI.visible = true
		if not is_on_floor():
			velocity.y -= gravity * delta
		if Input.is_action_just_pressed("jump") and is_on_floor():
			velocity.y = JUMP_VELOCITY
	# Handle jump.

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
		var input_dir = Input.get_vector("left", "right", "up", "down")
		var direction = (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
		if input_dir:
			if input_dir.x == -1:
				anim.flip_h = true
				anim.play("sidewalk")
				directionlooking = 0
			elif input_dir.x == 1:
				anim.flip_h = false
				anim.play("sidewalk")
				directionlooking = 1
			if input_dir.y == -1:
				anim.flip_h = false
				anim.play("upwalk")
				directionlooking = 2
			elif input_dir.y == 1:
				anim.flip_h = false
				anim.play("downwalk")
				directionlooking = 3
		else:
			anim.flip_h = idletrack[directionlooking][1]
			anim.play(str(idletrack[directionlooking][0]))
		if direction and stun == false:
			if dashing:
				velocity.x = direction.x * (SPEED + 5)
				velocity.z = direction.z * (SPEED + 5)
				global.dir = input_dir
				ui.statuscheck()
			else:
				velocity.x = direction.x * SPEED
				velocity.z = direction.z * SPEED
				global.dir = input_dir
				ui.statuscheck()
				
		else:
			velocity.x = move_toward(velocity.x, 0, SPEED)
			velocity.z = move_toward(velocity.z, 0, SPEED)
		rpc("remote_set_position", global_position)
		move_and_slide()

func applyequip():
	var on = 0
	for x in equipped:
		on += 1
		print(x)
		var icon = identity.getequippedicons(x)
		var cooldown = identity.getequippedcool(x)
		print(icon)
		print(cooldown)
		if cooldown == null:
			print("recieved null cooldown!")
			abilitytree[on].cooldowntimer = cooldown
		else:
			abilitytree[on].cooldowntimer = cooldown
		if icon == null:
			print("recieved null icon!")
			abilitytree[on].icon.texture = null
		else:
			abilitytree[on].icon.texture = icon
			abilitytree[on].ability = x

@rpc("unreliable")
func remote_set_position(authority_position):
	global_position = authority_position


func _input(event):
	if is_multiplayer_authority() and stun == false:
		if event is InputEventMouseButton and event.pressed and event.button_index == 1:
			var camera3d = $SpringArm3D/Camera3D
			var from = camera3d.project_ray_origin(event.position)
			var to = from + camera3d.project_ray_normal(event.position) * RAY_LENGTH
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
		const RAY_LENGTH = 1000.0
		if event.is_action_pressed("1"):
			if abilitytree[1].timer.is_stopped():
				var ability = equipped[0]
				abilitytree[1].timer.wait_time = identity.getequippedcool(equipped[0])
				abilitytree[1].timer.start()
				print(ability)
				identity.cast(self,global_position,dir,ability,self.get_parent())
		if event.is_action_pressed("2"):
			if abilitytree[1].timer.is_stopped():
				var ability = equipped[1]
				abilitytree[2].timer.wait_time = identity.getequippedcool(equipped[1])
				abilitytree[2].timer.start()
				print(ability)
				identity.cast(self,global_position,dir,ability,self.get_parent())
		if event.is_action_pressed("3"):
			if abilitytree[3].timer.is_stopped():
				var ability = equipped[2]
				abilitytree[3].timer.wait_time = identity.getequippedcool(equipped[2])
				abilitytree[3].timer.start()
				print(ability)
				identity.cast(self,global_position,dir,ability,self.get_parent())
		if event.is_action_pressed("4"):
			if abilitytree[4].timer.is_stopped():
				var ability = equipped[4]
				abilitytree[4].timer.wait_time = identity.getequippedcool(equipped[3])
				abilitytree[4].timer.start()
				print(ability)
				identity.cast(self,global_position,dir,ability,self.get_parent())
		if event.is_action("shoot"):
			shmack()
			
func coolfunc(x):
	await get_tree().create_timer(x).timeout
	cooled = true

func shmack():
	if canshmack:
		pass
