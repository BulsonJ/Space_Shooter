extends Enemy

export var max_speed := 100.0
export var dodge_speed := 20.0
export var drag := 8.0

var _target: Player = null
var _velocity := Vector2.ZERO

func _physics_process(delta: float) -> void:
	#if _target:
		#var direction := global_position.direction_to(_target.global_position)
		#var desired_velocity := direction * max_speed
		#var steering := desired_velocity - _velocity
	
		#_velocity += steering / drag
	$VisionRaycasts.rotation += delta * 11 * PI
	for raycast in $VisionRaycasts.get_children():
		if raycast.is_colliding():
			_velocity += raycast.get_collision_normal() * dodge_speed
		
	_velocity = _velocity.linear_interpolate(Vector2.ZERO, delta * drag)
	_velocity = _velocity.clamped(max_speed)
	rotation = _velocity.angle() + PI / 2
	_velocity = move_and_slide(_velocity)

func _on_DetectionArea_body_entered(body: Player) -> void:
	_target = body

func _on_DetectionArea_body_exited(body: Player) -> void:
	_target = null
