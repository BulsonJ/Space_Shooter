extends Node2D


# Declare member variables here. Examples:
# var a: int = 2
# var b: String = "text"
var _target : Player = null

onready var turret := $Turret
onready var default_rotation = turret.rotation

export(PackedScene) var bullet = preload("res://Enemies/EnemyBullet.tscn")

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

func _physics_process(delta: float) -> void:
	if !_target:
		$Timer.stop()
		return
	else:
		if $Timer.is_stopped():
			$Timer.start(1.0)
		
	
	turret.look_at(_target.position)
	turret.rotation = clamp(turret.rotation, default_rotation - PI / 4, default_rotation + PI / 4)
	
func _on_Turret_Vision_body_entered(body: Player) -> void:
	_target = body


func _on_Turret_Vision_body_exited(body: Player) -> void:
	_target = null


func _on_Timer_timeout() -> void:
	var new_bullet : RigidBody2D = bullet.instance()
	#new_bullet.transform = $Turret/Muzzle.global_transform
	#new_bullet.position = to_global($Turret/Muzzle.position)
	#print(to_global($Turret/Muzzle.position))
	
	new_bullet.transform = $Turret/Muzzle.global_transform
	new_bullet.position = $Turret/Muzzle.global_position
	
	new_bullet.rotation = turret.global_rotation
	
	new_bullet.apply_central_impulse(Vector2.RIGHT.rotated(turret.global_rotation) * 400.0)
	get_parent().get_parent().add_child(new_bullet)
