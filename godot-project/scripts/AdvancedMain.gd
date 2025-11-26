extends Node2D

@onready var player: EnhancedPlayer = $Player
@onready var camera: Camera2D = $Player/Camera2D
@onready var parallax_bg: ParallaxBackground = $ParallaxBackground
@onready var hud: Control = $HUD
@onready var spawn_timer: Timer = $SpawnTimer
@onready var level_end: Area2D = $LevelEnd
@onready var environment: Node2D = $Environment
@onready var level_manager: LevelManager = $LevelManager
@onready var boss_manager: BossManager = $BossManager
@onready var hazards: EnvironmentHazards = $EnvironmentHazards

var current_level_data: Dictionary
var scroll_speed: float = 150.0
var enemy_spawn_rate: float = 2.0
var collectible_spawn_rate: float = 3.0
var wave_number: int = 1
var enemies_in_wave: int = 5
var enemies_spawned: int = 0
var boss_spawned: bool = false
var level_distance: float = 0.0
var level_complete: bool = false

func _ready():
	Global.score_changed.connect(_on_score_changed)
	Global.health_changed.connect(_on_health_changed)
	Global.weapon_changed.connect(_on_weapon_changed)
	
	level_manager.level_changed.connect(_on_level_changed)
	boss_manager.boss_defeated.connect(_on_boss_defeated)
	
	# Check if mobile
	Global.is_mobile = OS.get_name() in ["Android", "iOS"] or DisplayServer.screen_get_dpi() > 150
	
	# Setup initial level
	_setup_level()
	
	# Create environment
	_create_environment()
	
	# Start spawning systems
	_start_spawning_system()

func _setup_level():
	current_level_data = level_manager.get_current_level()
	scroll_speed = current_level_data.scroll_speed
	enemy_spawn_rate = current_level_data.enemy_spawn_rate
	collectible_spawn_rate = current_level_data.powerup_spawn_rate
	
	# Setup enhanced parallax background
	_setup_enhanced_background()
	
	# Show level notification
	_show_level_notification()

func _setup_enhanced_background():
	# Clear existing background layers
	for child in parallax_bg.get_children():
		child.queue_free()
	
	# Create theme-specific background layers
	match current_level_data.theme:
		"military":
			_create_military_background()
		"desert":
			_create_desert_background()
		"volcano":
			_create_volcano_background()
		"arctic":
			_create_arctic_background()
		"cyber":
			_create_cyber_background()
		"jungle":
			_create_jungle_background()
		"ocean":
			_create_ocean_background()
		"underground":
			_create_underground_background()
		"sky":
			_create_sky_background()
		"alien":
			_create_alien_background()

func _create_military_background():
	var layers = [
		{"name": "FarMountains", "speed": 0.2, "color": Color(0.3, 0.4, 0.3)},
		{"name": "NearMountains", "speed": 0.5, "color": Color(0.4, 0.5, 0.4)},
		{"name": "Trees", "speed": 0.7, "color": Color(0.2, 0.3, 0.2)}
	]
	_create_background_layers(layers)

func

func _create_background_layers(layers: Array):
	for layer_data in layers:
		var layer = ParallaxLayer.new()
		layer.name = layer_data.name
		layer.motion_scale = Vector2(layer_data.speed, 1.0)
		parallax_bg.add_child(layer)
		
		# Create background sprites
		for i in range(8):
			var sprite = Sprite2D.new()
			sprite.position = Vector2(i * 300, randf_range(-150, 150))
			sprite.scale = Vector2(2, 2)
			sprite.modulate = layer_data.color
			layer.add_child(sprite)

func _create_desert_background():
	var layers = [
		{"name": "Dunes", "speed": 0.3, "color": Color(0.8, 0.6, 0.3)},
		{"name": "Rocks", "speed": 0.6, "color": Color(0.6, 0.5, 0.2)},
		{"name": "Cacti", "speed": 0.8, "color": Color(0.4, 0.3, 0.1)}
	]
	_create_background_layers(layers)

func _create_volcano_background():
	var layers = [
		{"name": "Lava", "speed": 0.2, "color": Color(0.8, 0.2, 0.1)},
		{"name": "Rocks", "speed": 0.5, "color": Color(0.5, 0.2, 0.1)},
		{"name": "Smoke", "speed": 0.3, "color": Color(0.3, 0.2, 0.2)}
	]
	_create_background_layers(layers)

func _create_arctic_background():
	var layers = [
		{"name": "Icebergs", "speed": 0.2, "color": Color(0.8, 0.9, 1.0)},
		{"name": "Snow", "speed": 0.5, "color": Color(0.9, 0.95, 1.0)},
		{"name": "Mountains", "speed": 0.3, "color": Color(0.7, 0.8, 0.9)}
	]
	_create_background_layers(layers)

func _create_cyber_background():
	var layers = [
		{"name": "Buildings", "speed": 0.4, "color": Color(0.1, 0.0, 0.3)},
		{"name": "Lights", "speed": 0.7, "color": Color(0.5, 0.0, 0.8)},
		{"name": "Grid", "speed": 0.2, "color": Color(0.2, 0.1, 0.4)}
	]
	_create_background_layers(layers)

func _create_jungle_background():
	var layers = [
		{"name": "Trees", "speed": 0.3, "color": Color(0.1, 0.4, 0.1)},
		{"name": "Vines", "speed": 0.6, "color": Color(0.2, 0.5, 0.2)},
		{"name": "Leaves", "speed": 0.8, "color": Color(0.3, 0.6, 0.2)}
	]
	_create_background_layers(layers)

func _create_ocean_background():
	var layers = [
		{"name": "Waves", "speed": 0.5, "color": Color(0.0, 0.3, 0.6)},
		{"name": "Ships", "speed": 0.3, "color": Color(0.2, 0.4, 0.7)},
		{"name": "Sky", "speed": 0.1, "color": Color(0.5, 0.7, 0.9)}
	]
	_create_background_layers(layers)

func _create_underground_background():
	var layers = [
		{"name": "Tunnels", "speed": 0.2, "color": Color(0.2, 0.1, 0.0)},
		{"name": "Rocks", "speed": 0.4, "color": Color(0.3, 0.2, 0.1)},
		{"name": "Darkness", "speed": 0.1, "color": Color(0.1, 0.05, 0.0)}
	]
	_create_background_layers(layers)

func _create_sky_background():
	var layers = [
		{"name": "Clouds", "speed": 0.3, "color": Color(0.8, 0.8, 0.9)},
		{"name": "Islands", "speed": 0.5, "color": Color(0.6, 0.7, 0.8)},
		{"name": "Sun", "speed": 0.1, "color": Color(1.0, 0.9, 0.7)}
	]
	_create_background_layers(layers)

func _create_alien_background():
	var layers = [
		{"name": "Structures", "speed": 0.4, "color": Color(0.3, 0.0, 0.4)},
		{"name": "Energy", "speed": 0.6, "color": Color(0.6, 0.0, 0.8)},
		{"name": "Stars", "speed": 0.1, "color": Color(0.8, 0.2, 0.9)}
	]
	_create_background_layers(layers)

func _create_environment():
	# Clear existing environment
	for child in environment.get_children():
		child.queue_free()
	
	# Create level-specific environment elements
	match current_level_data.theme:
		"military":
			_create_military_environment()
		"desert":
			_create_desert_environment()
		"volcano":
			_create_volcano_environment()
		"arctic":
			_create_arctic_environment()
		"cyber":
			_create_cyber_environment()
		"jungle":
			_create_jungle_environment()
		"ocean":
			_create_ocean_environment()
		"underground":
			_create_underground_environment()
		"sky":
			_create_sky_environment()
		"alien":
			_create_alien_environment()

func _create_military_environment():
	for i in range(15):
		var env_type = ["building", "bunker", "fence"][randi() % 3]
		var env_obj = preload("res://scenes/" + env_type.capitalize() + ".tscn").instantiate()
		env_obj.global_position = Vector2(
			randf_range(-500, 3000),
			randf_range(100, 500)
		)
		environment.add_child(env_obj)

func _create_desert_environment():
	for i in range(20):
		var env_type = ["dune", "rock", "cactus"][randi() % 3]
		var env_obj = preload("res://scenes/" + env_type.capitalize() + ".tscn").instantiate()
		env_obj.global_position = Vector2(
			randf_range(-500, 3000),
			randf_range(150, 450)
		)
		environment.add_child(env_obj)

func _create_volcano_environment():
	for i in range(12):
		var env_type = ["lava_pool", "rock", "volcano"][randi() % 3]
		var env_obj = preload("res://scenes/" + env_type.capitalize() + ".tscn").instantiate()
		env_obj.global_position = Vector2(
			randf_range(-500, 3000),
			randf_range(100, 500)
		)
		environment.add_child(env_obj)

func _create_arctic_environment():
	for i in range(18):
		var env_type = ["iceberg", "snow", "igloo"][randi() % 3]
		var env_obj = preload("res://scenes/" + env_type.capitalize() + ".tscn").instantiate()
		env_obj.global_position = Vector2(
			randf_range(-500, 3000),
			randf_range(100, 500)
		)
		environment.add_child(env_obj)

func _create_cyber_environment():
	for i in range(16):
		var env_type = ["building", "hologram", "terminal"][randi() % 3]
		var env_obj = preload("res://scenes/" + env_type.capitalize() + ".tscn").instantiate()
		env_obj.global_position = Vector2(
			randf_range(-500, 3000),
			randf_range(100, 500)
		)
		environment.add_child(env_obj)

func _create_jungle_environment():
	for i in range(22):
		var env_type = ["tree", "vine", "ruin"][randi() % 3]
		var env_obj = preload("res://scenes/" + env_type.capitalize() + ".tscn").instantiate()
		env_obj.global_position = Vector2(
			randf_range(-500, 3000),
			randf_range(100, 500)
		)
		environment.add_child(env_obj)

func _create_ocean_environment():
	for i in range(14):
		var env_type = ["wave", "ship", "island"][randi() % 3]
		var env_obj = preload("res://scenes/" + env_type.capitalize() + ".tscn").instantiate()
		env_obj.global_position = Vector2(
			randf_range(-500, 3000),
			randf_range(200, 400)
		)
		environment.add_child(env_obj)

func _create_underground_environment():
	for i in range(17):
		var env_type = ["tunnel", "crystal", "mine"][randi() % 3]
		var env_obj = preload("res://scenes/" + env_type.capitalize() + ".tscn").instantiate()
		env_obj.global_position = Vector2(
			randf_range(-500, 3000),
			randf_range(100, 500)
		)
		environment.add_child(env_obj)

func _create_sky_environment():
	for i in range(13):
		var env_type = ["cloud", "island", "lightning"][randi() % 3]
		var env_obj = preload("res://scenes/" + env_type.capitalize() + ".tscn").instantiate()
		env_obj.global_position = Vector2(
			randf_range(-500, 3000),
			randf_range(50, 550)
		)
		environment.add_child(env_obj)

func _create_alien_environment():
	for i in range(15):
		var env_type = ["structure", "energy", "artifact"][randi() % 3]
		var env_obj = preload("res://scenes/" + env_type.capitalize() + ".tscn").instantiate()
		env_obj.global_position = Vector2(
			randf_range(-500, 3000),
			randf_range(100, 500)
		)
		environment.add_child(env_obj)

func _start_spawning_system():
	# Enemy spawning
	spawn_timer.wait_time = enemy_spawn_rate
	spawn_timer.timeout.connect(_spawn_enemy_wave)
	spawn_timer.start()
	
	# Collectible spawning
	var collectible_timer = Timer.new()
	add_child(collectible_timer)
	collectible_timer.wait_time = collectible_spawn_rate
	collectible_timer.timeout.connect(_spawn_collectible)
	collectible_timer.start()
	
	# Power-up spawning
	var powerup_timer = Timer.new()
	add_child(powerup_timer)
	powerup_timer.wait_time = 8.0
	powerup_timer.timeout.connect(_spawn_powerup)
	powerup_timer.start()

func _spawn_enemy_wave():
	if level_complete:
		return
		
	if enemies_spawned >= enemies_in_wave:
		# Check if boss should spawn
		if current_level_data.boss and not boss_spawned:
			_spawn_boss()
			boss_spawned = true
		else:
			# Start next wave
			wave_number += 1
			enemies_in_wave = 5 + wave_number * 2 + current_level_data.difficulty
			enemies_spawned = 0
		return
	
	# Spawn enemies based on level data
	var enemy_type = current_level_data.enemy_types[randi() % current_level_data.enemy_types.size()]
	var enemy_scene = preload("res://scenes/" + enemy_type + ".tscn")
	var enemy = enemy_scene.instantiate()
	
	# Enhanced spawn positioning with formations
	var spawn_x = camera.global_position.x + 600
	var spawn_y = randf_range(100, 500)
	
	# Advanced formations for higher difficulties
	if current_level_data.difficulty > 3:
		var formation_type = randi() % 4
		match formation_type:
			0: # Line formation
				spawn_y = 200 + (enemies_spawned % 4) * 75
			1: # V formation
				var offset = (enemies_spawned % 4 - 1.5) * 60
				spawn_y = 300 + offset
			2: # Circle formation
				var angle = (enemies_spawned % 6) * PI / 3
				spawn_x += cos(angle) * 100
				spawn_y += sin(angle) * 100
			3: # Random with clustering
				if enemies_spawned % 3 == 0:
					spawn_y = randf_range(100, 500)
				else:
					spawn_y = spawn_y + randf_range(-30, 30)
	
	enemy.global_position = Vector2(spawn_x, spawn_y)
	add_child(enemy)
	enemies_spawned += 1

func _spawn_boss():
	boss_manager.boss_warning.emit()
	
	# Show boss warning effect
	_show_boss_warning()
	
	# Spawn boss after delay
	await get_tree().create_timer(2.0).timeout
	var boss = boss_manager.spawn_boss(current_level_data.boss_type, Vector2(camera.global_position.x + 800, 300))
	add_child(boss)

func _show_boss_warning():
	var warning = preload("res://scenes/BossWarning.tscn").instantiate()
	add_child(warning)
	
	# Screen shake and effects
	var tween = create_tween()
	tween.tween_property(camera, "zoom", Vector2(1.3, 1.3), 0.5)
	tween.tween_property(camera, "zoom", Vector2(1.0, 1.0), 0.5)

func _show_level_notification():
	var notification = preload("res://scenes/LevelNotification.tscn").instantiate()
	add_child(notification)
	notification.get_node("Label").text = current_level_data.name
	notification.get_node("Subtitle").text = "Difficulty: " + str(current_level_data.difficulty)

func _spawn_collectible():
	var collectible_types = ["coin", "health", "shield", "ammo"]
	var weights = [50, 20, 15, 15]  # Weighted random selection
	
	var collectible_type = _weighted_random(collectible_types, weights)
	var collectible = preload("res://scenes/Collectible.tscn").instantiate()
	collectible.type = collectible_type
	
	match collectible_type:
		"coin":
			collectible.value = 10 + current_level_data.difficulty * 2
		"health":
			collectible.value = 25 + current_level_data.difficulty * 5
		"shield":
			collectible.value = 30 + current_level_data.difficulty * 5
		"ammo":
			collectible.value = 20 + current_level_data.difficulty * 3
	
	# Enhanced visual setup
	collectible.get_node("Sprite2D").modulate = match collectible_type:
		"coin": Color.YELLOW
		"health": Color.GREEN
		"shield": Color.CYAN
		"ammo": Color.ORANGE
		_: Color.WHITE
	
	collectible.global_position = Vector2(
		camera.global_position.x + 600,
		randf_range(100, 500)
	)
	
	add_child(collectible)

func _spawn_powerup():
	var powerup_types = ["health", "shield", "ammo", "speed", "damage"]
	var rarities = ["common", "common", "rare", "epic", "legendary"]
	var rarity = rarities[min(4, current_level_data.difficulty - 1)]
	var powerup_type = powerup_types[randi() % powerup_types.size()]
	
	var powerup = preload("res://scenes/PowerUp.tscn").instantiate()
	powerup.type = powerup_type
	powerup.rarity = rarity
	powerup.value = match rarity:
		"common": 25
		"rare": 50
		"epic": 75
		"legendary": 100
		_: 25
	
	powerup.global_position = Vector2(
		camera.global_position.x + 600,
		randf_range(100, 500)
	)
	
	add_child(powerup)

func _weighted_random(items: Array, weights: Array):
	var total_weight = 0
	for w in weights:
		total_weight += w
	
	var random_value = randf() * total_weight
	var current_weight = 0
	
	for i in range(items.size()):
		current_weight += weights[i]
		if random_value <= current_weight:
			return items[i]
	
	return items[0]

func _process(delta: float):
	# Enhanced auto-scroll with smooth camera
	camera.position.x += scroll_speed * delta
	parallax_bg.scroll_offset.x += scroll_speed * delta * 0.5
	
	# Track level distance
	level_distance += scroll_speed * delta
	
	# Check level completion
	if level_distance >= current_level_data.level_length and not level_complete:
		level_complete = true
		_on_level_complete()
	
	# Dynamic difficulty scaling
	if Global.score > wave_number * (1000 + current_level_data.difficulty * 200):
		enemy_spawn_rate = max(0.3, enemy_spawn_rate - 0.05)
		spawn_timer.wait_time = enemy_spawn_rate
	
	# Keep player in view with smooth boundaries
	var player_bounds = Rect2(
		camera.global_position.x - 300,
		50,
		600,
		500
	)
	
	if player.global_position.x < player_bounds.position.x:
		player.global_position.x = player_bounds.position.x
	elif player.global_position.x > player_bounds.position.x + player_bounds.size.x:
		player.global_position.x = player_bounds.position.x + player_bounds.size.x
	
	if player.global_position.y < player_bounds.position.y:
		player.global_position.y = player_bounds.position.y
	elif player.global_position.y > player_bounds.position.y + player_bounds.size.y:
		player.global_position.y = player_bounds.position.y + player_bounds.size.y

func _on_score_changed(new_score: int):
	hud.get_node("ScoreLabel").text = "Score: %d" % new_score
	
	# Milestone rewards
	if new_score > 0 and new_score % 1000 == 0:
		_spawn_milestone_reward()

func _on_health_changed(new_health: int):
	hud.get_node("HealthBar").value = new_health
	hud.get_node("ArmorBar").value = Global.player_armor
	hud.get_node("ShieldBar").value = Global.player_shield

func _on_weapon_changed(weapon: String):
	hud.get_node("WeaponLabel").text = "Weapon: %s" % weapon.capitalize()
	hud.get_node("AmmoLabel").text = "Ammo: %d" % Global.weapon_ammo[weapon]

func _on_level_changed(level_data: Dictionary):
	current_level_data = level_data
	_setup_level()
	_create_environment()

func _on_boss_defeated(boss_name: String):
	# Boss defeated rewards
	var completion_bonus = current_level_data.target_score
	Global.add_score(completion_bonus)
	
	# Level complete after boss
	if not level_complete:
		level_complete = true
		_on_level_complete()

func _on_level_complete():
	# Level complete with bonus score
	var completion_bonus = current_level_data.target_score
	Global.add_score(completion_bonus)
	
	# Check if it's the last level
	if level_manager.is_last_level():
		# Game complete!
		get_tree().change_scene_to_file("res://scenes/VictoryScreen.tscn")
	else:
		# Move to next level
		level_manager.next_level()
		# Reset for next level
		level_distance = 0.0
		level_complete = false
		boss_spawned = false
		wave_number = 1
		enemies_in_wave = 5 + current_level_data.difficulty * 2
		enemies_spawned = 0

func _on_level_end_body_entered(body: Node):
	if body is EnhancedPlayer and not level_complete:
		# Alternative level completion trigger
		level_complete = true
		_on_level_complete()

func _spawn_milestone_reward():
	# Spawn special reward for milestones
	var reward = preload("res://scenes/PowerUp.tscn").instantiate()
	reward.type = "invincible"
	reward.rarity = "legendary"
	reward.value = 100
	reward.global_position = Vector2(
		camera.global_position.x + 400,
		300
	)
	add_child(reward)
	
	# Show milestone notification
	var notification = preload("res://scenes/MilestoneNotification.tscn").instantiate()
	add_child(notification)