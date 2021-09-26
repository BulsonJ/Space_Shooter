extends Control


func _ready() -> void:
	modulate = Color(1, 1, 1, 0)
	visible = false
	
func show_ui(time : float) -> void:
	visible = true
	$Tween.interpolate_property(self, "modulate", 
	  Color(1, 1, 1, 0), Color(1, 1, 1, 1), time)
	$Tween.start()
	
func hide_ui(time : float) -> void:
	visible = false
	$Tween.interpolate_property(self, "modulate", 
	  Color(1, 1, 1, 1), Color(1, 1, 1, 0), time)
	$Tween.start()


func _on_SpaceStation_player_docked(animation_time) -> void:
	show_ui(animation_time)


func _on_SpaceStation_player_undocked(animation_time) -> void:
	hide_ui(animation_time)
