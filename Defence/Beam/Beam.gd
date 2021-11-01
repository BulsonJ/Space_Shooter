extends Turret

onready var turret := $Turret
onready var default_rotation = turret.rotation
onready var turret_direct_sight = $Turret/RayCast2D

export var rotation_speed := 8.0

var _shooting = false

func _physics_process(delta: float) -> void:
	if current_state == state.DESTROYED:
		cast_beam(false)
	
	if current_state != state.FUNCTIONAL:
		return
		
	if _target == null:
		cast_beam(false)
		return	
	else:
				
		if turret_direct_sight.is_colliding():
			if turret_direct_sight.get_collider() is Enemy:
				cast_beam(true)
				if $Turret/Beam.is_colliding():
					var collider = $Turret/Beam.get_collider()
					if collider is Enemy:
						if collider.has_method("take_damage"):
							collider.take_damage(0.1)
		else:
			cast_beam(false)
		
	var v = _target.global_position - global_position
	var angle = v.angle()
	var r = turret.global_rotation
	var angle_delta = rotation_speed * delta
	angle = lerp_angle(r, angle, 1.0)
	angle = clamp(angle, r - angle_delta, r + angle_delta)
	turret.global_rotation = lerp_angle(r, angle, 0.2)

func cast_beam(var set_shooting) -> void:
	if _shooting != set_shooting:
		_shooting = set_shooting
		$Turret/Beam.is_casting = _shooting
