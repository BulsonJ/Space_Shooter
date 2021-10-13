class_name Enemy
extends KinematicBody2D

var max_health := 1.0
onready var health = max_health


func take_damage(amount) -> void:
	_set_health(health - amount)

func _set_health(value) -> void:
	health = clamp(value, 0, max_health)
	if (health == 0):
		queue_free()
