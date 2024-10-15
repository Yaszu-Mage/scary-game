extends Node


func wander(agent : NavigationAgent3D, selfnode : Node, speed : int, position : Vector3, range : int, homepos : Vector3):
	agent.target_position = Vector3(randf_range(position.x,position.x + 10), randf_range(position.y,position.y),randf_range(position.z,position.z + 10))
	if agent.target_position.distance_to(homepos) >= 10.0:
		agent.target_position = homepos


func track(agent :NavigationAgent3D, selfNode : CharacterBody3D, speed : int, position :Vector3, homepos : Vector3, enemypos : Vector3):
	if position.distance_to(enemypos) <= 5:
		agent.target_position = enemypos
		return true
	else:
		agent.target_position = -enemypos * 2
		return false
