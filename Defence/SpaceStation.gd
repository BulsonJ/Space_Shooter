extends StaticBody2D

var _target : Player = null

onready var turret_amount = $Defences.get_child_count()

signal player_docked()
signal player_undocked()
signal base_turret_shoot(bullet, location, direction, velocity)
signal base_destroyed()

func _physics_process(delta: float) -> void:
	if !_target:
		return
		
	var input := Input.get_action_strength("move_up") - Input.get_action_strength("move_down")
	if _target.docking_lock == false and input != 0:
		_target.currentState = Player.states.FLYING
		emit_signal("player_undocked")
		_target = null

func _on_EnemyTurret_turret_shoot(bullet, location, direction, velocity) -> void:
	emit_signal("base_turret_shoot", bullet, location,direction, velocity)

func _on_EnemyTurret_turret_destroyed() -> void:
	turret_amount -= 1
	
	if turret_amount <= 0:
		emit_signal("base_destroyed")
		$Sprite.texture = load("res://Defence/SpaceStation_Destroyed.png")

func _on_DockingArea2D_body_entered(body: Player) -> void:
	_target = body
	
	_target.currentState = Player.states.DOCKED
	_target.docking_lock = true
	$Docking/Tween.interpolate_property(_target, "position", _target.global_position, $Docking/DockingPosition.global_position, 2.0)
	$Docking/Tween.interpolate_property(_target.ship, "rotation", _target.ship.rotation, $Docking/DockingPosition.rotation, 2.0)
	$Docking/Tween.start()
	emit_signal("player_docked")

func _on_DockingArea2D_body_exited(body: Player) -> void:
	_target = null

func _on_Tween_tween_all_completed() -> void:
	_target.docking_lock = false


