extends Node2D

export(PackedScene) var bullet = preload("res://Weapons/Cannon/Bullet.tscn")
export(float) var rate_of_fire = 0.3

onready var shoot_timer = $ShootTimer
onready var shoot_sound : AudioStreamPlayer = $ShootFX

var can_fire: bool = true
var is_casting := false setget set_is_casting

var sound_pitch := 1.0
var max_sound_pitch := 4.0
onready var default_sound_pitch : float= sound_pitch

func fire() -> void:
	shoot_sound.play()
	shoot_sound.set_pitch_scale(sound_pitch)
	sound_pitch += 0.2
	sound_pitch = clamp(sound_pitch, default_sound_pitch, max_sound_pitch)
	
	var new_bullet : RigidBody2D = bullet.instance()
	new_bullet.transform = $Muzzle.global_transform
	new_bullet.rotation = new_bullet.rotation + PI / 2
	new_bullet.apply_central_impulse(Vector2.UP.rotated(get_parent().rotation) * 400.0)
	get_parent().get_parent().get_parent().add_child(new_bullet)
	
	#new_bullet.position = get_parent().transform.xform($Muzzle.position)
	#new_bullet.rotation = get_parent().rotation
	
func set_is_casting(cast: bool) -> void:
	is_casting = cast
	
	if is_casting:
		if shoot_timer.is_stopped():
			sound_pitch = default_sound_pitch
			fire()
			shoot_timer.start(0.3)
	else:
		#shoot_timer.stop()
		pass
		
func _on_ShootTimer_timeout() -> void:
	if is_casting:
		fire()
		shoot_timer.start(0.3)
