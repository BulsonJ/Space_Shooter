class_name ProjectileTurret
extends Turret

export var rate_of_fire := 2.0
export var rotation_speed := 4.0

var bullet_scene = null

var weapon_ready := true

signal turret_shoot(bullet, location, direction, velocity)

func shoot_weapon(location, direction, velocity) -> void:
	$ShootFX.play()
	emit_signal("turret_shoot", bullet_scene, location, direction, velocity)
	$WeaponShootTimer.start(rate_of_fire)
	weapon_ready = false

func _on_WeaponShootTimer_timeout():
	weapon_ready = true
