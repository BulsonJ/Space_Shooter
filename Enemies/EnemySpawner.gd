extends Node2D

export var spawn_time := 1.0
export var spawn_distance := 650.0 * 1
export var wave_timer := 10.0

export var enemies_spawning := true
var _spawning = false
export(NodePath) var enemy_spawn_node_path = null
onready var enemy_spawn_node = get_node(enemy_spawn_node_path)

export(PackedScene) var enemy_type = preload("res://Enemies/Enemy_1.tscn")

var _waves = [10,20,30,40,50]
var _wave_number := 0
var _enemies_spawned := 0

signal spawn_enemy(enemy, location)
signal wave_start(wave_number)
signal wave_starting_timer(time)
signal wave_end(wave_number)

func _ready() -> void:
	$WaveTimer.start(wave_timer)

func _physics_process(delta: float) -> void:
	if enemies_spawning && _spawning:
		spawn_wave()
		monitor_enemies()
	
	if !$WaveTimer.is_stopped():
		emit_signal("wave_starting_timer", $WaveTimer.time_left)
		
func monitor_enemies() -> void:
	var number_of_enemies = enemy_spawn_node.get_child_count()
	if _enemies_spawned == _waves[_wave_number] && number_of_enemies == 0:
		emit_signal("wave_end", _wave_number)
		next_wave()

func spawn_wave() -> void:
	if _enemies_spawned < _waves[_wave_number]:
		if $SpawnTimer.is_stopped() == true:
			$SpawnTimer.start(spawn_time)
	else:
		$SpawnTimer.stop()

func next_wave() -> void:
	if _waves[_wave_number + 1] == null:
		print("no more waves")
		return
		
	_enemies_spawned = 0
	_wave_number += 1
	_spawning = false
	$WaveTimer.start(wave_timer)

func spawn_enemy() -> void:
	var angle := rand_range(0, 360)
	var pos := Vector2(spawn_distance*cos(angle), spawn_distance*sin(angle))
	
	emit_signal("spawn_enemy", enemy_type, pos)
	
func _on_SpawnTimer_timeout() -> void:
	spawn_enemy()
	_enemies_spawned += 1

func _on_WaveTimer_timeout() -> void:
	_spawning = true
	emit_signal("wave_start", _wave_number)
