shader_type canvas_item;

uniform float radius : hint_range(0.0, 1.0) = 1.0;

void fragment() {
    COLOR.a = 1. - step(radius/2.0, distance(UV, vec2(0.5,0.5)));
}