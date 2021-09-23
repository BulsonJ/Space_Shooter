extends Node2D


# Declare member variables here. Examples:
# var a: int = 2
# var b: String = "text"


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

func _on_Player_player_shoot(bullet, location, direction, velocity) -> void:
	var b = bullet.instance()
	add_child(b)
	b.rotation = direction.angle()
	b.position = location
	b.apply_central_impulse(direction * velocity)

func _on_SpaceStation_base_turret_shoot(bullet, location, direction, velocity) -> void:
	var b = bullet.instance()
	add_child(b)
	b.rotation = direction.angle()
	b.position = location
	b.apply_central_impulse(direction * velocity)

