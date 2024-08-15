shader_type canvas_item;

uniform vec4 fill_color: source_color = vec4(1.0);
uniform float fill: hint_range(0.0, 1.0, 0.01) = 0.0;
uniform bool flip = false;

void fragment() {
	vec4 color = COLOR;

	if (flip) {
		if (UV.x > (1.-fill)) {
			color.rgb = fill_color.rgb;
		}
	} else {
		if (UV.x <= fill) {
			color.rgb = fill_color.rgb;
		}
	}

	COLOR = color;
}
