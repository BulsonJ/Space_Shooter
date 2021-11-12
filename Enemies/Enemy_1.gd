extends Enemy

export var max_speed := 100.0
export var dodge_speed := 20.0
export var drag := 8.0

export var engage_distance := 200.0
var _target: Player = null
var main_target : Node
var _defence_target : Node

var _velocity := Vector2.ZERO

onready var weapon_vision := $Weapon_Vision
var weapon_ready := true
export(PackedScene) var bullet = preload("res://Enemies/EnemyBullet.tscn")

onready var animation_player = $AnimationPlayer

const DeathEffect = preload("res://Enemies/Effects/Enemy_1_DeathEffect.tscn")
const Currency = preload("res://CurrencySystem/Currency.tscn")

func _physics_process(delta: float) -> void:
	weapon_fire_if_able()
	
	if _defence_target:
		if global_position.distance_to(_defence_target.global_position) > engage_distance:	
			move_toward_target(_defence_target)
	elif _target && _target.targetable:
		if _target && _target.targetable:
			move_toward_target(_target)
	elif main_target:
		if global_position.distance_to(main_target.global_position) > engage_distance:	
			move_toward_target(main_target)
			
	_velocity = _velocity.linear_interpolate(Vector2.ZERO, delta * drag)
	_velocity = _velocity.clamped(max_speed)
	rotation = _velocity.angle() + PI / 2
	_velocity = move_and_slide(_velocity)

func move_toward_target(target : Node) -> void:
	var direction := global_position.direction_to(target.global_position)
	var desired_velocity := direction * max_speed
	var steering := desired_velocity - _velocity
	
	_velocity += steering / drag

func weapon_fire_if_able() -> void:
	if weapon_vision.is_colliding():
		if weapon_ready:
			weapon_ready = false
			$Weapon_Timer.start(2.0)
			#$ShootFX.play()
			Events.emit_signal("bullet_shoot", bullet, $Muzzle.global_position, Vector2.RIGHT.rotated(global_rotation - PI / 2))

func _on_DetectionArea_body_entered(body: Node) -> void:
	if body is Player:
		_target = body
	else:
		_defence_target = body

func _on_DetectionArea_body_exited(body: Node) -> void:
	if body is Player:
		_target = null
	else:
		_defence_target = null

func _on_Weapon_Timer_timeout() -> void:
	weapon_ready = true
	
func create_death_effect() -> void:
	var world = get_tree().current_scene
	
	var amount := int(rand_range(1,3))
	for i in amount:
		var currency_pickup = Currency.instance()
		world.call_deferred("add_child", currency_pickup)
		currency_pickup.global_position = global_position
	
	var effect = DeathEffect.instance()
	world.add_child(effect)
	effect.global_position = global_position
	
func take_damage(amount: float) -> void:
	.take_damage(amount)
	animation_player.play("hit")
	
func _set_health(value) -> void:
	health = clamp(value, 0, max_health)
	if (health == 0):
		emit_signal("enemy_destroyed")
		create_death_effect()
		queue_free()
		

