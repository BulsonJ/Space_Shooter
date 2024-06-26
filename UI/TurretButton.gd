extends TextureButton

export var radius = 60
export var speed = 0.25
export var turret_index = 0

var turret_manager = null
var player_currency = null

var num
var active := false
var clicks := 1

func _ready() -> void:
	$Buttons.hide()
	num = $Buttons.get_child_count()
	for b in $Buttons.get_children():
		if b != $Buttons.get_node("TurretButtonBuy"):
			b.rect_position = rect_position
			b.connect("pressed", self, "hide_menu")

func show_menu() -> void:
	$Buttons.show()
	var spacing = TAU / num
	for b in $Buttons.get_children():
		var a = spacing * b.get_position_in_parent() - PI / 2
		var dest = b.rect_position + Vector2(radius, 0).rotated(a)
		$Tween.interpolate_property(b, "rect_position", b.rect_position,
				dest, speed, Tween.TRANS_BACK, Tween.EASE_OUT)
		$Tween.interpolate_property(b, "rect_scale", Vector2(0.5, 0.5),
				Vector2.ONE, speed, Tween.TRANS_LINEAR)
	$Tween.start()

func hide_menu() -> void:
	for b in $Buttons.get_children():
		$Tween.interpolate_property(b, "rect_position", b.rect_position,
				rect_position, speed, Tween.TRANS_BACK, Tween.EASE_IN)
		$Tween.interpolate_property(b, "rect_scale", null,
				Vector2(0.5, 0.5), speed, Tween.TRANS_LINEAR)
	$Tween.start()

func _on_RadialMenuButton_pressed() -> void:
	clicks += 1
	disabled = true
	if active:
		hide_menu()
	else:
		show_menu()

func _on_Tween_tween_all_completed() -> void:
	disabled = false
	active = not active
	if not active:
		$Buttons.hide()

func _on_TurretButton_Sell_pressed() -> void:
	if turret_manager.get_turret(turret_index) != null:
		turret_manager.delete_turret(turret_index)
		player_currency.add(10)

func _on_TurretButton_Repair_pressed() -> void:
	turret_manager.repair_turret(turret_index)

func _on_ButtonBeam_pressed():
	turret_manager.place_turret(turret_index, turret_manager.turret_types.beam)
	player_currency.spend(50)

func _on_ButtonCannon_pressed():
	turret_manager.place_turret(turret_index, turret_manager.turret_types.cannon)
	player_currency.spend(20)
