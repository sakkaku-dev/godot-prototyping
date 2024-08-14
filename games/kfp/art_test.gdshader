shader_type canvas_item;

uniform vec4 color1: source_color = vec4(1.);
uniform vec4 color2: source_color = vec4(1.);
uniform vec4 color3: source_color = vec4(1.);
uniform vec4 color4: source_color = vec4(1.);
uniform vec4 color5: source_color = vec4(1.);
uniform vec4 color6: source_color = vec4(1.);
uniform vec4 color7: source_color = vec4(1.);
uniform vec4 color8: source_color = vec4(1.);
uniform vec4 color9: source_color = vec4(1.);

uniform vec4 alt_color1: source_color = vec4(1.);
uniform vec4 alt_color2: source_color = vec4(1.);
uniform vec4 alt_color3: source_color = vec4(1.);
uniform vec4 alt_color4: source_color = vec4(1.);
uniform vec4 alt_color5: source_color = vec4(1.);
uniform vec4 alt_color6: source_color = vec4(1.);
uniform vec4 alt_color7: source_color = vec4(1.);
uniform vec4 alt_color8: source_color = vec4(1.);
uniform vec4 alt_color9: source_color = vec4(1.);

void fragment() {
	if (COLOR == color1) {
		COLOR = alt_color1;
	} else if (COLOR == color2) {
		COLOR = alt_color2;
	} else if (COLOR == color3) {
		COLOR = alt_color3;
	} else if (COLOR == color4) {
		COLOR = alt_color4;
	} else if (COLOR == color5) {
		COLOR = alt_color5;
	} else if (COLOR == color6) {
		COLOR = alt_color6;
	} else if (COLOR == color7) {
		COLOR = alt_color7;
	} else if (COLOR == color8) {
		COLOR = alt_color8;
	} else if (COLOR == color9) {
		COLOR = alt_color9;
	}
}
