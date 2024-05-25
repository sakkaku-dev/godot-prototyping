shader_type canvas_item;

uniform float radius : hint_range(0.0, 1.0) = 1.0;
uniform float inner_radius : hint_range(0.0, 1.0) = 0.0;
uniform float fill : hint_range(0.0, 1.0) = 1.0;
uniform float blur : hint_range(0., 0.2, .0001) = 0.0001;

uniform vec4 bg_color: source_color = vec4(0., 0., 0., 1.);
uniform vec4 inner_color: source_color = vec4(0., 0., 0., 0.);

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
	vec2 center = vec2(0.5, 0.5);
	float dist = distance(UV, center);
	float r = radius / 2.0;
	float inside_circle = smoothstep(r + blur, r - blur, dist);
	COLOR.a *= inside_circle;
	
	float inner_r = inner_radius / 2.0;
	float inner_circle = 1. - smoothstep(inner_r + blur, inner_r - blur, dist);
	COLOR = mix(inner_color, COLOR, inner_circle);
	
	vec2 uv = (UV * 2.0) - 1.0;
	float t = mask(uv, fill);
	COLOR = mix(bg_color * COLOR.a, COLOR, t);
}