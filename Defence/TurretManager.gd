extends Node2D

# Class used to provide functionality for placing and deleting turrets at preset points

# x,y position, z rotation
export var turretPoints : PoolVector3Array
var placed_turrets := [null, null, null]
var number_of_turrets = 0

onready var turret_cannon = preload("res://Defence/Cannon/TurretCannon.tscn")

signal turret_placed(turret_index)
signal turret_removed(turret_index)

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	for i in get_children():
		var turret : Turret = i
		turret.connect("turret_shoot", get_parent(), "_on_EnemyTurret_turret_shoot")
		turret.connect("turret_destroyed", get_parent(), "_on_EnemyTurret_turret_destroyed")
		placed_turrets[number_of_turrets] = turret
		number_of_turrets += 1
		

func place_turret(turret_index : int) -> void:
	if placed_turrets[turret_index] != null:
		return
		
	var turret = turret_cannon.instance()
	turret.rotation_degrees = turretPoints[turret_index].z
	turret.position = Vector2(turretPoints[turret_index].x,turretPoints[turret_index].y)
	
	add_child(turret)
	placed_turrets[turret_index] = turret
	
	turret.connect("turret_shoot", get_parent(), "_on_EnemyTurret_turret_shoot")
	turret.connect("turret_destroyed", get_parent(), "_on_EnemyTurret_turret_destroyed")
	emit_signal("turret_placed", turret_index)
	
func delete_turret(turret_index : int) -> void:
	if placed_turrets[turret_index] == null:
		return 
		
	remove_child(placed_turrets[turret_index])
	placed_turrets[turret_index] = null
	emit_signal("turret_removed", turret_index)
	
func get_turret(turret_index : int) -> Turret:
	return placed_turrets[turret_index]
