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



func _on_SpaceStation_player_docked() -> void:
	$Player/RemoteTransform2D.update_position = false
	$Camera2D.drag_margin_h_enabled = false
	$Camera2D.drag_margin_v_enabled = false
	$CameraTween.interpolate_property($Camera2D, "position", $Camera2D.global_position, $SpaceStation.global_position, 2.0)
	$CameraTween.interpolate_property($Camera2D, "zoom", $Camera2D.zoom, Vector2(1.5,1.5), 2.0)
	$CameraTween.start()


func _on_SpaceStation_player_undocked() -> void:
	$Player/RemoteTransform2D.update_position = true
	$Camera2D.drag_margin_h_enabled = true
	$Camera2D.drag_margin_v_enabled = true
	$CameraTween.interpolate_property($Camera2D, "position", $Camera2D.global_position, $Player.global_position, 1.0)
	$CameraTween.interpolate_property($Camera2D, "zoom", $Camera2D.zoom, Vector2(1.0,1.0), 1.0)
	$CameraTween.start()
