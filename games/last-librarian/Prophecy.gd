extends Control

const PROPHECIES = {
	LastLibrarian.Prophecy.ALIEN: "In ancient prophecies, it is foretold that when the twin moons align, uncanny presences will descend upon the world, unleashing a malevolent force from the stars, bringing cosmic winter and devastation with their advanced weaponry.",
	LastLibrarian.Prophecy.METEORITE: "In ancient prophecies, it is foretold that when the constellation of the falling dragon aligns, a fiery celestial visitor will blaze through the heavens. Its arrival shaking the very foundations of earth with devastating force.",
	LastLibrarian.Prophecy.PANDEMIC: "In ancient prophecies, it is foretold that a dark shadow will descend upon the lands, spreading silently like a creeping mist. From distant shores, unseen maladies will emerge, sweeping across continents with relentless fury."
}

const HINT = {
	LastLibrarian.Prophecy.ALIEN: "Only the chosen, armed with forgotten powers, will stand as the last hope against the approaching danger.",
	LastLibrarian.Prophecy.METEORITE: "Amidst the chaos, survival will depend on unity and bravery as humankind faces the looming shadow of celestial wrath.",
	LastLibrarian.Prophecy.PANDEMIC: "The salvation from the looming scourge lies in the hidden scrolls of knowledge through the unity of hearts."
}

@export var label: Label
@export var hint_label: Label
@export var interactable: Interactable
@export var game: LastLibrarian
@export var open_sound: AudioStreamPlayer

var tw: Tween

func _ready():
	interactable.interacted.connect(func(_a):
		show_prophecy(game.prophecy)
		interactable.enabled = false
	)
	hide()

func _unhandled_input(event):
	_continue(event)
	
func _gui_input(event):
	_continue(event)

func show_prophecy(prophecy: LastLibrarian.Prophecy):
	label.text = PROPHECIES[prophecy]
	hint_label.text = HINT[prophecy]
	
	open_sound.play()
	tw = TweenCreator.create(self, tw).set_ease(Tween.EASE_IN_OUT)
	tw.tween_property(self, "modulate", Color.WHITE, 0.5).from(Color.TRANSPARENT)
	show()
	get_tree().paused = true

func _continue(ev: InputEvent):
	if not visible or (tw and tw.is_running()):
		return

	if ev.is_action_pressed("continue") or ev.is_action_pressed("interact") or ev.is_action_pressed("ui_cancel"):
		get_viewport().set_input_as_handled()
	
		tw = TweenCreator.create(self, tw).set_ease(Tween.EASE_IN_OUT)
		tw.tween_property(self, "modulate", Color.TRANSPARENT, 0.5)
		get_tree().paused = false
		
		await tw.finished
		hide()
		
		interactable.enabled = true
