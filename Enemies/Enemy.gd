class_name Enemy
extends KinematicBody2D

var max_health := 2.0
onready var health = max_health

signal enemy_destroyed()

func take_damage(amount) -> void:
	_set_health(health - amount)

func _set_health(value) -> void:
	health = clamp(value, 0, max_health)
	if (health == 0):
		emit_signal("enemy_destroyed")
		queue_free()
