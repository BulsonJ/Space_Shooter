extends Turret

export(float) var rate_of_fire = 2.0
export var rotation_speed := 4.0
export(PackedScene) var bullet = preload("res://Defence/Cannon/AlliedBullet.tscn")

onready var turret := $Turret
onready var default_rotation = turret.rotation
var weapon_ready := true

onready var turret_direct_sight = $Turret/RayCast2D

signal turret_shoot(bullet, location, direction, velocity)

func _physics_process(delta: float) -> void:
	if current_state == state.DESTROYED:
		call_deferred("set", "$CollisionShape2D.disabled", true)
		return
	else:
		call_deferred("set", "$CollisionShape2D.disabled", false)
	
	if current_state == state.REPAIRING:
		return
		
	if _target == null:
		return
	else:
		if turret_direct_sight.is_colliding():
			if turret_direct_sight.get_collider() is Enemy:
				if weapon_ready:
					$ShootFX.play()
					emit_signal("turret_shoot", bullet, $Turret/Muzzle.global_position, Vector2.RIGHT.rotated(turret.global_rotation), 400.0)
					$WeaponShootTimer.start(rate_of_fire)
					weapon_ready = false
					
				# TODO: If gun can't shoot, choose next closest target
		
		var v = _target.global_position - global_position
		var angle = v.angle()
		var r = turret.global_rotation
		var angle_delta = rotation_speed * delta
		angle = lerp_angle(r, angle, 1.0)
		angle = clamp(angle, r - angle_delta, r + angle_delta)
		turret.global_rotation = lerp_angle(r, angle, 0.2)

func _on_Turret_Vision_body_exited(body: Enemy) -> void:
	if _target == body:
		_target = null

func _on_WeaponShootTimer_timeout():
	weapon_ready = true
