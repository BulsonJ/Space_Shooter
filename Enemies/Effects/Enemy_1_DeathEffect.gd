extends AnimatedSprite

func _ready():
	play("default")
	rotation_degrees = rand_range(0, 360)

func _on_Enemy_1_DeathEffect_animation_finished():
	queue_free()
