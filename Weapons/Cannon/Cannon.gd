extends Node2D

export(PackedScene) var bullet = preload("res://Weapons/Cannon/Bullet.tscn")
export(float) var rate_of_fire = 0.3

onready var shoot_timer := $ShootTimer
onready var shoot_sound := $ShootFX

var can_fire: bool = true
var is_casting := false setget set_is_casting

var sound_pitch := 1.0
var max_sound_pitch := 4.0
onready var default_sound_pitch : float= sound_pitch

signal shoot(bullet, location, direction, velocity)

func fire() -> void:
	$MuzzleFX.visible = true
	$MuzzleFX.set_frame(0)
	$MuzzleFX.play("default")
	
	shoot_sound.play()
#	shoot_sound.set_pitch_scale(sound_pitch)
#	sound_pitch += 0.2
#	sound_pitch = clamp(sound_pitch, default_sound_pitch, max_sound_pitch)
		
	emit_signal("shoot", bullet, to_global($Muzzle.position), Vector2.RIGHT.rotated(get_parent().rotation), 400.0)
	
func set_is_casting(cast: bool) -> void:
	is_casting = cast
	
	if is_casting:
		if shoot_timer.is_stopped():
			sound_pitch = default_sound_pitch
			fire()
			shoot_timer.start(rate_of_fire)
	else:
		#shoot_timer.stop()
		pass
		
func _on_ShootTimer_timeout() -> void:
	if is_casting:
		fire()
		shoot_timer.start(rate_of_fire)

func _on_MuzzleFX_animation_finished() -> void:
	$MuzzleFX.visible = false
