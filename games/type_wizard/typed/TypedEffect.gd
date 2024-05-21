# Ref: https://github.com/teebarjunk/godot-text_effects/blob/master/addons/teeb.text_effects/effects/Jump.gd
class_name TypedEffect
extends RichTextEffect

#@export var hit_color := Color.RED
#@export var color := Color.WHITE
@export var jump_height := 5
@export var frequency := 5

# Syntax: [typed until=2 hit=1 color=#234234 jump=true][/typed]
var bbcode = "typed"

func _process_custom_fx(char_fx):
	var idx = char_fx.relative_index

	var until = char_fx.env.get("until", 0)
	var color = char_fx.env.get("color", "")
	if idx < until:
		if color is String and color != "":
			char_fx.color = Color(color)

		var jump = char_fx.env.get("jump", true)
		if jump:
			var offset = (until - idx - 1) * frequency
			var original_y = _get_offset(char_fx.elapsed_time, 1)
			char_fx.offset.y -= _get_offset(char_fx.elapsed_time, offset)
	
	
	#var hit = char_fx.env.get("hit", 0)
	#if idx < hit:
		#char_fx.color = hit_color
		
	return true

func _get_offset(time: float, offset: int):
	return abs(sin(time * 8.0 + offset * PI * .025)) * jump_height
