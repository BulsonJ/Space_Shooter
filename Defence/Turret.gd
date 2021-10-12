class_name Turret
extends StaticBody2D

export(float) var max_health = 5.0
onready var health = max_health

var _target : Enemy = null

signal turret_destroyed()

func take_damage(amount: float) -> void:
	_set_health(health - amount)

func _set_health(value) -> void:
	health = clamp(value, 0, max_health)
	if (health == 0):
		queue_free()
		emit_signal("turret_destroyed")
		
# Custom sort function used to sort targets into distance to turret
func _sort_target(a : Enemy,b: Enemy) -> bool:
	if a != null and b != null:
		return a.global_position.distance_to(global_position) < b.global_position.distance_to(global_position)
	else:
		return false
