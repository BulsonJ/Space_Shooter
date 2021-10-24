extends Resource

signal health_amount_changed(current_health)

var max_health := 100.0
var health := 0.0 setget _set_health

func _init() -> void:
	health = max_health

func remove_health(amount) -> void:
	_set_health(health - amount)

func _set_health(value) -> void:
	health = clamp(value, 0, max_health)
	emit_signal("health_amount_changed", health)
	if (health == 0):
		# TODO: Implement health mechanic
		pass
