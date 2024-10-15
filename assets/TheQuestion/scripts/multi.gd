extends Node
var multi = ENetMultiplayerPeer.new()
var connected_peer_ids = []
var local_player_character = null
# Called when the node enters the scene tree for the first time.
func _ready():
	multi.peer_connected.connect(
		func(new_peer_id):
			print("peer connected")
			await get_tree().create_timer(1).timeout
			rpc("add_newly_connected_player_character", new_peer_id)
			rpc_id(new_peer_id, "add_previously_connected_player_characters", connected_peer_ids)
			add_player_character(new_peer_id)
	)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
@rpc
func peer_connect():
	var playerinit = load("res://assets/scenes/cultplayer.tscn").instantiate()
	playerinit.global_position = Vector3(0,10,0)
	$scene.cont.add_child(playerinit)

func host(spawn : Vector3,port: int, container: Node3D):
	multi.create_server(port,16)
	var id = multi.get_unique_id()
	add_player_character(1)
	multiplayer.multiplayer_peer = multi
	
	
func join(spawn: Vector3,port: int, container: Node3D, ip : String):
	multi.create_client(ip,port)
	var id = multi.get_unique_id()
	localglobe.id = id
	multiplayer.multiplayer_peer = multi
	id = str(multi.get_unique_id())
	


func add_player_character(peer_id):
	connected_peer_ids.append(peer_id)
	var player_character = preload("res://assets/scenes/cultplayer.tscn").instantiate()
	player_character.set_multiplayer_authority(peer_id)
	add_child(player_character)
	if peer_id == multiplayer.get_unique_id():
		local_player_character = player_character

@rpc	
func add_newly_connected_player_character(new_peer_id):
	add_player_character(new_peer_id)
	
@rpc
func add_previously_connected_player_characters(peer_ids):
	for peer_id in peer_ids:
		add_player_character(peer_id)
