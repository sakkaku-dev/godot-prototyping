extends Fish

@export var attack_speed := 120

@onready var attack_area = $AttackArea
@onready var charge_timer = $ChargeTimer

var target: Node2D
var target_pos: Vector2

func _ready():
	super._ready()
	
	attack_area.body_entered.connect(func(b):
		if charge_timer.is_stopped() and not target_pos:
			target = b
			charge_timer.start()
	)
	
	charge_timer.timeout.connect(func():
		target_pos = target.global_position
	)

func _attack_player(p: Hook):
	charge_timer.start()

func _physics_process(delta):
	if target_pos:
		var dir = global_position.direction_to(target_pos)
		velocity = dir * attack_speed
		
		if global_position.distance_to(target_pos) < 10:
			target_pos = Vector2.ZERO
		
		return
	
	super._physics_process(delta)
