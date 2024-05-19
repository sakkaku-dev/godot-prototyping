class_name TypedEnemy
extends TypedCharacter

signal removed()

const ENEMY_GROUP = "TypedEnemy"

@onready var hit_box = $HitBox
@onready var center_move = $CenterMove

func _ready():
	super._ready()
	add_to_group(ENEMY_GROUP)
	finished.connect(func(): removed.emit())
	hit_box.hit.connect(func(): removed.emit())
	removed.connect(func(): queue_free())

func _physics_process(delta):
	center_move.move(self, delta)
