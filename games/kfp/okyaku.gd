extends CharacterBody2D

@onready var move_target = $MoveTarget
@onready var people_detection = $PeopleDetection

func _process(delta):
	_detect_nearby_people()

func _detect_nearby_people():
	for area in people_detection.get_overlapping_areas():
		var dir = global_position.direction_to(area.global_position)
		if dir.dot(move_target.current_dir) > 0.5:
			move_target.stop = true
			return
	
	move_target.stop = false

func add_target(pos):
	move_target.add_target(pos)
