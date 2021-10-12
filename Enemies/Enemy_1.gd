extends Enemy

export var max_speed := 100.0
export var dodge_speed := 20.0
export var drag := 8.0

export var engage_distance := 250.0

var main_target : Node
var _target: Player = null
var _velocity := Vector2.ZERO

onready var weapon_vision := $Weapon_Vision
var weapon_ready := true
export(PackedScene) var bullet = preload("res://Enemies/EnemyBullet.tscn")

signal enemy_shoot(bullet, location, direction, velocity)

func _physics_process(delta: float) -> void:
	if _target && _target.targetable:
		move_toward_target(_target)
		weapon_fire_if_able()
	else:
		if main_target:
			if global_position.distance_to(main_target.global_position) > engage_distance:	
				move_toward_target(main_target)
				weapon_fire_if_able()
				
	_velocity = _velocity.linear_interpolate(Vector2.ZERO, delta * drag)
	_velocity = _velocity.clamped(max_speed)
	rotation = _velocity.angle() + PI / 2
	_velocity = move_and_slide(_velocity)

func move_toward_target(target : Node) -> void:
	var direction := global_position.direction_to(target.global_position)
	var desired_velocity := direction * max_speed
	var steering := desired_velocity - _velocity
	
	_velocity += steering / drag

func weapon_fire_if_able() -> void:
	if weapon_vision.is_colliding():
		if weapon_ready:
			weapon_ready = false
			$Weapon_Timer.start(1.0)
			emit_signal("enemy_shoot", bullet, $Muzzle.global_position, Vector2.RIGHT.rotated(global_rotation - PI / 2), 400.0)

func _on_DetectionArea_body_entered(body: Player) -> void:
	_target = body

func _on_DetectionArea_body_exited(body: Player) -> void:
	_target = null

func _on_Weapon_Timer_timeout() -> void:
	weapon_ready = true
