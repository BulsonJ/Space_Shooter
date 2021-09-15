class_name Enemy
extends KinematicBody2D

var speed := 100.0

var _target: Player = null
var _wander_target: Player = null
var _velocity := Vector2.ZERO

var max_health := 2.0
onready var health = max_health

enum state{
	WANDER
	CHASE
}

var currentState = state.WANDER

func _physics_process(delta: float) -> void:
	if not _target:
		return
		
	var direction := global_position.direction_to(_target.global_position)
	var desired_velocity := direction * speed
	var steering := desired_velocity - _velocity

	_velocity += steering / 20.0

	rotation = _velocity.angle() + PI / 2
	
	move_and_slide(_velocity)

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

func _on_WanderDetectionArea_body_entered(body: Player) -> void:
	_wander_target = body

func _on_WanderDetectionArea_body_exited(body: Player) -> void:
	_wander_target = null
