extends TextureProgress

export (Resource) var player_health


func _ready():
	if player_health:
		player_health.connect("health_amount_changed", self, "_on_Player_health_amount_changed")

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta: float) -> void:
#	pass


func _on_Player_health_amount_changed(current_health) -> void:
	value = current_health
