extends Node
class_name BossManager

signal boss_defeated(boss_name: String)
signal boss_phase_changed(phase: int)

var current_boss: Node = null
var boss_phases: int = 3
var current_phase: int = 1
var boss_patterns: Dictionary = {}

func _ready():
	_setup_boss_patterns()

func _setup_boss_patterns():
	boss_patterns = {
		"FireDragon": {
			"phases": [
				{
					"health_threshold": 1.0,
					"attacks": ["fire_breath", "claw_swipe"],
					"speed": 80,
					"attack_rate": 2.0
				},
				{
					"health_threshold": 0.6,
					"attacks": ["fire_breath", "claw_swipe", "meteor_shower"],
					"speed": 100,
					"attack_rate": 1.5
				},
				{
					"health_threshold": 0.3,
					"attacks": ["fire_breath", "claw_swipe", "meteor_shower", "inferno"],
					"speed": 120,
					"attack_rate": 1.0
				}
			]
		},
		"CyberNexus": {
			"phases": [
				{
					"health_threshold": 1.0,
					"attacks": ["laser_beam", "missile_barrage"],
					"speed": 60,
					"attack_rate": 2.5
				},
				{
					"health_threshold": 0.7,
					"attacks": ["laser_beam", "missile_barrage", "drone_swarm"],
					"speed": 80,
					"attack_rate": 2.0
				},
				{
					"health_threshold": 0.4,
					"attacks": ["laser_beam", "missile_barrage", "drone_swarm", "system_overload"],
					"speed": 100,
					"attack_rate": 1.5
				}
			]
		},
		"Leviathan": {
			"phases": [
				{
					"health_threshold": 1.0,
					"attacks": ["water_jet", "torpedo_launch"],
					"speed": 50,
					"attack_rate": 3.0
				},
				{
					"health_threshold": 0.65,
					"attacks": ["water_jet", "torpedo_launch", "tsunami"],
					"speed": 70,
					"attack_rate": 2.0
				},
				{
					"health_threshold": 0.35,
					"attacks": ["water_jet", "torpedo_launch", "tsunami", "depth_charge"],
					"speed": 90,
					"attack_rate": 1.5
				}
			]
		},
		"SkyDestroyer": {
			"phases": [
				{
					"health_threshold": 1.0,
					"attacks": ["lightning_bolt", "wind_gust"],
					"speed": 90,
					"attack_rate": 2.0
				},
				{
					"health_threshold": 0.6,
					"attacks": ["lightning_bolt", "wind_gust", "thunder_storm"],
					"speed": 110,
					"attack_rate": 1.5
				},
				{
					"health_threshold": 0.3,
					"attacks": ["lightning_bolt", "wind_gust", "thunder_storm", "divine_wind"],
					"speed": 130,
					"attack_rate": 1.0
				}
			]
		},
		"AlienOverlord": {
			"phases": [
				{
					"health_threshold": 1.0,
					"attacks": ["plasma_blast", "alien_drone"],
					"speed": 70,
					"attack_rate": 2.5
				},
				{
					"health_threshold": 0.7,
					"attacks": ["plasma_blast", "alien_drone", "mind_control"],
					"speed": 90,
					"attack_rate": 2.0
				},
				{
					"health_threshold": 0.4,
					"attacks": ["plasma_blast", "alien_drone", "mind_control", "dimension_rift"],
					"speed": 110,
					"attack_rate": 1.5
				}
			]
		}
	}

func spawn_boss(boss_type: String, position: Vector2) -> Node:
	var boss_scene = preload("res://scenes/AdvancedBoss.tscn")
	var boss = boss_scene.instantiate()
	boss.boss_type = boss_type
	boss.global_position = position
	
	# Setup boss based on type
	_setup_boss(boss, boss_type)
	
	current_boss = boss
	return boss

func _setup_boss(boss: Node, boss_type: String):
	var boss_data = boss_patterns.get(boss_type, {})
	boss_phases = boss_data.get("phases", []).size()
	current_phase = 1
	
	# Set initial boss stats
	match boss_type:
		"FireDragon":
			boss.health = 800
			boss.max_health = 800
			boss.speed = 80
		"CyberNexus":
			boss.health = 1000
			boss.max_health = 1000
			boss.speed = 60
		"Leviathan":
			boss.health = 900
			boss.max_health = 900
			boss.speed = 50
		"SkyDestroyer":
			boss.health = 750
			boss.max_health = 750
			boss.speed = 90
		"AlienOverlord":
			boss.health = 1200
			boss.max_health = 1200
			boss.speed = 70

func update_boss_phase(boss: Node):
	if not boss_patterns.has(boss.boss_type):
		return
	
	var patterns = boss_patterns[boss.boss_type]
	var health_percentage = float(boss.health) / float(boss.max_health)
	
	for i in range(patterns.phases.size()):
		var phase = patterns.phases[i]
		if health_percentage <= phase.health_threshold and current_phase < i + 1:
			current_phase = i + 1
			boss_phase_changed.emit(current_phase)
			_apply_phase_changes(boss, phase)
			break

func _apply_phase_changes(boss: Node, phase: Dictionary):
	boss.speed = phase.speed
	boss.attack_rate = phase.attack_rate
	boss.available_attacks = phase.attacks
	
	# Visual effect for phase change
	var phase_effect = preload("res://scenes/PhaseChangeEffect.tscn").instantiate()
	get_parent().add_child(phase_effect)
	phase_effect.global_position = boss.global_position

func on_boss_defeated(boss_name: String):
	boss_defeated.emit(boss_name)
	current_boss = null
	current_phase = 1
	
	# Victory rewards
	var bonus_score = match boss_name:
		"FireDragon": 2000
		"CyberNexus": 2500
		"Leviathan": 2250
		"SkyDestroyer": 2100
		"AlienOverlord": 3000
		_: 1500
	
	Global.add_score(bonus_score)