extends Resource
class_name PlayerCurrency

signal currency_amount_changed(current_amount)

export var initial_currency := 100
var currency := 0 setget _set_currency_amount

func _init() -> void:
	currency = initial_currency
	
func spend(amount) -> void:
	_set_currency_amount(currency - amount)

func add(amount) -> void:
	_set_currency_amount(currency + amount)

func _set_currency_amount(value) -> void:
	currency = clamp(value, 0, value)
	emit_signal("currency_amount_changed", currency)
