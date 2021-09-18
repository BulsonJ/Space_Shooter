extends RigidBody2D

export(float) var weapon_damage = 1.0

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


func _on_Bullet_body_entered(body: Node) -> void:
	queue_free()
	if body.has_method("take_damage"):
			body.take_damage(weapon_damage)
