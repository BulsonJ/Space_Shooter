extends RayCast2D

# Speed at which the laser extends when first fired, in pixels per seconds.
export var cast_speed := 7000.0
# Maximum length of the laser in pixels.
export var max_length := 1400.0
# Base duration of the tween animation in seconds.
export var growth_time := 0.1

# If `true`, the laser is firing.
# It plays appearing and disappearing animations when it's not animating.
# See `appear()` and `disappear()` for more information.
var is_casting := false setget set_is_casting

onready var tween := $Tween
onready var fill := $FillLine2D
onready var collision_particles := $CollisionParticles2D

onready var line_width: float = fill.width

func _ready() -> void:
	set_physics_process(false)
	fill.points[1] = Vector2.ZERO

func _physics_process(delta: float) -> void:
	# Increases length of the ray every frame, until max length is reached
	cast_to = (cast_to + Vector2.RIGHT * cast_speed * delta).clamped(max_length)
	
	# Checks collisions for length of beam
	cast_beam()

func set_is_casting(cast: bool) -> void:
	is_casting = cast

	if is_casting:
		# Reset the cast_to point and line, then show the beam
		cast_to = Vector2.ZERO
		fill.points[1] = cast_to
		appear()
	else:
		# Stop the particles and hide the beam
		collision_particles.emitting = false
		disappear()

	# Starts/stops physics process
	set_physics_process(is_casting)

func cast_beam() -> void:
	var cast_point := cast_to
	
	# Force update, otherwise may not update till next frame
	force_raycast_update()
	collision_particles.emitting = is_colliding() # Emit particles if there is a collision
	
	if is_colliding():
		# Calculate point where collision occurs for particle
		# Use the collision normal to rotate the angle of the particle system
		cast_point = to_local(get_collision_point())
		collision_particles.global_rotation = get_collision_normal().angle()
		collision_particles.position = cast_point
		
	# Set the end point of the line to the cast point
	fill.points[1] = cast_point

# Functions to show and hide the beam
# Done using tweens, code from @GDQuest

func appear() -> void:
	if tween.is_active():
		tween.stop_all()
	tween.interpolate_property(fill, "width", 0, line_width, growth_time * 2)
	tween.start()

func disappear() -> void:
	if tween.is_active():
		tween.stop_all()
	tween.interpolate_property(fill, "width", fill.width, 0, growth_time)
	tween.start()
