shader_type canvas_item;

uniform bool enabled = false;
uniform vec4 color : source_color = vec4(1.);

void fragment() {
	COLOR.rgb = mix(
		mix(color.rgb, COLOR.rgb, 1.0 - color.a),
		COLOR.rgb,
		float(!enabled)
		);
}
