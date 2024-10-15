extends CharacterBody3D
var caster = null
var castingpos : Vector3
var speed = 400
var direction = Vector3(global.dir.x,0,global.dir.y)

func _on_area_3d_body_entered(body):
	if body != caster and body.is_in_group("player") or body.is_in_group("mob"):
		body.health -= 10


func _physics_process(delta):
	velocity = direction * speed * delta
	print(velocity)
	move_and_slide()
	
func _on_timer_timeout():
	self.queue_free()


