extends RayCast2D

# Credit to @GDQuest for the laserbeam implementation

# Speed at which the laser extends when first fired, in pixels per seconds.
export var cast_speed := 7000.0
# Maximum length of the laser in pixels.
export var max_length := 1400.0
# Base duration of the tween animation in seconds.
export var growth_time := 0.1

export var weapon_damage := 1.0
export var weapon_time := 1.0
export(Color) var weapon_hit_color = Color(255,255,255)

# If `true`, the laser is firing.
# It plays appearing and disappearing animations when it's not animating.
# See `appear()` and `disappear()` for more information.
var is_casting := false setget set_is_casting

onready var tween := $Tween
onready var fill := $FillLine2D
onready var collision_particles := $CollisionParticles2D
onready var collision_point := $CollisionPoint/CollisionShape2D

onready var hit_tween := $HitTween
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
		# Reset the cast_to point and line, then show the beam
		cast_to = Vector2.ZERO
		fill.points[1] = cast_to
		
		# Start damage timer and change weapon colour
		damage_timer.start(weapon_time)
		if hit_tween.is_active():
			hit_tween.stop_all()
		hit_tween.interpolate_property(fill, "default_color", weapon_default_color, weapon_hit_color, weapon_time, Tween.TRANS_LINEAR)
		hit_tween.start()
		
		appear()
	else:
		# Stop the particles and hide the beam
		collision_particles.emitting = false
		collision_point.disabled = true
		damage_timer.stop()
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
		collision_point.disabled = false

	# Set the end point of the line to the cast point
	fill.points[1] = cast_point
	collision_point.position = cast_point

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

var _body_hit : Node = null

# Beam now tweens to a hit colour when damage is done. 
# However, current implementation is weird and means beam has to explicitly stay on target for 1s to do damage. 
# Beam should just do damage to whatever is there for every 1s held down.

# Beam charges to do 1 damage per second vs Beam needs 1s on target to do dmg
# left implementation makes more sense

# When beam hits enemy, start damage timer
func _on_CollisionPoint_body_entered(body: Node) -> void:
	_body_hit = body

func _on_CollisionPoint_body_exited(body: Node) -> void:
	_body_hit = null
	
func _on_DamageTimer_timeout() -> void:
	if (_body_hit):
		if _body_hit.has_method("take_damage"):
			_body_hit.take_damage(weapon_damage)
			
	if hit_tween.is_active():
		hit_tween.stop_all()
	hit_tween.interpolate_property(fill, "default_color", weapon_default_color, weapon_hit_color, weapon_time, Tween.TRANS_LINEAR)
	hit_tween.start()

