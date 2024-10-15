extends Node

var magicdic = {
	"fireball" : {
		"icon" : "res://assets/images/fireballicon-export.png",
		"cooldown" : 30,
		"animation" : "fireballinst",
		"scenepath" : "pass",
		"preloadid" : 3
	},
	"burninghands" : {
		"icon" : "res://assets/images/fire.png",
		"cooldown" : 5,
		"animation" : "burninghand",
		"scenepath" : "res://assets/abilities/burninghands.tscn",
		"preloadid" : 0,
	},
	"none" : {
		"icon" : null,
		"cooldown" : 0,
		"animation" : null,
		"scenepath" : "pass",
		"preloadid" : 1000
	},
}

func cast(caster : CharacterBody3D, position: Vector3, dir : Vector3,ability : String,scenehead : Node):
	if ability == null:
		print("recieved null ability")
	else:
		print(ability)
		var abilityscene = Preinitload.abilities[magicdic[ability]["preloadid"]].instantiate()
		abilityscene.position = position
		abilityscene.caster = caster
		abilityscene.castingpos = position
		scenehead.add_child(abilityscene)
		
		await get_tree().create_timer(10.0).timeout
		abilityscene.queue_free()

func getequippedicons(spell):
	if magicdic[spell]["icon"] != null:
		var ico = load(magicdic[spell]["icon"])
		return ico
	else:
		print("null ico")
		return null
		
func getequippedcool(spell : String):
	if magicdic[spell]["cooldown"] != 0:
		var cooldown = magicdic[spell]["cooldown"]
		return cooldown
	else:
		print("null cooldown")
		return null
