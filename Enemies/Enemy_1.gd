class_name Enemy
extends KinematicBody2D

export var max_speed := 100.0
export var dodge_speed := 20.0
export var drag := 8.0

var _target: Player = null
var _velocity := Vector2.ZERO

var max_health := 5.0
onready var health = max_health

func _physics_process(delta: float) -> void:
	if not _target:
		return
					
#	if position.distance_to(_target.position) > 100:
#		var direction := global_position.direction_to(_target.global_position)
#		var desired_velocity := direction * max_speed
#		var steering := desired_velocity - _velocity
#
#		_velocity += steering / drag
		
#	$VisionRaycasts.rotation += delta * 11 * PI
	for raycast in $VisionRaycasts.get_children():
		if raycast.is_colliding():
			_velocity += raycast.get_collision_normal() * dodge_speed
		
		
	_velocity = _velocity.clamped(max_speed)
	rotation = _velocity.angle() + PI / 2
	_velocity = move_and_slide(_velocity)

func take_damage(amount) -> void:
	_set_health(health - amount)

func _set_health(value) -> void:
	health = clamp(value, 0, max_health)
	if (health == 0):
		queue_free()

func _on_DetectionArea_body_entered(body: Player) -> void:
	_target = body

func _on_DetectionArea_body_exited(body: Player) -> void:
	_target = null
