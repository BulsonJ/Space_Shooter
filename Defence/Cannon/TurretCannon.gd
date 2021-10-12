extends Turret

export(float) var rate_of_fire = 0.2
export(PackedScene) var bullet = preload("res://Defence/Cannon/AlliedBullet.tscn")

onready var turret := $Turret
onready var default_rotation = turret.rotation
var weapon_ready := true

onready var turret_direct_sight = $Turret/RayCast2D

signal turret_shoot(bullet, location, direction, velocity)

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

func _physics_process(delta: float) -> void:
	if _target == null:
		return
	else:
		if turret_direct_sight.is_colliding():
			if turret_direct_sight.get_collider() is Enemy:
				if weapon_ready:
					$ShootFX.play()
					emit_signal("turret_shoot", bullet, $Turret/Muzzle.global_position, Vector2.RIGHT.rotated(turret.global_rotation), 400.0)
					$WeaponShootTimer.start(rate_of_fire)
					weapon_ready = false
					
				# TODO: If gun can't shoot, choose next closest target
		
		turret.look_at(_target.position)
		turret.rotation = clamp(turret.rotation, default_rotation - PI / 4, default_rotation + PI / 4)

func _on_Turret_Vision_body_exited(body: Enemy) -> void:
	if _target == body:
		_target = null

func get_sorted_targets() -> Enemy:
	var possibleTargets = $Turret_Vision.get_overlapping_bodies()
	possibleTargets.sort_custom(self, "_sort_target")
	return possibleTargets

func _on_TargetListTimer_timeout():
	var targets = get_sorted_targets()
	if targets.size() > 0:
		_target = targets.front()

func _on_WeaponShootTimer_timeout():
	weapon_ready = true
