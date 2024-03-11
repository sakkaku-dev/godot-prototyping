 shader_type canvas_item;

 uniform float inner_size = 0.2;

 void fragment() {
 	vec2 coord = UV - vec2(0.5);
	float x = step(inner_size, abs(coord.x));
	float y = step(inner_size, abs(coord.y));
	COLOR.a = max(x, y);
 }