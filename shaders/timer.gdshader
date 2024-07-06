shader_type canvas_item;

uniform vec4 mix_color: source_color = vec4(1.0);
uniform float mix_amount: hint_range(0.0, 1.0, 0.1) = 1.0;
uniform float fill: hint_range(0.0, 1.0, 0.01) = 0.0;

float remap(float i_min, float i_max, float o_min, float o_max, float val) {
	float t = (val - i_min) / (i_max - i_min);
	return o_min + (o_max - o_min) * t;
}

float mask(vec2 uv, float value)
{
	float r = atan(uv.x, uv.y);
	r = remap(-PI, PI, 0.0, 1.0, r);
	return step(r, value);
}

void fragment() {
	vec2 uv = (UV * 2.0) - 1.0;
	float t = mask(uv, fill);
	COLOR = mix(COLOR, mix(COLOR, mix_color, mix_amount) * COLOR.a, t);
}