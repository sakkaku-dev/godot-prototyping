class_name KiaraKFP
extends CharacterBody2D

const GROUP = "Player"

@export var cursor: SnappedCursor
@export var cursor_transform: RemoteTransform2D

@onready var hand = $Hand
@onready var top_down_move_2d = $TopDownMove2D
@onready var item = $Item
@onready var root = $Root

static func get_object(n: Node) -> KiaraKFP:
	return n.get_tree().get_first_node_in_group(GROUP)

func _ready():
	add_to_group(GROUP)
	cursor_transform.remote_path = cursor_transform.get_path_to(cursor)

func _physics_process(delta):
	if hand.interacting: return
	top_down_move_2d.process(delta)
	
	if velocity.length() > 0.1:
		root.rotation = Vector2.RIGHT.angle_to(velocity)

func _process(delta):
	item.visible = hand.item != null

func _unhandled_input(event):
	if event.is_action_pressed("interact"):
		hand.interact_start()
		get_viewport().set_input_as_handled()
	if event.is_action_released("interact"):
		hand.interact()
		get_viewport().set_input_as_handled()
