shader_type canvas_item;

uniform sampler2D noiseTexture: hint_default_white, repeat_enable;
uniform float speed: hint_range(0.0, 1.0) = 0.1;

void vertex(){
	VERTEX.y += 4.0 * sin((0.2 * UV.x) + (TIME));
	VERTEX.x += 4.0 * cos((0.4 * UV.x) + (TIME));
}

void fragment(){
	vec4 noise;
	noise = texture(noiseTexture, UV + speed * (TIME)) - 0.5;
	
	COLOR.a = smoothstep(COLOR.a, noise.y, 0.0);
}


