extends CharacterBody3D

@export var friction := 5.
@onready var interactable_3d: Interactable3D = $Interactable3D

var gravity := 0.9
var item: PotionItem.Type = -1

func _ready() -> void:
	interactable_3d.interacted.connect(func(hand: Hand3D):
		hand.hold_item(PotionItem.new(item))
		queue_free()
	)

func throw_at(throw_dir: Vector3):
	velocity = throw_dir
	print("Throwing to %s" % throw_dir)

func _physics_process(delta: float) -> void:
	velocity.x = move_toward(velocity.x, 0, friction * delta)
	velocity.z = move_toward(velocity.z, 0, friction * delta)
	
	if is_on_floor():
		velocity = Vector3.ZERO
	else:
		velocity.y -= gravity
	move_and_slide()
