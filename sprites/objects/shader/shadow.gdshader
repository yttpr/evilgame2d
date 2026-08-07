shader_type canvas_item;

uniform sampler2D SCREEN_TEXTURE : hint_screen_texture;
uniform vec4 on_light_color : source_color;

void light() {
	vec4 test = texture(SCREEN_TEXTURE, SCREEN_UV);
	LIGHT.a = LIGHT_COLOR.a;
	LIGHT.rgb = -COLOR.rgb + test.rgb;
}
