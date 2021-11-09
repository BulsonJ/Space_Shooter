extends Node2D

# Class used to provide functionality for placing and deleting turrets at preset points

# x,y position, z rotation
export var turretPoints : PoolVector3Array
var placed_turrets : Array

onready var turret_beam = preload("res://Defence/Beam/Beam.tscn")
onready var turret_cannon = preload("res://Defence/Cannon/Cannon.tscn")

signal turret_placed(turret_index)
signal turret_removed(turret_index)

enum turret_types{
	cannon,
	beam,
}

export(Array, turret_types) var default_turrets : Array

func _ready() -> void:
	for i in turretPoints.size():
		placed_turrets.append(null)
		place_turret(i, turret_types.values()[default_turrets[i]])


func place_turret(turret_index : int, turret_type: int) -> void:
	if placed_turrets[turret_index] != null:
		return
		
	var turret = null
	if turret_type == turret_types.cannon:
		turret = turret_cannon.instance()
	elif turret_type == turret_types.beam:
		turret = turret_beam.instance()
		
	turret.rotation_degrees = (turretPoints[turret_index].z)
	turret.position = Vector2(turretPoints[turret_index].x,turretPoints[turret_index].y)
	
	add_child(turret)
	placed_turrets[turret_index] = turret
	
	if (turret.has_signal("turret_shoot")):
		turret.connect("turret_shoot", get_parent(), "_on_defence_turret_shoot")
	emit_signal("turret_placed", turret_index)
	
func delete_turret(turret_index : int) -> void:
	if placed_turrets[turret_index] == null:
		return 
		
	placed_turrets[turret_index].animation_player.play("sell")
	placed_turrets[turret_index] = null
	emit_signal("turret_removed", turret_index)
	
func repair_turret(turret_index : int) -> void:
	if placed_turrets[turret_index] == null:
		return 
		
	placed_turrets[turret_index].repair_turret()
	
func get_turret(turret_index : int) -> Turret:
	return placed_turrets[turret_index]

