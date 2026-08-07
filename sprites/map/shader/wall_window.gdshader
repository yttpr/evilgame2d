shader_type canvas_item;

global uniform vec2 PlayerLoc;
uniform float max_dist = 55.0;
uniform float num = 0;
void fragment() {
	if (COLOR.a != 0.0) {
		vec2 place = FRAGCOORD.xy;
		if (true){
			float dist = distance(FRAGCOORD.xy, PlayerLoc);
			COLOR.a = clamp(((dist-max_dist)/max_dist * 5.0), 0.1, 1);
		}
	}
}