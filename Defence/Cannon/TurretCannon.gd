class_name Turret
extends StaticBody2D

export(float) var rate_of_fire = 3.0
export(float) var max_health = 5.0
onready var health = max_health

var _target : Enemy = null

onready var turret := $Turret
onready var default_rotation = turret.rotation
export(PackedScene) var bullet = preload("res://Defence/Cannon/AlliedBullet.tscn")
var weapon_ready = true

onready var turret_direct_sight = $Turret/RayCast2D

signal turret_shoot(bullet, location, direction, velocity)
signal turret_destroyed()

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

func _physics_process(delta: float) -> void:
	if _target == null:
		var targets = get_sorted_targets()
		if targets.size() > 0:
			_target = get_sorted_targets().front()
		if $TargetRefreshTimer.is_stopped():
			$TargetRefreshTimer.start(1)
	else:
		if turret_direct_sight.is_colliding():
			if turret_direct_sight.get_collider() is Enemy:
				if weapon_ready:
					$ShootFX.play()
					emit_signal("turret_shoot", bullet, $Turret/Muzzle.global_position, Vector2.RIGHT.rotated(turret.global_rotation), 400.0)
					$ShootTimer.start(rate_of_fire)
					weapon_ready = false
					
				# TODO: If gun can't shoot, choose next closest target
		
		turret.look_at(_target.position)
		turret.rotation = clamp(turret.rotation, default_rotation - PI / 4, default_rotation + PI / 4)

func _on_Turret_Vision_body_exited(body: Enemy) -> void:
	if _target == body:
		_target = null
	
func _on_Timer_timeout() -> void:
	weapon_ready = true
	
func take_damage(amount: float) -> void:
	_set_health(health - amount)

func _set_health(value) -> void:
	health = clamp(value, 0, max_health)
	if (health == 0):
		queue_free()
		emit_signal("turret_destroyed")
		
# Custom sort function used to sort targets into distance to turret
func _sort_target(a : Enemy,b: Enemy) -> bool:
	if a != null and b != null:
		return a.global_position.distance_to(global_position) < b.global_position.distance_to(global_position)
	else:
		return false
		
func _on_TargetRefreshTimer_timeout() -> void:
	var targets = get_sorted_targets()
	if targets.size() > 0:
		_target = get_sorted_targets().front()
	
func get_sorted_targets() -> Enemy:
	var possibleTargets = $Turret_Vision.get_overlapping_bodies()
	possibleTargets.sort_custom(self, "_sort_target")
	return possibleTargets
