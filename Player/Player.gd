class_name Player
extends KinematicBody2D

export var max_speed := 128.0
export var acceleration := 32.0
export var horizontal_acceleration := 16.0
export var backwards_acceleration := 8.0
export var rotation_speed := 32.0

var _velocity := Vector2.ZERO
var _last_thrust:= Vector2.ZERO
var _ship_brake := true

onready var ship := $Ship
onready var weapon_slot := $WeaponSlot
onready var animation_player := $AnimationPlayer

onready var laser = preload("res://Weapons/LaserBeam/LaserBeam.tscn")
onready var cannon = preload("res://Weapons/Cannon/Cannon.tscn")

signal player_shoot(bullet, location, direction)
signal player_brake(brake_value)

export (Resource) var health
export (Resource) var fuel
export (Resource) var currency
export (Resource) var player_technology
var targetable = true

func _ready() -> void:
	animation_player.play("ready")

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("shoot"):
		weapon_slot.fire()
	if event.is_action_released("shoot"):
		weapon_slot.stop_firing()
	if event.is_action_pressed("weapon_1"):
		weapon_slot.change_weapon(cannon)
	if event.is_action_pressed("weapon_2"):
		player_technology.unlock_tech(0)
	if event.is_action_pressed("ship_brake"):
		_ship_brake = !_ship_brake
		emit_signal("player_brake", _ship_brake)

func _physics_process(delta: float) -> void:
	var thrust := Vector2(Input.get_action_strength("turn_right") - Input.get_action_strength("turn_left"),
	Input.get_action_strength("move_up") - Input.get_action_strength("move_down"))

	_velocity += thrust.x * horizontal_acceleration * Vector2.RIGHT.rotated(ship.rotation + PI / 2)
	if thrust.y > 0:
		_velocity += thrust.y * acceleration * Vector2.RIGHT.rotated(ship.rotation)
	elif thrust.y < 0:
		_velocity += thrust.y * backwards_acceleration * Vector2.RIGHT.rotated(ship.rotation)
	
	if _ship_brake:
		_velocity = lerp(_velocity, Vector2.ZERO, delta)

	if thrust.y > 0:
		animation_player.play("engine_thrust")
	elif thrust != _last_thrust:
		animation_player.play("engine_thrust_stop")
	_last_thrust = thrust
	
	_velocity = _velocity.clamped(max_speed)
	_velocity = move_and_slide(_velocity)	
	
	rotate_ship(get_global_mouse_position(), delta)

func _on_WeaponSlot_weapon_shoot(bullet, location, direction) -> void:
	emit_signal("player_shoot", bullet, location, direction)
		
func stop_ship() -> void:
	animation_player.play("engine_thrust_stop")
	weapon_slot.stop_firing()
	
func take_damage(weapon_damage: int) -> void:
	health.remove_health(weapon_damage)
	frame_freeze(0.05, 0.5)
	$Ship/Spaceship.material.set_shader_param("flash_modifier", 1)
	$WeaponSlot/Cannon.weapon_sprite.material.set_shader_param("flash_modifier", 1)
	yield(get_tree().create_timer(0.01), "timeout")
	$Ship/Spaceship.material.set_shader_param("flash_modifier", 0)
	$WeaponSlot/Cannon.weapon_sprite.material.set_shader_param("flash_modifier", 0)

func rotate_ship(target_position: Vector2, delta: float):
	var v = target_position - global_position
	var angle = v.angle()
	var r = ship.global_rotation
	var angle_delta = rotation_speed * delta
	angle = lerp_angle(r, angle, 1.0)
	angle = clamp(angle, r - angle_delta, r + angle_delta)
	ship.global_rotation = lerp_angle(r, angle, 0.2)
	
func frame_freeze(timeScale, duration) -> void:
	Engine.time_scale = timeScale
	yield(get_tree().create_timer(duration * timeScale), "timeout")
	Engine.time_scale = 1
