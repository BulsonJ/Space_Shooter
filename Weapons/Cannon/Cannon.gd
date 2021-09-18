extends Node2D

export(PackedScene) var bullet = preload("res://Weapons/Cannon/Bullet.tscn")
export(float) var rate_of_fire = 0.3

onready var shoot_timer = $ShootTimer

var can_fire: bool = true
var is_casting := false setget set_is_casting

func fire() -> void:
	var new_bullet : RigidBody2D = bullet.instance()
	new_bullet.transform = $Muzzle.global_transform
	new_bullet.apply_central_impulse(Vector2.UP.rotated(get_parent().rotation) * 500.0)
	get_parent().get_parent().get_parent().add_child(new_bullet)
	
	#new_bullet.position = get_parent().transform.xform($Muzzle.position)
	#new_bullet.rotation = get_parent().rotation
	
func set_is_casting(cast: bool) -> void:
	is_casting = cast
	
	if is_casting:
		if shoot_timer.is_stopped():
			fire()
			shoot_timer.start(0.3)
	else:
		#shoot_timer.stop()
		pass
		
func _on_ShootTimer_timeout() -> void:
	if is_casting:
		fire()
		shoot_timer.start(0.3)
