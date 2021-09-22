extends StaticBody2D


# Declare member variables here. Examples:
# var a: int = 2
# var b: String = "text"

onready var turret_amount = $Defences.get_child_count()

signal base_turret_shoot(bullet, location, direction, velocity)
signal base_destroyed()

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta: float) -> void:
#	pass


func _on_EnemyTurret_turret_shoot(bullet, location, direction, velocity) -> void:
	emit_signal("base_turret_shoot", bullet, location,direction, velocity)

func _on_EnemyTurret_turret_destroyed() -> void:
	turret_amount -= 1
	
	if turret_amount <= 0:
		emit_signal("base_destroyed")
		$Sprite.texture = load("res://Enemies/EnemyBase_Destroyed.png")
