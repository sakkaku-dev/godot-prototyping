class_name Chicken
extends CharacterBody2D

signal clicked_chicken()

@export var res: ChickenResource
@export var selectable: Draggable
@export var drag_speed := 200

@onready var drag_area: Area2D = $DragArea
@onready var move_collide = $MoveCollide
@onready var idle_timer = $IdleTimer
@onready var wander_timer = $WanderTimer
@onready var butcher_button: TextureButton = $ButcherButton

func _ready():
	idle_timer.timeout.connect(func():
		move_collide.stop()
		wander_timer.random_start()
	)
	wander_timer.timeout.connect(func():
		move_collide.random_direction()
		idle_timer.random_start()
	)
	
	selectable.clicked.connect(func(): clicked_chicken.emit())
	selectable.drag_end.connect(_on_drag_ended)
	#selectable.mouse_entered.connect(func(): butcher_button.show())
	#selectable.mouse_exited.connect(func(): butcher_button.hide())
	butcher_button.pressed.connect(func(): KfpManager.butcher_chicken(res))
	butcher_button.hide()
	
	KfpManager.chicken_removed.connect(func(chicken):
		if chicken == res:
			queue_free()
	)
	

func set_selected(selected: bool):
	butcher_button.visible = selected
	move_collide.stop()
	idle_timer.stop()
	wander_timer.start(4.) # wait for player to do something

func _on_drag_ended():
	for area in drag_area.get_overlapping_areas():
		if area is DroppableArea:
			area.dropped.emit(self)
			return

func _physics_process(delta):
	if not selectable.dragging:
		move_collide.process(delta)
	else:
		var dir = selectable.get_drag_position() - global_position
		velocity = dir.normalized() * drag_speed if dir.length() >= 5 else Vector2.ZERO
		move_and_slide()
