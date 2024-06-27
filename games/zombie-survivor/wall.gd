extends StaticBody2D

@onready var navigation_obstacle_2d = $NavigationObstacle2D

func _ready():
	var map = get_tree().get_first_node_in_group("map")
	navigation_obstacle_2d.set_navigation_map(map)
