extends Node2D

# Class used to provide functionality for placing and deleting turrets at preset points

# x,y position, z rotation
export var turretPoints : PoolVector3Array
var _placed_turrets : Array

signal turret_placed(turret_index)
signal turret_removed(turret_index)

enum turret_types{
	CANNON,
	BEAM,
}

var _turret_resources = [
	preload("res://Defence/Resources/cannon_info.tres"),
	preload("res://Defence/Resources/beam_info.tres")
]

var turret_dictionary = {
	turret_types.CANNON : _turret_resources[0],
	turret_types.BEAM : _turret_resources[1],
}

export(Array, turret_types) var default_turrets : Array


func _ready() -> void:
	for i in turretPoints.size():
		_placed_turrets.append(null)
		place_turret(i, turret_types.values()[default_turrets[i]])


func place_turret(turret_index : int, turret_type: int) -> void:
	if _placed_turrets[turret_index] != null:
		return
		
	var turret = null
	if turret_type == turret_types.CANNON:
		turret = turret_dictionary[turret_types.CANNON].turret_scene.instance()
	elif turret_type == turret_types.BEAM:
		turret = turret_dictionary[turret_types.BEAM].turret_scene.instance()
		
	turret.rotation_degrees = (turretPoints[turret_index].z)
	turret.position = Vector2(turretPoints[turret_index].x,turretPoints[turret_index].y)
	
	add_child(turret)
	_placed_turrets[turret_index] = turret
	
	if (turret.has_signal("turret_shoot")):
		turret.connect("turret_shoot", get_parent(), "_on_defence_turret_shoot")
	emit_signal("turret_placed", turret_index)

	
func delete_turret(turret_index : int) -> void:
	if _placed_turrets[turret_index] == null:
		return 
		
	_placed_turrets[turret_index].animation_player.play("sell")
	_placed_turrets[turret_index] = null
	emit_signal("turret_removed", turret_index)
	

func repair_turret(turret_index : int) -> void:
	if _placed_turrets[turret_index] == null:
		return 
		
	_placed_turrets[turret_index].repair_turret()
	

func get_turret(turret_index : int) -> Turret:
	return _placed_turrets[turret_index]

# Possibly split turret manager into two classes:
# 	- Manager class which handles adding/removing turrets to the space station
#	- Dictionary class which holds the turret resources and has helper methods for getting cost, sell value etc

func get_turret_cost(turret_type: int) -> int:
	return turret_dictionary[turret_type].turret_cost

func get_turret_sell_value(turret_type: int) -> int:
		return turret_dictionary[turret_type].turret_sell_value

