class_name Player
extends KinematicBody2D

export var max_speed := 128.0
export var acceleration := 32.0
export var horizontal_acceleration := 16.0
export var backwards_acceleration := 8.0
export var slowdown_drag := 0.5
export var turning_drag := 16.0
export var rotation_speed := 32.0

var _velocity := Vector2.ZERO
var last_thrust := Vector2.ZERO

onready var ship := $Ship
onready var weapon_slot := $WeaponSlot
onready var animation_player := $AnimationPlayer

onready var laser = preload("res://Weapons/LaserBeam/LaserBeam.tscn")
onready var cannon = preload("res://Weapons/Cannon/Cannon.tscn")

signal player_shoot(bullet, location, direction)

export (Resource) var health
export (Resource) var fuel
export (Resource) var currency

var targetable = true

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("shoot"):
		weapon_slot.fire()
	if event.is_action_released("shoot"):
		weapon_slot.stop_firing()
	if event.is_action_pressed("weapon_1"):
		weapon_slot.change_weapon(cannon)
	if event.is_action_pressed("weapon_2"):
		weapon_slot.change_weapon(laser)

func _physics_process(delta: float) -> void:
	var thrust := Vector2(Input.get_action_strength("turn_right") - Input.get_action_strength("turn_left"),
	Input.get_action_strength("move_up") - Input.get_action_strength("move_down"))

	_velocity += thrust.y * acceleration * Vector2.RIGHT.rotated(ship.rotation)
	_velocity += thrust.x * horizontal_acceleration * Vector2.RIGHT.rotated(ship.rotation + PI / 2)
	
	if Input.get_action_strength("ship_brake") == 1:
		_velocity = lerp(_velocity, Vector2.ZERO, delta)

	if thrust.y > 0:
		animation_player.play("engine_thrust")
	else:
		animation_player.play("engine_thrust_stop")
	
	last_thrust = thrust
	
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

func rotate_ship(target_position: Vector2, delta: float):
	var v = target_position - global_position
	var angle = v.angle()
	var r = ship.global_rotation
	var angle_delta = rotation_speed * delta
	angle = lerp_angle(r, angle, 1.0)
	angle = clamp(angle, r - angle_delta, r + angle_delta)
	ship.global_rotation = lerp_angle(r, angle, 0.2)
