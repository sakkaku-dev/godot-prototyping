class_name CastleArcher
extends Area2D

@export var wizard: Wizard
@export var attack_scene: PackedScene
@export var enemy_spawner: EnemySpawner
@export var attack_timer: Timer

@onready var circle_indicator = $CircleIndicator

var attack_time := 3.0
var arrows := 0:
	set(v):
		if arrows == 0 and v > 0:
			_attack()
			circle_indicator.show_indicator()
		
		arrows = v

func _ready():
	attack_timer.start(attack_time)
	attack_timer.timeout.connect(func(): _attack())
	area_entered.connect(func(a):
		if attack_timer.is_stopped() and not a.is_finished:
			attack_enemy(a)
			attack_timer.start(attack_time)
	)
	
func _attack():
	var shot = []
	for i in range(arrows):
		var enemy = _find_enemy_to_attack(shot)
		if enemy:
			attack_enemy(enemy)
			shot.append(enemy)
	
	if shot.size() > 0:
		attack_timer.start(attack_time)

func _find_enemy_to_attack(exclude: Array):
	var closest = null
	for m in get_overlapping_bodies():
		if m.is_focused() or m.is_finished or m in exclude: continue
		
		var diff = m.global_position.x - (closest.global_position.x if closest else 0)
		var is_shorter = closest != null and m.get_remaining_word().length() < closest.get_remaining_word().length()
		if closest == null or (is_shorter and abs(diff) < 50) or diff < 0:
			closest = m
	return closest

func attack_enemy(target: TypedEnemy):
	var node = attack_scene.instantiate()
	node.global_position = global_position
	node.target = target
	get_tree().current_scene.add_child(node)
	target.auto_hit()
