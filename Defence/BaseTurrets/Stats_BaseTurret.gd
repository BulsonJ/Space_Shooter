extends Resource
class_name TurretStats

signal variable_changed()

export var base_max_health := 50.0
var max_health = 0.0

export var base_rotation_speed := 8.0
var rotation_speed = 0.0

func _init() -> void:
    max_health = base_max_health
    rotation_speed = base_rotation_speed

func modify_rotation_speed(modifier : float) -> void:
	rotation_speed *= modifier
	emit_signal("variable_changed")

func modify_max_health(modifier : float) -> void:
    max_health += modifier
    emit_signal("variable_changed")



