extends Node2D

# WeaponSlot node is used to store a weapon. Holds methods to change what weapon is equipped in the slot.
# Weapon can be used using fire() method.
# For held weapons, stop_firing() can be called on key release to stop the weapon

export(NodePath) var initial_weapon = null
export(bool) var rotate_with_node := true
export(NodePath) var rotation_node = get_parent()

var current_weapon : Node = null

func _ready() -> void:
	current_weapon = get_child(0)

func _physics_process(delta: float) -> void:
	if rotate_with_node:
		rotation = get_node(rotation_node).rotation

## Changes the weapon stored in the weapon slot
func change_weapon(weapon: PackedScene) -> void:
	var new_weapon := weapon.instance()
	if new_weapon.has_method("fire") or new_weapon.has_method("set_is_casting"):
		current_weapon.queue_free()
		add_child(new_weapon)
		current_weapon = new_weapon
	
## Fires the weapon in the weapon slot	
func fire() -> void:
	if current_weapon.has_method("set_is_casting"):
		current_weapon.is_casting = true
	elif current_weapon.has_method("fire"):
		current_weapon.fire()

func stop_firing() -> void:
	if current_weapon.has_method("set_is_casting"):
		current_weapon.is_casting = false
