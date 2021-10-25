extends PanelContainer

export (Resource) var player_currency

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	if player_currency:
		player_currency.connect("currency_amount_changed", self, "_on_player_currency_amount_changed")
	player_currency.spend(0)


func _on_player_currency_amount_changed(current_currency) -> void:
	$HBoxContainer/Label.text = current_currency as String
