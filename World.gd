extends Node2D

func _on_bullet_shoot(bullet, location, direction, velocity) -> void:
	var b = bullet.instance()
	add_child(b)
	b.rotation = direction.angle()
	b.position = location
	b.apply_central_impulse(direction * velocity)

func _on_SpaceStation_player_docked(docking_time : float) -> void:
	$Player/RemoteTransform2D.update_position = false
	$Camera2D.drag_margin_h_enabled = false
	$Camera2D.drag_margin_v_enabled = false
	$CameraTween.interpolate_property($Camera2D, "position", $Camera2D.global_position, $SpaceStation.global_position, docking_time)
	#$CameraTween.interpolate_property($Camera2D, "zoom", $Camera2D.zoom, Vector2(1.0,1.0), docking_time)
	$CameraTween.start()

func _on_SpaceStation_player_undocked(undocking_time : float) -> void:
	$Player/RemoteTransform2D.update_position = true
	$Camera2D.drag_margin_h_enabled = true
	$Camera2D.drag_margin_v_enabled = true
	$CameraTween.interpolate_property($Camera2D, "position", $Camera2D.global_position, $Player/RemoteTransform2D.global_position, undocking_time)
	#$CameraTween.interpolate_property($Camera2D, "zoom", $Camera2D.zoom, Vector2(1.0, 1.0), undocking_time)
	$CameraTween.start()

func _on_spawn_enemy(enemy, location) -> void:
	var e = enemy.instance()
	e.position = location
	e.main_target = $SpaceStation
	$Enemies.add_child(e)
