class_name CastleArcher
extends Area2D

@export var attack_scene: PackedScene
@export var enemy_spawner: EnemySpawner
@export var attack_timer: Timer

var attack_time := 3.0
var arrows := 0:
	set(v):
		if arrows == 0 and v > 0:
			attack_timer.start(attack_time)
		
		arrows = v

func _ready():
	attack_timer.start(attack_time)
	attack_timer.timeout.connect(func(): _attack())
	
func _attack():
	var shot = []
	for i in range(arrows):
		var enemy = _find_enemy_to_attack(shot)
		if enemy:
			enemy.auto_type(self)
			shot.append(enemy)
	
	attack_timer.start(attack_time)
	
func _find_enemy_to_attack(exclude: Array):
	var closest = null
	for m in get_overlapping_bodies():
		if m.is_focused() or m.is_finished or m in exclude: continue
		if closest == null or m.global_position.length() < closest.global_position.length():
			closest = m
	return closest

func attack(target: TypedEnemy):
	var node = attack_scene.instantiate()
	node.global_position = global_position
	node.target = target
	get_tree().current_scene.add_child(node)
