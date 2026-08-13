shader_type canvas_item;
render_mode unshaded;

void fragment() {
	float alpha = texture(TEXTURE, UV).a;
	COLOR.r = 10.0 * alpha;
	COLOR.a = alpha;
}