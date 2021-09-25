extends Node2D

func _on_Player_player_shoot(bullet, location, direction, velocity) -> void:
	var b = bullet.instance()
	add_child(b)
	b.sprite.rotation = direction.angle()
	b.position = location
	b.apply_central_impulse(direction * velocity)

func _on_SpaceStation_base_turret_shoot(bullet, location, direction, velocity) -> void:
	var b = bullet.instance()
	add_child(b)
	b.sprite.rotation = direction.angle()
	b.position = location
	b.apply_central_impulse(direction * velocity)

func _on_SpaceStation_player_docked() -> void:
	$Player/RemoteTransform2D.update_position = false
	$Camera2D.drag_margin_h_enabled = false
	$Camera2D.drag_margin_v_enabled = false
	$CameraTween.interpolate_property($Camera2D, "position", $Camera2D.global_position, $SpaceStation.global_position, $SpaceStation.docking_time)
	$CameraTween.interpolate_property($Camera2D, "zoom", $Camera2D.zoom, Vector2(2.0,2.0), $SpaceStation.docking_time)
	$CameraTween.start()

func _on_SpaceStation_player_undocked() -> void:
	$Player/RemoteTransform2D.update_position = true
	$Camera2D.drag_margin_h_enabled = true
	$Camera2D.drag_margin_v_enabled = true
	$CameraTween.interpolate_property($Camera2D, "position", $Camera2D.global_position, $Player/RemoteTransform2D.global_position, $SpaceStation.undocking_time)
	$CameraTween.interpolate_property($Camera2D, "zoom", $Camera2D.zoom, Vector2(1.0, 1.0), $SpaceStation.undocking_time)
	$CameraTween.start()
