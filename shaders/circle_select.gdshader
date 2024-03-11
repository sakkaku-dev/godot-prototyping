shader_type canvas_item;

const vec2 MIDPOINT = vec2(0.5, 0.5);
const float color_count = 4.0;
const float color_offset = TAU/color_count;
const float color_width = color_offset;

uniform float width_max = 1.0;
uniform float width_min = 0.5;

uniform float cursor_deg = 0.0;
uniform float inactive_amount = 0.5;

uniform vec4 color_1: source_color;
uniform vec4 color_2: source_color;
uniform vec4 color_3: source_color;
uniform vec4 color_4: source_color;

float circle(vec2 uv, float radius) {
	float dist = length(uv - MIDPOINT);

	return 1. - smoothstep
	(
		radius - (radius * 0.01),
		radius + (radius * 0.01),
		(dist * dist) * 4.0
	);
}

float is_in_circle(vec2 uv, float min_w, float max_w) {
	return circle(uv, max_w) - circle(uv, min_w);
}

float find_deg(vec2 uv) {
	vec2 offset = uv - MIDPOINT;
	return atan(offset.y, offset.x);
}

float normalize_deg(float deg) {
	float angle = deg + PI;
	angle -= PI/2.;
	angle = mod(angle, TAU);
	return angle;
}

float when_gt(float x, float y) { return max(sign(x - y), 0.0); }
float when_lt(float x, float y) { return max(sign(y - x), 0.0); }

vec4 mix_color(vec4 color, vec4 mix_color, float angle, float offset_count) {
	float start_angle = min(offset_count * TAU, TAU) - offset_count * color_offset;
	float end_angle = start_angle + color_width;
	
	float deg = normalize_deg(cursor_deg - PI/2.);
	float active = step(2.0, 1. - when_lt(deg, start_angle) + when_lt(deg, end_angle)) * inactive_amount + (1.0 - inactive_amount);
	float amount = step(2.0, 1. - when_lt(angle, start_angle) + when_lt(angle, end_angle));
	return mix(color, mix_color, amount * active);
}

void fragment() {
	float angle = normalize_deg(find_deg(UV));
	
	vec4 color = COLOR;
	color = mix_color(color, color_1, angle, 0.);
	color = mix_color(color, color_4, angle, 1.);
	color = mix_color(color, color_3, angle, 2.);
	color = mix_color(color, color_2, angle, 3.);

	COLOR = color * is_in_circle(UV, width_min, width_max);
}
