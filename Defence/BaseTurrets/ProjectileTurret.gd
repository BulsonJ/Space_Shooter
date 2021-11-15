class_name ProjectileTurret
extends Turret

onready var rate_of_fire = turret_resource.rate_of_fire

var bullet_scene = null
var _weapon_ready := true

signal turret_shoot(bullet, location, direction)

func _ready()-> void:
	rotation_speed = 4.0

func shoot_weapon(location, direction) -> void:
	$ShootFX.play()
	emit_signal("turret_shoot", bullet_scene, location, direction)
	$WeaponShootTimer.start(rate_of_fire)
	_weapon_ready = false

func _on_WeaponShootTimer_timeout():
	_weapon_ready = true

func update_variables() -> void:
	rate_of_fire = turret_resource.rate_of_fire
