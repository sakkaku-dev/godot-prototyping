class_name HandHold
extends RemoteTransform2D

@export var rotation_root: Node2D
@export var hand: Hand
@export var max_throw := 800
@export var throw_increase := 400

var holding = null
var pressing := false
var throw_strength := 0.0

func _ready():
	hand.interacted.connect(func(obj):
		var root = obj.get_parent()
		remote_path = get_path_to(root)
		holding = root
		hand.disable()
	)

func _process(delta):
	if pressing:
		throw_strength = min(throw_strength + throw_increase * delta, max_throw)

func _input(event):
	if not holding: return
	
	if event.is_action_pressed("action"):
		pressing = true
		throw_strength = 0
	elif event.is_action_released("action"):
		var dir = Vector2.RIGHT.rotated(rotation_root.global_rotation)
		holding.throw(dir * throw_strength)
		_release()
	
func _release():
	remote_path = NodePath("")
	holding = null
	hand.enable()
