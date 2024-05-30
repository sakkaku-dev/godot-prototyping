extends Area2D

@export var res: LightningEffectResource
#@export var line_scene: PackedScene
@export var duration := 0.2

const SCENE = "res://games/type_wizard/attacks/lightning_area.tscn"

var current = []

func _ready():
	get_tree().create_timer(0.05).timeout.connect(func(): _lightning_chain())
	#print("Spawn lightning with chance of %s, previous: %s" % [res.lightning_chance, current.size()])

func _lightning_chain():
	var bodies = []
	for body in get_overlapping_bodies():
		if body in current or body.is_finished: continue
		if randf() < res.lightning_chance:
			bodies.append(body)

	#print("Hitting %s of %s" % [bodies.size(), get_overlapping_bodies().size()])
	for body in bodies:
		if body == null or body.is_queued_for_deletion(): continue
		body.auto_hit()
		body.hit_health(false)
		
		var line = load(SCENE).instantiate()
		line.current = current.duplicate()
		line.current.append_array(bodies)
		line.res = _reduced_resource()
		
		line.global_position = body.global_position
		get_tree().current_scene.add_child(line)
		$LightningLine.points = [to_local(global_position), to_local(body.global_position)]
		
		await get_tree().create_timer(0.5).timeout
	
	_fade_out()

func _fade_out():
	var tw = create_tween().set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_CUBIC)
	tw.tween_property(self, "modulate", Color.TRANSPARENT, duration)
	await tw.finished
	queue_free()

func _reduced_resource():
	var r = res.duplicate()
	r.lightning_chance -= r.drop_off
	return r
