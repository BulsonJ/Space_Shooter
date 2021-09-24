extends StaticBody2D

var _target : Player = null
var docking_finished := false

onready var turret_amount := $Defences.get_child_count()

signal player_docked()
signal player_undocked()
signal base_turret_shoot(bullet, location, direction, velocity)
signal base_destroyed()

func _physics_process(delta: float) -> void:
	if !_target:
		return
		
	var input := Input.get_action_strength("move_up") - Input.get_action_strength("move_down")
	
	# If the docking animation is finished and the player is providing input, undock them
	if docking_finished == true and input != 0:
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

# Create timers to control docking maybe?
# Set time somewhere so that it is more constant
# Have start docking and finish docking signals(start undocking and finish undocking)


func _on_DockingArea2D_body_entered(body: Player) -> void:
	# Start the docking procedure and change the state of the player
	_target = body
	docking_finished = false
	_target.currentState = Player.states.DOCKED
	
	# Position ship in dock and rotate it and weapon
	$Docking/Tween.interpolate_property(_target, "position", _target.global_position, $Docking/DockingPosition.global_position, 2.0)
	$Docking/Tween.interpolate_property(_target.ship, "rotation", _target.ship.rotation, $Docking/DockingPosition.rotation, 2.0)
	$Docking/Tween.interpolate_property(_target.weapon_slot, "rotation", _target.weapon_slot.rotation, $Docking/DockingPosition.rotation, 2.0)
	$Docking/Tween.start()
	
	emit_signal("player_docked")

func _on_DockingArea2D_body_exited(body: Player) -> void:
	_target = null

func _on_Tween_tween_all_completed() -> void:
	docking_finished = true
