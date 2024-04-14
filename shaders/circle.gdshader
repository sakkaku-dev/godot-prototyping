shader_type canvas_item;

uniform float radius : hint_range(0.0, 1.0) = 1.0;
uniform float fill : hint_range(0.0, 1.0) = 1.0;

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
	
	float inside_circle = 1. - step(radius/2.0, distance(UV, vec2(0.5,0.5)));
	COLOR.a = inside_circle * t;
}