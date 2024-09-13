shader_type spatial;
render_mode unshaded, cull_disabled, depth_draw_opaque, depth_prepass_alpha;

//render_mode unshaded;

uniform sampler2D tex : source_color;  // Texture, used as color

uniform vec4 mix_color: source_color = vec4(1.0);
uniform float mix_amount: hint_range(0.0, 1.0, 0.01) = 1.0;
uniform float fill: hint_range(0.0, 1.0, 0.01) = 0.0;

uniform float scale = 1.0;
uniform float rotation_speed = 1.0;

// This enables billboard with shaders
// For Billboard in Godot 4 -> https://godotshaders.com/shader/billboard-sprite3d-hitflash-godot-4-x
// For Scaling -> https://godotshaders.com/shader/billboard-sprite3d-sway-godot-4-0/
void vertex(){
	VERTEX = VERTEX * vec3(scale, scale, scale);
	MODELVIEW_MATRIX = VIEW_MATRIX * mat4(INV_VIEW_MATRIX[0],INV_VIEW_MATRIX[1],INV_VIEW_MATRIX[2],MODEL_MATRIX[3]);
}

// From timer.gdshader
float remap(float i_min, float i_max, float o_min, float o_max, float val) {
	float t = (val - i_min) / (i_max - i_min);
	return o_min + (o_max - o_min) * t;
}

float mask(vec2 uv, float value)
{
	vec2 u = (uv * 2.0) - 1.0;
	float r = atan(u.x, u.y);
	r = remap(PI, -PI, 0.0, 1.0, r);
	return step(r, value);
}

void fragment() {
	float t = mask(UV, fill);
	vec4 color = texture(tex, UV);
	vec4 fill_color = mix(color, mix_color, mix_amount);
	ALBEDO = mix(color, fill_color, t).rgb;
}