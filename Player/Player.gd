class_name Player
extends KinematicBody2D

export var max_speed := 350.0
export var drag := 8.0

export var turning_drag := 8.0

var _velocity := Vector2.ZERO

onready var weapon_slot = $WeaponSlot

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("shoot"):
		$WeaponSlot.fire()
	if event.is_action_released("shoot"):
		$WeaponSlot.stop_firing()

func _physics_process(_delta: float) -> void:
	var direction := Vector2(Input.get_action_strength("move_right") - Input.get_action_strength("move_left"), Input.get_action_strength("move_down") - Input.get_action_strength("move_up")).normalized()
	
	var desired_velocity = direction * max_speed
	var steering = desired_velocity - _velocity
	_velocity += steering / drag
	_velocity = _velocity.clamped(max_speed)
	
	_velocity = move_and_slide(_velocity)
	
	# Slow rotation down so not instant
	var desired_rotation = get_global_mouse_position()
	var current_rotation = (get_global_mouse_position() - position)
	
	look_at(desired_rotation)
