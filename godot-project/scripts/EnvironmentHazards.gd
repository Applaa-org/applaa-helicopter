extends Node2D
class_name EnvironmentHazards

var hazard_types: Array[String] = []
var active_hazards: Array[Node] = []
var spawn_timer: float = 0.0
var spawn_rate: float = 3.0

func _ready():
	# Setup hazards based on current level
	var level_manager = get_node_or_null("/root/LevelManager")
	if level_manager:
		var current_level = level_manager.get_current_level()
		hazard_types = current_level.get("special_features", [])

func _process(delta: float):
	spawn_timer += delta
	
	if spawn_timer >= spawn_rate:
		spawn_timer = 0.0
		_spawn_random_hazard()
	
	# Update active hazards
	for i in range(active_hazards.size() - 1, -1, -1):
		var hazard = active_hazards[i]
		if not is_instance_valid(hazard):
			active_hazards.remove_at(i)

func _spawn_random_hazard():
	if hazard_types.is_empty():
		return
	
	var hazard_type = hazard_types[randi() % hazard_types.size()]
	
	match hazard_type:
		"sand_storms":
			_spawn_sand_storm()
		"lava_falls":
			_spawn_lava_fall()
		"fire_balls":
			_spawn_fire_ball()
		"blizzard":
			_spawn_blizzard()
		"ice_obstacles":
			_spawn_ice_obstacle()
		"laser_grid":
			_spawn_laser_grid()
		"holograms":
			_spawn_hologram()
		"hidden_enemies":
			_spawn_hidden_enemy()
		"poison_gas":
			_spawn_poison_gas()
		"waves":
			_spawn_wave()
		"torpedoes":
			_spawn_torpedo()
		"darkness":
			_spawn_darkness()
		"explosive_mines":
			_spawn_explosive_mine()
		"lightning":
			_spawn_lightning()
		"wind_gusts":
			_spawn_wind_gust()
		"gravity_wells":
			_spawn_gravity_well()
		"alien_swarm":
			_spawn_alien_swarm()

func _spawn_sand_storm():
	var sand_storm = preload("res://scenes/SandStorm.tscn").instantiate()
	add_child(sand_storm)
	sand_storm.global_position = Vector2(get_viewport().get_camera_2d().global_position.x + 600, randf_range(100, 500))
	active_hazards.append(sand_storm)

func _spawn_lava_fall():
	var lava_fall = preload("res://scenes/LavaFall.tscn").instantiate()
	add_child(lava_fall)
	lava_fall.global_position = Vector2(get_viewport().get_camera_2d().global_position.x + 600, 0)
	active_hazards.append(lava_fall)

func _spawn_fire_ball():
	var fire_ball = preload("res://scenes/FireBall.tscn").instantiate()
	add_child(fire_ball)
	fire_ball.global_position = Vector2(get_viewport().get_camera_2d().global_position.x + 600, randf_range(50, 200))
	active_hazards.append(fire_ball)

func _spawn_blizzard():
	var blizzard = preload("res://scenes/Blizzard.tscn").instantiate()
	add_child(blizzard)
	blizzard.global_position = Vector2(get_viewport().get_camera_2d().global_position.x + 600, 300)
	active_hazards.append(blizzard)

func _spawn_ice_obstacle():
	var ice_obstacle = preload("res://scenes/IceObstacle.tscn").instantiate()
	add_child(ice_obstacle)
	ice_obstacle.global_position = Vector2(get_viewport().get_camera_2d().global_position.x + 600, randf_range(100, 500))
	active_hazards.append(ice_obstacle)

func _spawn_laser_grid():
	var laser_grid = preload("res://scenes/LaserGrid.tscn").instantiate()
	add_child(laser_grid)
	laser_grid.global_position = Vector2(get_viewport().get_camera_2d().global_position.x + 600, 300)
	active_hazards.append(laser_grid)

func _spawn_hologram():
	var hologram = preload("res://scenes/HologramEnemy.tscn").instantiate()
	add_child(hologram)
	hologram.global_position = Vector2(get_viewport().get_camera_2d().global_position.x + 600, randf_range(100, 500))
	active_hazards.append(hologram)

func _spawn_hidden_enemy():
	var hidden_enemy = preload("res://scenes/HiddenEnemy.tscn").instantiate()
	add_child(hidden_enemy)
	hidden_enemy.global_position = Vector2(get_viewport().get_camera_2d().global_position.x + 600, randf_range(100, 500))
	active_hazards.append(hidden_enemy)

func _spawn_poison_gas():
	var poison_gas = preload("res://scenes/PoisonGas.tscn").instantiate()
	add_child(poison_gas)
	poison_gas.global_position = Vector2(get_viewport().get_camera_2d().global_position.x + 600, randf_range(100, 500))
	active_hazards.append(poison_gas)

func _spawn_wave():
	var wave = preload("res://scenes/OceanWave.tscn").instantiate()
	add_child(wave)
	wave.global_position = Vector2(get_viewport().get_camera_2d().global_position.x + 600, 400)
	active_hazards.append(wave)

func _spawn_torpedo():
	var torpedo = preload("res://scenes/Torpedo.tscn").instantiate()
	add_child(torpedo)
	torpedo.global_position = Vector2(get_viewport().get_camera_2d().global_position.x + 600, randf_range(200, 400))
	active_hazards.append(torpedo)

func _spawn_darkness():
	var darkness = preload("res://scenes/DarknessArea.tscn").instantiate()
	add_child(darkness)
	darkness.global_position = Vector2(get_viewport().get_camera_2d().global_position.x + 600, 300)
	active_hazards.append(darkness)

func _spawn_explosive_mine():
	var mine = preload("res://scenes/ExplosiveMine.tscn").instantiate()
	add_child(mine)
	mine.global_position = Vector2(get_viewport().get_camera_2d().global_position.x + 600, randf_range(100, 500))
	active_hazards.append(mine)

func _spawn_lightning():
	var lightning = preload("res://scenes/EnvironmentLightning.tscn").instantiate()
	add_child(lightning)
	lightning.global_position = Vector2(get_viewport().get_camera_2d().global_position.x + 600, randf_range(50, 550))
	active_hazards.append(lightning)

func _spawn_wind_gust():
	var wind_gust = preload("res://scenes/WindGust.tscn").instantiate()
	add_child(wind_gust)
	wind_gust.global_position = Vector2(get_viewport().get_camera_2d().global_position.x + 600, randf_range(100, 500))
	active_hazards.append(wind_gust)

func _spawn_gravity_well():
	var gravity_well = preload("res://scenes/EnvironmentGravityWell.tscn").instantiate()
	add_child(gravity_well)
	gravity_well.global_position = Vector2(get_viewport().get_camera_2d().global_position.x + 600, 300)
	active_hazards.append(gravity_well)

func _spawn_alien_swarm():
	var swarm = preload("res://scenes/AlienSwarm.tscn").instantiate()
	add_child(swarm)
	swarm.global_position = Vector2(get_viewport().get_camera_2d().global_position.x + 600, 300)
	active_hazards.append(swarm)