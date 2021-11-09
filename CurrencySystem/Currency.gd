extends Area2D

# The drag is a divider which controls the coin's acceleration and the time it
# takes to change direction. A higher value makes it less reactive.
const DRAG := 14.0
var max_speed := 200.0

var _velocity := Vector2.ZERO

func _ready() -> void:
	
	var error_code := connect("body_entered", self, "_on_body_entered")
	if error_code != 0:
		print("ERROR: ", error_code)

	rotation_degrees = rand_range(0, 360)
	
	$Tween.interpolate_property(self, "scale", Vector2(0,0), Vector2(0.5,0.5), 1.0)
	$Tween.interpolate_property(self, "rotation_degrees", rotation_degrees, rand_range(0, 360), 0.5)
	$Tween.start()
	_velocity = Vector2(rand_range(-1, 1),rand_range(-1, 1)).normalized() * (rand_range(50.0, 150.0))
	

# We destroy the coin upon detecting a collision with the player.
func _on_body_entered(_body: Player) -> void:
	_body.currency.add(2)
	queue_free()

func _physics_process(delta: float) -> void:
	# We detect attractors using `get_overlapping_areas()`
	var attractors := get_overlapping_areas()

	# If there is one or more overlapping areas, we steer towards the first one.
	if attractors:
		# The desired velocity is a vector of length `max_speed` pointing
		# towards the player.
		var desired_velocity: Vector2 = (
			(attractors[0].global_position - global_position).normalized()
			* max_speed
		)
		# The follow steering equation works like so:
		#
		# 1. We calculate the difference between the desired and current velocity.
		# 2. We add a fraction of that difference to the current velocity.
		var steering := desired_velocity - _velocity
		_velocity += steering / 14.0
	else:
		var steering := Vector2.ZERO - _velocity
		_velocity += steering / 28.0

	position += _velocity * delta
