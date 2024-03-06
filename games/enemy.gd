class_name Enemy
extends CharacterBody2D

@export var max_wander_distance := 200
@export var min_wander_distance := 120

@onready var detection_range = $DetectionRange
@onready var chase_look_cast = $ChaseLookCast
@onready var wander_idle_timer = $WanderIdleTimer
@onready var wander_agent_2d = $WanderAgent2D
@onready var chase_agent_2d = $ChaseAgent2D
@onready var hurtbox = $Hurtbox

@onready var player := get_tree().get_first_node_in_group("player")

var was_chasing := false

func _ready():
	wander_idle_timer.timeout.connect(func(): _set_random_wander())
	wander_agent_2d.reached.connect(func(): wander_idle_timer.random_start())
	hurtbox.died.connect(func(): queue_free())
	
	wander_idle_timer.random_start()
	
func _set_random_wander():
	var dir = Vector2.RIGHT.rotated(randf_range(0, TAU))
	wander_agent_2d.set_target(global_position + dir * randf_range(min_wander_distance, max_wander_distance))

func _physics_process(delta):
	var overlapping = detection_range.get_overlapping_bodies()
	if overlapping.size() > 0:
		chase_look_cast.target_position = player.global_position - global_position
		chase_agent_2d.set_target(player.global_position)
		chase_agent_2d.process(delta)
		was_chasing = true
	else:
		if was_chasing:
			await get_tree().create_timer(3.0).timeout
		
		wander_agent_2d.process(delta)
		was_chasing = false
