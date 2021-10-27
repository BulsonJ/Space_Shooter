extends Turret

const bullet_scene = preload("res://Defence/Cannon/AlliedBullet.tscn")

var weapon_ready := true

signal turret_shoot(bullet, location, direction, velocity)

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


func _on_WeaponShootTimer_timeout():
	weapon_ready = true
