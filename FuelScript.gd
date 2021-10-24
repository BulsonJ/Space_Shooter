extends Resource

signal fuel_amount_changed(current_fuel)

var max_fuel := 100.0
var fuel := 0.0 setget _set_fuel_amount

func _init() -> void:
	fuel = max_fuel
	
func use_fuel(amount) -> void:
	_set_fuel_amount(fuel - amount)

func _set_fuel_amount(value) -> void:
	fuel = clamp(value, 0, max_fuel)
	emit_signal("fuel_amount_changed", fuel)
	if (fuel == 0):
		# TODO: Implement fuel empty mechanic
		pass		
