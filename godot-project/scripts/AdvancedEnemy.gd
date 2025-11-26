extends SmartEnemy
class_name AdvancedEnemy

var enemy_type: String = "basic"
var special_ability: String = ""
var ability_cooldown: float = 0.0
var camouflage_active: bool = false
var ice_trail: Array[Node2D] = []
var laser_charge: float = 0.0
var poison_cloud_timer: float = 0.0

func _ready():
	super._ready()
	_setup_advanced_enemy()

func _setup_advanced_enemy():
	match enemy_type:
		"IceDrone":
			health = 40
			max_health = 40
			speed = 80
			damage = 15
			score_value = 150
			special_ability = "ice_trail"
		"CyberDrone":
			health = 60
			max_health = 60
			speed = 120
			damage = 20
			score_value = 200
			special_ability = "teleport"
		"CamouflageDrone":
			health = 35
			max_health = 35
			speed = 90
			damage = 18
			score_value = 180
			special_ability = "camouflage"
		"SeaDrone":
			health = 45
			max_health = 45
			speed = 70
			damage = 22
			score_value = 190
			special_ability = "wave_attack"
		"BunkerDrone":
			health = 55
			max_health = 55
			speed = 60
			damage = 25
			score_value = 220
			special_ability = "mine_laying"
		"SkyDrone":
			health = 50
			max_health = 50
			speed = 140
			damage = 20
			score_value = 210
			special_ability = "lightning_strike"
		"AlienDrone":
			health = 70
			max_health = 70
			speed = 100
			damage = 30
			score_value = 300
			special_ability = "gravity_pull"
		"AlienFighter":
			health = 80
			max_health = 80
			speed = 110
			damage = 35
			score_value = 350
			special_ability = "alien_swarm"

func _physics_process(delta: float):
	super._physics_process(delta)
	
	# Update ability cooldown
	if ability_cooldown > 0:
		ability_cooldown -= delta
	
	# Execute special abilities
	if ability_cooldown <= 0:
		_execute_special_ability(delta)
	
	# Update ongoing effects
	_update_effects(delta)

func _execute_special_ability(delta: float):
	match special_ability:
		"ice_trail":
			_create_ice_trail()
			ability_cooldown = 2.0
		"teleport":
			_teleport_behind_player()
			ability_cooldown = 4.0
		"camouflage":
			_toggle_camouflage()
			ability_cooldown = 3.0
		"wave_attack":
			_create_wave_attack()
			ability_cooldown = 3.5
		"mine_laying":
			_lay_mine()
			ability_cooldown = 5.0
		"lightning_strike":
			_lightning_strike()
			ability_cooldown = 6.0
		"gravity_pull":
			_gravity_pull()
			ability_cooldown = 4.0
		"alien_swarm":
			_alien_swarm()
			ability_cooldown = 7.0

func _create_ice_trail():
	var ice = preload("res://scenes/IceTrail.tscn").instantiate()
	get_parent().add_child(ice)
	ice.global_position = global_position
	ice_trail.append(ice)
	
	# Clean up old ice trails
	if ice_trail.size() > 5:
		ice_trail[0].queue_free()
		ice_trail.pop_front()

func _teleport_behind_player():
	if not player:
		return
	
	# Teleport effect
	var teleport_effect = preload("res://scenes/TeleportEffect.tscn").instantiate()
	get_parent().add_child(teleport_effect)
	teleport_effect.global_position = global_position
	
	# Teleport behind player
	var behind_pos = player.global_position + Vector2(-100, 0)
	global_position = behind_pos
	
	# Arrival effect
	var arrival_effect = preload("res://scenes/TeleportEffect.tscn").instantiate()
	get_parent().add_child(arrival_effect)
	arrival_effect.global_position = global_position

func _toggle_camouflage():
	camouflage_active = not camouflage_active
	if camouflage_active:
		sprite.modulate.a = 0.3
	else:
		sprite.modulate.a = 1.0

func _create_wave_attack():
	var wave = preload("res://scenes/WaveAttack.tscn").instantiate()
	get_parent().add_child(wave)
	wave.global_position = global_position
	wave.direction = Vector2.LEFT

func _lay_mine():
	var mine = preload("res://scenes/ProximityMine.tscn").instantiate()
	get_parent().add_child(mine)
	mine.global_position = global_position

func _lightning_strike():
	if not player:
		return
	
	var lightning = preload("res://scenes/LightningStrike.tscn").instantiate()
	get_parent().add_child(lightning)
	lightning.global_position = player.global_position

func _gravity_pull():
	if not player:
		return
	
	# Create gravity well effect
	var gravity_well = preload("res://scenes/GravityWell.tscn").instantiate()
	get_parent().add_child(gravity_well)
	gravity_well.global_position = global_position

func _alien_swarm():
	for i in range(3):
		var swarm_drone = preload("res://scenes/SwarmDrone.tscn").instantiate()
		get_parent().add_child(swarm_drone)
		swarm_drone.global_position = global_position + Vector2(randf_range(-50, 50), randf_range(-50, 50))

func _update_effects(delta: float):
	# Update poison cloud timer
	if poison_cloud_timer > 0:
		poison_cloud_timer -= delta
	
	# Update laser charge
	if laser_charge > 0:
		laser_charge -= delta

func take_damage(damage: int):
	# Camouflage reduces damage
	if camouflage_active:
		damage = damage / 2
	
	super.take_damage(damage)

func die():
	super.die()
	
	# Clean up special effects
	for ice in ice_trail:
		if is_instance_valid(ice):
			ice.queue_free()