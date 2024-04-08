extends Area2D

signal eggs_collected(eggs)

@export var speed := 150
@export var min_move_x := -140
@export var max_move_x := 140

@export var min_break := 1
@export var max_break := 3

@onready var nest = $Nest

var motion := 0.0
var collected := 0

# Does not work inside a SubViewport, check manually
#func _ready():
	#area_entered.connect(func(a): _on_area_entered(a))

func _on_area_entered(a: Egg):
	if a.egg:
		collected += 1
	else:
		var broken = randi_range(min_break, max_break)
		collected = max(0, collected - broken)
	
	eggs_collected.emit(collected)
	nest.frame = 2 if collected > 0 else 3
	a.queue_free()

func get_size():
	return ($CollisionShape2D.shape as RectangleShape2D).size

func _physics_process(delta):
	motion = Input.get_axis("move_left", "move_right")
	
	if global_position.x >= max_move_x and motion > 0:
		return
	 
	if global_position.x <= min_move_x and motion < 0:
		return
	
	translate(Vector2.RIGHT * motion * speed * delta)

func _process(delta):
	var size = get_size()
	var rect = Rect2i(global_position - size / 2, size)
	for node in get_tree().get_nodes_in_group(Egg.GROUP):
		var node_size = node.get_size()
		var node_rect = Rect2i(node.global_position - node_size / 2, node_size)
		if rect.intersects(node_rect):
			_on_area_entered(node)
