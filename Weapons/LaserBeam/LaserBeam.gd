extends RayCast2D

# Credit to @GDQuest for the initial laserbeam implementation

# Speed at which the laser extends when first fired, in pixels per seconds.
export var cast_speed := 2000.0
# Maximum length of the laser in pixels.
export var max_length := 1400.0
# Base duration of the tween animation in seconds.
export var growth_time := 0.1

export var weapon_damage := 1.0
export var weapon_time := 1.0
export(Color) var weapon_hit_color = Color(255,255,255)

export var weapon_blast_impulse := 1500.0

# If `true`, the laser is firing.
# It plays appearing and disappearing animations when it's not animating.
# See `appear()` and `disappear()` for more information.
var is_casting := false setget set_is_casting

onready var tween := $Tween
onready var fill := $FillLine2D
onready var collision_particles := $CollisionParticles2D
onready var collision_point := $CollisionPoint
onready var collision_point_shape := $CollisionPoint/CollisionShape2D

onready var damage_timer := $DamageTimer
onready var weapon_default_color = fill.default_color


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
		fill.points[1] = cast_to
		
		# Start damage timer
		damage_timer.start(weapon_time)
		
		appear()
	else:
		# Stop the particles and hide the beam
		collision_particles.emitting = false
		collision_point_shape.disabled = true
		damage_timer.stop()
		
		# Reset the cast_to point and line, then show the beam
		cast_to = Vector2.ZERO
		collision_point.position = cast_to
		
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
		collision_point_shape.disabled = false

	# Set the end point of the line to the cast point
	fill.points[1] = cast_point
	collision_point.position = cast_point

# Functions to show and hide the beam
# Done using tweens, code from @GDQuest

func appear() -> void:
	if tween.is_active():
		tween.stop_all()
	tween.interpolate_property(fill, "width", 1, line_width, weapon_time, Tween.TRANS_QUAD)
	tween.interpolate_property(fill, "default_color", weapon_default_color, weapon_hit_color, weapon_time, Tween.TRANS_QUAD)
	tween.start()

func disappear() -> void:
	if tween.is_active():
		tween.stop_all()
	tween.interpolate_property(fill, "width", fill.width, 0, weapon_time / 4)
	tween.start()
	
func _on_DamageTimer_timeout() -> void:	
	$ShootFX.play()	
	var colliders = collision_point.get_overlapping_bodies()
	for body in colliders:
		if body.has_method("take_damage"):
			body.take_damage(weapon_damage)
		
		if body is RigidBody2D:
			var direction = global_position.direction_to(body.global_position)
			body.apply_central_impulse(weapon_blast_impulse * direction)
			
	appear()

