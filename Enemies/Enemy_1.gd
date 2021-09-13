class_name Enemy
extends KinematicBody2D

var speed := 100.0

var _target: Player = null
var _velocity := Vector2.ZERO

var max_health := 5.0
onready var health = max_health

func _physics_process(delta: float) -> void:
	 # In the absence of a target, we return from the function, causing the
	# enemy to stay idle.
	if not _target:
		return

	# With a target, we steer towards it.
	# The equation is the same as in the previous example.
	var direction := global_position.direction_to(_target.global_position)
	var desired_velocity := direction * speed
	var steering := desired_velocity - _velocity

	_velocity += steering / 20.0

	# We rotate to look where we're moving.
	rotation = _velocity.angle() + PI / 2
	# Finally, we move towards the target
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
