extends ProjectileTurret

onready var turret := $Turret
onready var default_rotation = turret.rotation
onready var turret_direct_sight = $Turret/RayCast2D

func _ready():
	bullet_scene = preload("res://Defence/Cannon/CannonBullet.tscn")

func _physics_process(delta: float) -> void:
	if current_state != state.FUNCTIONAL:
		return
			
	if _target == null:
		return
	else:
		if turret_direct_sight.is_colliding():
			if turret_direct_sight.get_collider() is Enemy:
				if _weapon_ready:
					shoot_weapon($Turret/Muzzle.global_position, Vector2.RIGHT.rotated(turret.global_rotation))
					$Turret/MuzzleParticles.emitting = true
					
				# TODO: If gun can't shoot, choose next closest target
		
		var v = _target.global_position - global_position
		var angle = v.angle()
		var r = turret.global_rotation
		var angle_delta = rotation_speed * delta
		angle = lerp_angle(r, angle, 1.0)
		angle = clamp(angle, r - angle_delta, r + angle_delta)
		turret.global_rotation = lerp_angle(r, angle, 0.2)
