extends Camera2D

export(NodePath) var actor_to_follow
onready var _actor = get_node(actor_to_follow)
export var offset_amount = 250.0

export var decay = 0.8  # How quickly the shaking stops [0, 1].
export var max_offset = Vector2(100, 75)  # Maximum hor/ver shake in pixels.
export var max_roll = 0.1  # Maximum rotation in radians (use sparingly).

var trauma = 0.0  # Current shake strength.

var trauma_power = 2  # Trauma exponent. Use [2, 3].

onready var noise = OpenSimplexNoise.new()
var noise_y = 0

func _ready():
	randomize()
	noise.seed = randi()
	noise.period = 4
	noise.octaves = 2

func _process(delta):
	if _actor.targetable == true:
		var mouse_offset = (get_viewport().get_mouse_position() - get_viewport().size / 2)
		position = _actor.position + lerp(Vector2(), mouse_offset.normalized() * offset_amount, mouse_offset.length() / 1000)

	if trauma:
		trauma = max(trauma - decay * delta, 0)
		shake()

func add_trauma(amount):
	trauma = min(trauma + amount, 1.0)

func shake():
	var amount = pow(trauma, trauma_power)
	noise_y += 1
	rotation = max_roll * amount * noise.get_noise_2d(noise.seed, noise_y)
	offset.x = max_offset.x * amount * noise.get_noise_2d(noise.seed*2, noise_y)
	offset.y = max_offset.y * amount * noise.get_noise_2d(noise.seed*3, noise_y)

func _on_SpaceStation_health_amount_changed(_health) -> void:
	add_trauma(0.1)
