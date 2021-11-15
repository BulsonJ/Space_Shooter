extends TurretStats
class_name ProjectileTurretStats

export var base_rate_of_fire := 2.0
var rate_of_fire = 0.0

func _init() -> void:
	base_rate_of_fire = rate_of_fire

func modify_rof(modifier : float) -> void:
	rate_of_fire /= modifier
	emit_signal("variable_changed")
