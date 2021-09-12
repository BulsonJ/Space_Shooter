extends Node2D

# WeaponSlot node is used to store a weapon. Holds methods to change what weapon is equipped in the slot.
# Weapon can be used using fire() method.
# For held weapons, stop_firing() can be called on key release to stop the weapon

func change_weapon(weapon: PackedScene) -> void:
	var currentWeapon = get_child(0)
	currentWeapon.queue_free()
	
	add_child(weapon.instance())
	
	# NOTE : Works to switch weapons but creating a new instance of scene everytime. Maybe 
	# the weapon should be saved somehow so that a new instance does not need to be?
		
func fire() -> void:
	var weapon = get_child(0)
	if weapon.has_method("set_is_casting"):
		weapon.is_casting = true
	elif weapon.has_method("fire"):
		weapon.fire()

func stop_firing() -> void:
	var weapon = get_child(0)
	if weapon.has_method("set_is_casting"):
		weapon.is_casting = false
