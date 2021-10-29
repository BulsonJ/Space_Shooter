class_name Player
extends KinematicBody2D

export var max_speed := 128.0
export var acceleration := 32.0
export var backwards_acceleration := 8.0
export var slowdown_drag := 1.5
export var turning_drag := 16.0

var _velocity := Vector2.ZERO

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
var last_thrust := 0.0

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
	var thrust := Input.get_action_strength("move_up") - Input.get_action_strength("move_down")
	var _direction := Input.get_action_strength("move_right") - Input.get_action_strength("move_left")
	ship.rotation += _direction / turning_drag
	
	# Calculate movement for ship and play animation
	if thrust == 0:
		if last_thrust != thrust:
			animation_player.play("engine_thrust_stop")
		_velocity = _velocity.linear_interpolate(Vector2.ZERO, delta * slowdown_drag)
	elif thrust < 0:
		fuel.use_fuel(abs(thrust / 10.0))
		_velocity += thrust * backwards_acceleration * Vector2.RIGHT.rotated(ship.rotation)
	elif thrust > 0:
		fuel.use_fuel(abs(thrust / 10.0))
		_velocity += thrust * acceleration * Vector2.RIGHT.rotated(ship.rotation)
		animation_player.play("engine_thrust")
		
	last_thrust = thrust
	
	_velocity = _velocity.clamped(max_speed)
	_velocity = move_and_slide(_velocity)	
	
	weapon_slot.rotation = get_global_mouse_position().angle_to_point(position)

func _on_WeaponSlot_weapon_shoot(bullet, location, direction) -> void:
	emit_signal("player_shoot", bullet, location, direction)
		
func stop_ship() -> void:
	animation_player.play("engine_thrust_stop")
	weapon_slot.stop_firing()
