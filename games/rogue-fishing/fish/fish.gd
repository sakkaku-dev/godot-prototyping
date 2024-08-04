class_name Fish
extends CharacterBody2D

@export var move_dir := Vector2(1, 0)
@export var body: Node2D
@export var fish: FishResource

@onready var visible_on_screen_notifier_2d = $VisibleOnScreenNotifier2D
@onready var sprite_2d = $Sprite2D

var hook: Hook
var has_entered_screen := false

func _ready():
	sprite_2d.texture = fish.sprite
	visible_on_screen_notifier_2d.screen_entered.connect(func(): has_entered_screen = true)
	
	move_dir = move_dir.rotated(global_rotation)
	face_rotation()

func face_rotation():
	var dir = Vector2.RIGHT.rotated(global_rotation)
	var is_flipped = Vector2.LEFT.dot(dir) > 0
	
	body.scale.y = -1 if is_flipped else 1
	body.scale.x = sign(move_dir.x) * body.scale.y

func _physics_process(_delta):
	if hook and is_instance_valid(hook):
		global_position = hook.global_position
		return
	
	velocity = move_dir.normalized() * fish.speed
	move_and_slide()
	
	if has_entered_screen and abs(global_position.x) > 200:
		queue_free()
