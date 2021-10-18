extends StaticBody2D

var _target : Player = null
var docking_finished := false
var docking_time := 2.0
var undocking_time := 0.5

onready var turret_amount = $TurretManager.number_of_turrets

signal player_docked(animation_time)
signal player_undocked(animation_time)
signal base_turret_shoot(bullet, location, direction, velocity)

func _physics_process(_delta: float) -> void:
	if !_target:
		return
		
	var input := Input.get_action_strength("move_up") - Input.get_action_strength("move_down")
	
	# If the docking animation is finished and the player is providing input, enable player process & input
	if docking_finished == true and input != 0:
		if $Docking/ReleaseTimer.is_stopped():
			$Docking/ReleaseTimer.start(undocking_time)
			emit_signal("player_undocked", undocking_time)
			
	if docking_finished == true:
		_target.use_fuel(-0.1)

func _on_defence_turret_shoot(bullet, location, direction, velocity) -> void:
	emit_signal("base_turret_shoot", bullet, location,direction, velocity)

# Create timers to control docking maybe?
# Set time somewhere so that it is more constant
# Have start docking and finish docking signals(start undocking and finish undocking)


func _on_DockingArea2D_body_entered(body: Player) -> void:
	# Start the docking procedure and disable player process & input
	_target = body
	_target.set_physics_process(false)
	_target.set_process_input(false)
	_target.targetable = false
	_target.stop_ship()
	docking_finished = false
	
	# Position ship in dock and rotate it and weapon
	$Docking/Tween.interpolate_property(_target, "position", _target.global_position, $Docking/DockingPosition.global_position, docking_time)
	$Docking/Tween.interpolate_property(_target.ship, "rotation", _target.ship.rotation, $Docking/DockingPosition.rotation, docking_time)
	$Docking/Tween.interpolate_property(_target.weapon_slot, "rotation", _target.weapon_slot.rotation, $Docking/DockingPosition.rotation, docking_time)
	$Docking/Tween.start()
	
	emit_signal("player_docked", docking_time)

func _on_Tween_tween_all_completed() -> void:
	docking_finished = true
	
func _on_ReleaseTimer_timeout() -> void:
	_target.set_physics_process(true)
	_target.set_process_input(true)
	_target.targetable = true
	_target = null
