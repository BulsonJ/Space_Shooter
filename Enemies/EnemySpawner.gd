extends Node2D

export var spawn_timer := 5.0
export var spawn_distance := 650.0 * 1

export(PackedScene) var enemy_type = preload("res://Enemies/Enemy_1.tscn")

signal spawn_enemy(enemy, location)

func _ready() -> void:
	pass # Replace with function body.

func spawn_enemy() -> void:
	var angle := rand_range(0, 360)
	var pos := Vector2(spawn_distance*cos(angle), spawn_distance*sin(angle))
	
	emit_signal("spawn_enemy", enemy_type, pos)
	
func _on_SpawnTimer_timeout() -> void:
	spawn_enemy()
