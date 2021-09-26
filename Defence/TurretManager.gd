extends Node2D

# Class used to provide functionality for placing and deleting turrets at preset points

# x,y position, z rotation
export var turretPoints : PoolVector3Array
var placed_turrets := [null, null, null]
var number_of_turrets = 0

onready var turret_cannon = preload("res://Defence/TurretCannon.tscn")

signal turret_placed(pos)
signal turret_removed(pos)

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	for i in get_children():
		var turret : Turret = i
		turret.connect("turret_shoot", get_parent(), "_on_EnemyTurret_turret_shoot")
		turret.connect("turret_destroyed", get_parent(), "_on_EnemyTurret_turret_destroyed")
		placed_turrets[number_of_turrets] = turret
		number_of_turrets += 1
		
	delete_turret(0)
	delete_turret(1)
	delete_turret(2)
	
	place_turret(2)
	place_turret(1)
	place_turret(0)
		

func place_turret(pos : int) -> void:
	if placed_turrets[pos] != null:
		return
		
	var turret = turret_cannon.instance()
	turret.rotation_degrees = turretPoints[pos].z
	turret.position = Vector2(turretPoints[pos].x,turretPoints[pos].y)
	
	add_child(turret)
	placed_turrets[pos] = turret
	
	turret.connect("turret_shoot", get_parent(), "_on_EnemyTurret_turret_shoot")
	turret.connect("turret_destroyed", get_parent(), "_on_EnemyTurret_turret_destroyed")
	emit_signal("turret_placed", pos)
	
func delete_turret(pos : int) -> void:
	if placed_turrets[pos] == null:
		return 
		
	remove_child(placed_turrets[pos])
	placed_turrets[pos] = null
	emit_signal("turret_removed", pos)
