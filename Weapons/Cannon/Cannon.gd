extends Node2D

export(PackedScene) var bullet = preload("res://Weapons/Cannon/Bullet.tscn")
export(float) var rate_of_fire = 0.33

onready var shoot_timer := $ShootTimer
onready var shoot_sound := $ShootFX
onready var weapon_sprite := $Turret

var can_fire: bool = true
var is_casting := false setget set_is_casting

signal shoot(bullet, location, direction)

func fire() -> void:
	$MuzzleFX.visible = true
	$MuzzleFX.set_frame(0)
	$MuzzleFX.play("default")
	
	shoot_sound.play()
		
	emit_signal("shoot", bullet, to_global($Muzzle.position), Vector2.RIGHT.rotated(get_parent().rotation))
	
func set_is_casting(cast: bool) -> void:
	is_casting = cast
	
	if is_casting:
		if shoot_timer.is_stopped():
			fire()
			shoot_timer.start(rate_of_fire)
		
func _on_ShootTimer_timeout() -> void:
	if is_casting:
		fire()
		shoot_timer.start(rate_of_fire)

func _on_MuzzleFX_animation_finished() -> void:
	$MuzzleFX.visible = false
