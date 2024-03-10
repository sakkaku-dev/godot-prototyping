shader_type canvas_item;

varying flat vec2 vertexPos[2];
uniform vec4 highlight_color: source_color = vec4(1.0);
uniform vec2 highlight_coords[1];
uniform vec2 tile_size;

void vertex() {
	vertexPos[0] = (MODEL_MATRIX * vec4(VERTEX, 0.0, 1.0)).xy;
}

float is_within() {
	for (int i = 0; i < highlight_coords.length(); i++) {
		vec2 coord = highlight_coords[i];
		float isWithinY = step(vertexPos[0].y, coord.y) * step(coord.y, vertexPos[0].y + tile_size.y);
		float isWithinX = step(vertexPos[0].x, coord.x) * step(coord.x, vertexPos[0].x + tile_size.x);
		float isWithIn = isWithinY * isWithinX;
		if (isWithIn > 0.) {
			return isWithIn;
		}
	}
	
	return 0.0;
}

void fragment() {
	vec4 tex = texture(TEXTURE, UV);
	COLOR = mix(tex, highlight_color, 1.0 * is_within());
	
	
	//vec2 coord = highlight_coords;
	//float isWithinY = step(vertexPos[0].y, coord.y) * step(coord.y, vertexPos[0].y + tile_size.y);
	//float isWithinX = step(vertexPos[0].x, coord.x) * step(coord.x, vertexPos[0].x + tile_size.x);
	//float isWithIn = isWithinY * isWithinX;
	//
	//vec4 tex = texture(TEXTURE, UV);
	//COLOR = mix(tex, highlight_color, 1.0 * isWithIn);
	
}

//void light() {
	// Called for every pixel for every light affecting the CanvasItem.
	// Uncomment to replace the default light processing function with this one.
//}
