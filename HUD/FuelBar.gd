extends TextureProgress

export (Resource) var player_fuel


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	if player_fuel:
		player_fuel.connect("fuel_amount_changed", self, "_on_Player_fuel_amount_changed")


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta: float) -> void:
#	pass


func _on_Player_fuel_amount_changed(current_fuel) -> void:
	value = current_fuel
