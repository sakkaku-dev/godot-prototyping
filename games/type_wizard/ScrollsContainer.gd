class_name ScrollsContainer
extends PanelContainer

@export var spell_item: PackedScene
@export var container: Control
@export var data: DataManager
@export var wizard: Wizard

@onready var original_pos = position.x
@onready var key_delegator = $KeyDelegator

var tw: Tween

func _ready():
	wizard.is_casting.connect(func(c): toggle(c))
	hide()

func update():
	for c in container.get_children():
		container.remove_child(c)
	key_delegator.remove_all()
	
	var scrolls = wizard.scrolls
	for scroll in scrolls:
		var node = spell_item.instantiate()
		node.spell = data.get_spell(scroll)
		node.count = scrolls[scroll]
		node.scroll = scroll
		node.cast.connect(func():
			wizard.do_cast(scroll)
			toggle(false)
		)
		
		container.add_child(node)
		key_delegator.nodes.append(node)

func toggle(open):
	tw = TweenCreator.create(self, tw)
	show()
	
	var hide_pos = original_pos + size.x
	if open:
		update()
		position.x = hide_pos
		tw.tween_property(self, "position:x", original_pos, 0.5)
	else:
		cancel()
		tw.tween_property(self, "position:x", hide_pos, 0.5)

func handle_key(key: String):
	key_delegator.handle_key(key)

func cancel():
	key_delegator.cancel()
