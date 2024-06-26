class_name ProjectileTurret
extends Turret

export var rate_of_fire := 2.0
export var rotation_speed := 4.0

var bullet_scene = null

var weapon_ready := true

func shoot_weapon(location, direction) -> void:
	$ShootFX.play()
	Events.emit_signal("bullet_shoot", bullet_scene, location, direction)
	$WeaponShootTimer.start(rate_of_fire)
	weapon_ready = false

func _on_WeaponShootTimer_timeout():
	weapon_ready = true
