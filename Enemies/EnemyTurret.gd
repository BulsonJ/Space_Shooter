extends Node2D

export(float) var max_health = 5.0
onready var health = max_health

var _target : Player = null

onready var turret := $Turret
onready var default_rotation = turret.rotation
export(PackedScene) var bullet = preload("res://Enemies/EnemyBullet.tscn")
var weapon_ready = true

onready var turret_direct_sight = $Turret/RayCast2D

signal turret_shoot(bullet, location, direction, velocity)
signal turret_destroyed()

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

func _physics_process(delta: float) -> void:
	if !_target:
		return
	else:
		if turret_direct_sight.is_colliding():
			if turret_direct_sight.get_collider() is Player:
				if weapon_ready:
					$ShootFX.play()
					emit_signal("turret_shoot", bullet, $Turret/Muzzle.global_position, Vector2.RIGHT.rotated(turret.global_rotation), 400.0)
					$Timer.start(1.0)
					weapon_ready = false
		

	turret.look_at(_target.position)
	turret.rotation = clamp(turret.rotation, default_rotation - PI / 4, default_rotation + PI / 4)
	
func _on_Turret_Vision_body_entered(body: Player) -> void:
	_target = body

func _on_Turret_Vision_body_exited(body: Player) -> void:
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
