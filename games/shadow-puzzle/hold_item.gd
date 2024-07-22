extends CharacterBody3D

@export var deaccel := 10
@export var enabled = false
@export var impact_scene: PackedScene

@onready var item = $Item

var gravity = -30

func _ready():
	item.picked_up.connect(func(): queue_free())

func throw(force: Vector3):
	velocity = force
	enabled = true

func _physics_process(delta):
	item.monitorable = enabled
	
	if enabled:
		velocity.x = move_toward(velocity.x, 0, deaccel * delta)
		velocity.z = move_toward(velocity.z, 0, deaccel * delta)
		velocity.y += gravity * delta
		
		if move_and_slide():
			velocity = Vector3.ZERO
			var eff = impact_scene.instantiate()
			eff.global_position = global_position
			get_tree().current_scene.add_child(eff)
			
			queue_free()
