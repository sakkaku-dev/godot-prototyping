# Ref: https://github.com/teebarjunk/godot-text_effects/blob/master/addons/teeb.text_effects/effects/Jump.gd
class_name TypedEffect
extends RichTextEffect

@export var color := Color.WHITE
@export var jump_height := 5
@export var frequency := 5

# Syntax: [typed until=2][/typed]
var bbcode = "typed"

func _process_custom_fx(char_fx):
	var idx = char_fx.relative_index

	var until = char_fx.env.get("until", 0)
	if idx < until:
		var colored = char_fx.env.get("colored", true)
		if colored:
			char_fx.color = color

		var offset = (until - idx - 1) * frequency
		var original_y = _get_offset(char_fx.elapsed_time, 1)
		char_fx.offset.y -= _get_offset(char_fx.elapsed_time, offset)

	return true

func _get_offset(time: float, offset: int):
	return abs(sin(time * 8.0 + offset * PI * .025)) * jump_height
