extends Node2D

func _ready() -> void:
	var error_code := Events.connect("bullet_shoot",self, "_on_bullet_shoot")
	if error_code != 0:
		print("ERROR: ", error_code)

func _on_bullet_shoot(bullet, location, direction) -> void:
	var b = bullet.instance()
	add_child(b)
	b.rotation = direction.angle()
	b.position = location

func _on_SpaceStation_player_docked(docking_time : float) -> void:
	$Camera2D.drag_margin_h_enabled = false
	$Camera2D.drag_margin_v_enabled = false
	$Camera2D/CameraTween.interpolate_property($Camera2D, "position", $Camera2D.global_position, $SpaceStation.global_position, docking_time)
	$Camera2D/CameraTween.interpolate_property($Camera2D, "zoom", $Camera2D.zoom, Vector2(1.0,1.0), docking_time)
	$Camera2D/CameraTween.start()

func _on_SpaceStation_player_undocked(undocking_time : float) -> void:
	$Camera2D.drag_margin_h_enabled = true
	$Camera2D.drag_margin_v_enabled = true
	$Camera2D/CameraTween.interpolate_property($Camera2D, "position", $Camera2D.global_position, $Player.global_position, undocking_time)
	$Camera2D/CameraTween.interpolate_property($Camera2D, "zoom", $Camera2D.zoom, Vector2(1.0, 1.0), undocking_time)
	$Camera2D/CameraTween.start()

func _on_spawn_enemy(enemy, location) -> void:
	var e = enemy.instance()
	e.position = location
	e.main_target = $SpaceStation
	$Enemies.add_child(e)
