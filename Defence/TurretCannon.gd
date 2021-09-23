extends Node2D

export(float) var max_health = 5.0
onready var health = max_health

var _target : Enemy = null

onready var turret := $Turret
onready var default_rotation = turret.rotation
export(PackedScene) var bullet = preload("res://Defence/AlliedBullet.tscn")
var weapon_ready = true

onready var turret_direct_sight = $Turret/RayCast2D

signal turret_shoot(bullet, location, direction, velocity)
signal turret_destroyed()

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

func _physics_process(delta: float) -> void:
	if _target == null:
		_target = get_closest_target()
	else:
		if turret_direct_sight.is_colliding():
			if turret_direct_sight.get_collider() is Enemy:
				if weapon_ready:
					$ShootFX.play()
					emit_signal("turret_shoot", bullet, $Turret/Muzzle.global_position, Vector2.RIGHT.rotated(turret.global_rotation), 400.0)
					$ShootTimer.start(1.0)
					weapon_ready = false
		
		if $TargetRefreshTimer.is_stopped():
			$TargetRefreshTimer.start(2)
			_target = get_closest_target()
		
		turret.look_at(_target.position)
		turret.rotation = clamp(turret.rotation, default_rotation - PI / 4, default_rotation + PI / 4)

func _on_Turret_Vision_body_exited(body: Enemy) -> void:
	if _target == body:
		_target = null

func get_closest_target() -> Enemy:
	var possibleTargets = $Turret_Vision.get_overlapping_bodies()
	var closestTarget : Enemy = null
	if possibleTargets.size() > 0:
		closestTarget = possibleTargets.front()
		var closestDistance : float = closestTarget.position.distance_to(position)
		for target in possibleTargets:
			# BUG : Not choosing closest, choosing left to right. Maybe global positioning?
			var targetDistance = target.position.distance_to(position)
			if closestDistance > targetDistance:
				closestTarget = target
	return closestTarget

func _on_Timer_timeout() -> void:
	weapon_ready = true
	
func take_damage(amount: float) -> void:
	_set_health(health - amount)

func _set_health(value) -> void:
	health = clamp(value, 0, max_health)
	if (health == 0):
		queue_free()
		emit_signal("turret_destroyed")

