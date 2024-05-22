class_name Manage
extends Dialog

signal next_wave()

@export var player: Wizard

@export var attack_item_scene: PackedScene

@export var next_wave_btn: TypedWord

@export var attack_btn: TypedWord
@export var scroll_btn: TypedWord
@export var castle_btn: TypedWord

@export var main_panel: Control
@export var attack_panel: Control

@onready var open_pos_x := position.x

@onready var key_delegator = $KeyDelegator

var inner_tw: Tween

func _ready():
	super._ready()
	key_reader.pressed_cancel.connect(func(_x): key_delegator.cancel())
	key_delegator.nodes = [attack_btn, scroll_btn, castle_btn]
	
	closed.connect(func(): next_wave.emit())
	next_wave_btn.word = "Next Wave"
	next_wave_btn.type_finish.connect(func(): close())
	
	attack_panel.hide()
	attack_btn.word = "Attack"
	attack_btn.type_finish.connect(func():
		main_panel.hide()
		attack_panel.show()
	)
	
	_update_attacks()
	player.attacks_changed.connect(func(_x): _update_attacks())
	
	scroll_btn.word = "Scrolls"
	scroll_btn.type_finish.connect(func(): )
	
	castle_btn.word = "Castle"
	castle_btn.type_finish.connect(func(): )

func _update_attacks():
	for c in attack_panel.get_children():
		attack_panel.remove_child(c)
		
	for atk in player.attacks:
		var node = attack_item_scene.instantiate()
		node.res = atk
		attack_panel.add_child(node)

func open():
	_pre_open()
	tw = TweenCreator.create(self, tw)
	
	position.x = open_pos_x + size.x
	tw.tween_property(self, "position:x", open_pos_x, 0.5)
	

func close():
	tw = TweenCreator.create(self, tw)
	tw.tween_property(self, "position:x", open_pos_x + size.x, 0.5)
	await tw.finished
	_post_close()

func handle_key(key: String, shift: bool):
	if shift:
		next_wave_btn.handle_key(key)
		return
	
	key_delegator.handle_key(key)
