shader_type canvas_item;

uniform float offset = 0.0;
uniform float size = 0.2;

void fragment() {
	COLOR.a = step(offset + UV.y, size);
}
