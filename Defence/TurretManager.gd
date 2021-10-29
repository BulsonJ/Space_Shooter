extends Node2D

# Class used to provide functionality for placing and deleting turrets at preset points

# x,y position, z rotation
export var turretPoints : PoolVector3Array
var placed_turrets = [null, null, null, null]
var number_of_turrets := 0

onready var turret_cannon = preload("res://Defence/Beam/Beam.tscn")

signal turret_placed(turret_index)
signal turret_removed(turret_index)

func _ready() -> void:
	place_turret(0)
	place_turret(1)
	place_turret(2)
	place_turret(3)

func place_turret(turret_index : int) -> void:
	if placed_turrets[turret_index] != null:
		return
		
	var turret = turret_cannon.instance()
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

