shader_type canvas_item;

uniform sampler2D SCREEN_TEXTURE : hint_screen_texture;
uniform vec4 on_light_color : source_color;

void light() {
	vec4 test = texture(SCREEN_TEXTURE, SCREEN_UV);
	LIGHT.a = min(LIGHT_COLOR.a * 1.5, 1.0);
	LIGHT.rgb = -COLOR.rgb + test.rgb;
}

global uniform vec2 PlayerLoc;
uniform float max_dist = 55.0;
uniform float num = 0;

void fragment() {
	if (COLOR.a != 0.0) {
		vec2 place = FRAGCOORD.xy;
		if (true){
			float dist = distance(FRAGCOORD.xy, PlayerLoc);
			COLOR.a = clamp(((dist-max_dist)/max_dist), 0.0, COLOR.a);
		}
	}
}