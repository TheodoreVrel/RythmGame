shader_type canvas_item;

uniform vec3 color: source_color = vec3(0,0,0);
uniform float progress: hint_range(0.0, 1.0, 0.1) = 0;

void fragment() {
	float original_alpha_value = texture(TEXTURE, UV).a;
	vec4 target_color = mix(texture(TEXTURE, UV), vec4(color, original_alpha_value), progress);
	
	COLOR = target_color;
}
