shader_type canvas_item;

uniform vec4 outline_color = vec4(0.0, 0.0, 0.0, 1.0);
uniform float outline_thickness = 1.0;
const vec2 offsets[4] = vec2[4](
	vec2(-1.0, 0.0),
	vec2(1.0, 0.0),
	vec2(0.0, -1.0),
	vec2(0.0, 1.0)
);

void fragment() {
	vec4 tex = texture(TEXTURE, UV);
	float alpha = tex.a;

	vec2 tex_size = vec2(textureSize(TEXTURE, 0));
	vec2 pixel_size = vec2(1.0) / tex_size * outline_thickness;

	float outline = 0.0;

	for (int i = 0; i < 4; i++) {
		vec2 neighbor_uv = UV + offsets[i] * pixel_size;
		if (neighbor_uv.x < 0.0 || neighbor_uv.x > 1.0 ||
			neighbor_uv.y < 0.0 || neighbor_uv.y > 1.0) {
			if (alpha > 0.0) {
				outline = 1.0;
			}
		} else {
			float neighbor_alpha = texture(TEXTURE, neighbor_uv).a;
			if (neighbor_alpha > 0.0 && alpha < 1.0) {
				outline = 1.0;
			}
		}
	}
	if (outline > 0.0) {
		COLOR = outline_color;
	} else {
		COLOR = tex * COLOR;
	}
}

