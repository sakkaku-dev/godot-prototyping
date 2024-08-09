class_name ChickenDetails
extends PanelContainer

signal butcher_chicken(res)
signal close()

@export var editable := false
@export var res: ChickenResource

@export var name_label: Label
@export var traits_label: Label
@export var butcher_button: BaseButton
@export var close_button: BaseButton

func _ready():
	hide()
	close_button.pressed.connect(func(): close.emit())
	butcher_button.pressed.connect(func(): butcher_chicken.emit(res))
	butcher_button.visible = editable

func show_chicken(chicken: ChickenResource):
	if chicken == null:
		hide()
		return
	
	res = chicken
	name_label.text = "%s" % res.name
	traits_label.text = "%s" % "\n".join(res.traits.map(func(x): return ChickenTraits.get_trait_name(x)))
	show()
