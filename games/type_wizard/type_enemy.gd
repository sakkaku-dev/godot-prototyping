class_name TypedEnemy
extends TypedCharacter

const ENEMY_GROUP = "TypedEnemy"

@onready var hit_box = $HitBox
@onready var center_move = $CenterMove

func _ready():
	super._ready()
	add_to_group(ENEMY_GROUP)
	finished.connect(func(): queue_free())
	hit_box.hit.connect(func(): queue_free())

func _physics_process(delta):
	center_move.move(self, delta)
