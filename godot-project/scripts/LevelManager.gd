extends Node
class_name LevelManager

signal level_changed(level_data: Dictionary)
signal boss_warning()
signal level_complete()

var current_level_index: int = 0
var levels: Array[Dictionary] = []
var endless_mode: bool = false

func _ready():
	_setup_levels()

func _setup_levels():
	levels = [
		{
			"name": "Base Camp",
			"theme": "military",
			"difficulty": 1,
			"scroll_speed": 120,
			"enemy_spawn_rate": 3.0,
			"enemy_types": ["Drone"],
			"powerup_spawn_rate": 4.0,
			"background_color": Color(0.2, 0.4, 0.2),
			"boss": false,
			"special_features": ["basic_training"],
			"level_length": 2000,
			"target_score": 500
		},
		{
			"name": "Desert Warzone",
			"theme": "desert",
			"difficulty": 2,
			"scroll_speed": 150,
			"enemy_spawn_rate": 2.5,
			"enemy_types": ["Drone", "Tank"],
			"powerup_spawn_rate": 3.5,
			"background_color": Color(0.8, 0.6, 0.2),
			"boss": false,
			"special_features": ["sand_storms"],
			"level_length": 2500,
			"target_score": 1000
		},
		{
			"name": "Volcano Lava Run",
			"theme": "volcano",
			"difficulty": 3,
			"scroll_speed": 180,
			"enemy_spawn_rate": 2.0,
			"enemy_types": ["Drone", "Tank", "Turret"],
			"powerup_spawn_rate": 3.0,
			"background_color": Color(0.8, 0.2, 0.1),
			"boss": true,
			"boss_type": "FireDragon",
			"special_features": ["lava_falls", "fire_balls"],
			"level_length": 3000,
			"target_score": 2000
		},
		{
			"name": "Arctic Storm",
			"theme": "arctic",
			"difficulty": 4,
			"scroll_speed": 160,
			"enemy_spawn_rate": 1.8,
			"enemy_types": ["Drone", "Tank", "Turret", "IceDrone"],
			"powerup_spawn_rate": 2.8,
			"background_color": Color(0.7, 0.8, 0.9),
			"boss": false,
			"special_features": ["blizzard", "ice_obstacles"],
			"level_length": 2800,
			"target_score": 2500
		},
		{
			"name": "Cyber City",
			"theme": "cyber",
			"difficulty": 5,
			"scroll_speed": 200,
			"enemy_spawn_rate": 1.5,
			"enemy_types": ["Drone", "Tank", "Turret", "CyberDrone", "LaserTurret"],
			"powerup_spawn_rate": 2.5,
			"background_color": Color(0.1, 0.0, 0.3),
			"boss": true,
			"boss_type": "CyberNexus",
			"special_features": ["laser_grid", "holograms"],
			"level_length": 3500,
			"target_score": 3500
		},
		{
			"name": "Jungle Ambush",
			"theme": "jungle",
			"difficulty": 6,
			"scroll_speed": 140,
			"enemy_spawn_rate": 1.3,
			"enemy_types": ["Drone", "Tank", "Turret", "CamouflageDrone", "VineTrap"],
			"powerup_spawn_rate": 2.2,
			"background_color": Color(0.1, 0.4, 0.1),
			"boss": false,
			"special_features": ["hidden_enemies", "poison_gas"],
			"level_length": 3200,
			"target_score": 4000
		},
		{
			"name": "Ocean Battleships",
			"theme": "ocean",
			"difficulty": 7,
			"scroll_speed": 170,
			"enemy_spawn_rate": 1.2,
			"enemy_types": ["Drone", "Tank", "Turret", "SeaDrone", "Battleship"],
			"powerup_spawn_rate": 2.0,
			"background_color": Color(0.0, 0.3, 0.6),
			"boss": true,
			"boss_type": "Leviathan",
			"special_features": ["waves", "torpedoes"],
			"level_length": 4000,
			"target_score": 5000
		},
		{
			"name": "Underground Bunker",
			"theme": "underground",
			"difficulty": 8,
			"scroll_speed": 130,
			"enemy_spawn_rate": 1.0,
			"enemy_types": ["Drone", "Tank", "Turret", "BunkerDrone", "MineLayer"],
			"powerup_spawn_rate": 1.8,
			"background_color": Color(0.2, 0.1, 0.0),
			"boss": false,
			"special_features": ["darkness", "explosive_mines"],
			"level_length": 3800,
			"target_score": 6000
		},
		{
			"name": "Sky Fortress",
			"theme": "sky",
			"difficulty": 9,
			"scroll_speed": 220,
			"enemy_spawn_rate": 0.8,
			"enemy_types": ["Drone", "Tank", "Turret", "SkyDrone", "FlyingFortress"],
			"powerup_spawn_rate": 1.5,
			"background_color": Color(0.5, 0.7, 0.9),
			"boss": true,
			"boss_type": "SkyDestroyer",
			"special_features": ["lightning", "wind_gusts"],
			"level_length": 4500,
			"target_score": 8000
		},
		{
			"name": "Alien Mothership",
			"theme": "alien",
			"difficulty": 10,
			"scroll_speed": 250,
			"enemy_spawn_rate": 0.5,
			"enemy_types": ["Drone", "Tank", "Turret", "AlienDrone", "AlienFighter", "MothershipCore"],
			"powerup_spawn_rate": 1.0,
			"background_color": Color(0.3, 0.0, 0.4),
			"boss": true,
			"boss_type": "AlienOverlord",
			"special_features": ["gravity_wells", "alien_swarm"],
			"level_length": 5000,
			"target_score": 10000
		}
	]

func get_current_level() -> Dictionary:
	if endless_mode:
		return _generate_endless_level()
	elif current_level_index < levels.size():
		return levels[current_level_index]
	else:
		return levels[-1]  # Return last level if index out of bounds

func _generate_endless_level() -> Dictionary:
	var endless_level = {
		"name": "Endless Mode - Wave " + str(Global.current_level + 1),
		"theme": ["military", "desert", "volcano", "arctic", "cyber", "jungle", "ocean", "underground", "sky", "alien"][randi() % 10],
		"difficulty": min(10, 3 + Global.current_level / 2),
		"scroll_speed": min(300, 120 + Global.current_level * 10),
		"enemy_spawn_rate": max(0.3, 3.0 - Global.current_level * 0.2),
		"enemy_types": _get_available_enemies(),
		"powerup_spawn_rate": max(1.0, 4.0 - Global.current_level * 0.1),
		"background_color": Color(randf(), randf(), randf()),
		"boss": Global.current_level % 5 == 4,  # Boss every 5 waves
		"boss_type": _get_random_boss(),
		"special_features": _get_random_features(),
		"level_length": 3000 + Global.current_level * 200,
		"target_score": 1000 * (Global.current_level + 1)
	}
	return endless_level

func _get_available_enemies() -> Array[String]:
	var available = ["Drone", "Tank", "Turret"]
	if Global.current_level >= 2:
		available.append("IceDrone")
	if Global.current_level >= 3:
		available.append("CyberDrone")
	if Global.current_level >= 4:
		available.append("CamouflageDrone")
	if Global.current_level >= 5:
		available.append("SeaDrone")
	if Global.current_level >= 6:
		available.append("BunkerDrone")
	if Global.current_level >= 7:
		available.append("SkyDrone")
	if Global.current_level >= 8:
		available.append("AlienDrone")
	return available

func _get_random_boss() -> String:
	var bosses = ["FireDragon", "CyberNexus", "Leviathan", "SkyDestroyer", "AlienOverlord"]
	return bosses[randi() % bosses.size()]

func _get_random_features() -> Array[String]:
	var all_features = ["sand_storms", "lava_falls", "blizzard", "laser_grid", "hidden_enemies", "waves", "darkness", "lightning", "gravity_wells"]
	var selected = []
	for feature in all_features:
		if randf() < 0.3:  # 30% chance for each feature
			selected.append(feature)
	return selected

func next_level():
	current_level_index += 1
	if current_level_index >= levels.size():
		current_level_index = levels.size() - 1  # Stay at last level
	level_changed.emit(get_current_level())

func set_level(index: int):
	current_level_index = clamp(index, 0, levels.size() - 1)
	level_changed.emit(get_current_level())

func reset_levels():
	current_level_index = 0
	endless_mode = false

func start_endless_mode():
	endless_mode = true
	level_changed.emit(_generate_endless_level())

func get_level_count() -> int:
	return levels.size()

func is_last_level() -> bool:
	return current_level_index >= levels.size() - 1 and not endless_mode