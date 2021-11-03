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
		b.rect_position = rect_position
		b.connect("pressed", self, "hide_menu")

func show_menu() -> void:
	$Buttons.show()
	var spacing = TAU / num
	for b in $Buttons.get_children():
		var a = spacing * b.get_position_in_parent() - PI / 2
		var dest = Vector2.ZERO + Vector2(radius, 0).rotated(a)
		$Tween.interpolate_property(b, "rect_position", Vector2.ZERO,
				dest, speed, Tween.TRANS_BACK, Tween.EASE_OUT)
		$Tween.interpolate_property(b, "rect_scale", Vector2(0.5, 0.5),
				Vector2.ONE, speed, Tween.TRANS_LINEAR)
	$Tween.start()

func hide_menu() -> void:
	for b in $Buttons.get_children():
		$Tween.interpolate_property(b, "rect_position", b.rect_position,
				Vector2.ZERO, speed, Tween.TRANS_BACK, Tween.EASE_IN)
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

