shader_type canvas_item;

uniform sampler2D screen_texture : hint_screen_texture, filter_linear_mipmap;

uniform float intensity = 0.4;
uniform float alpha : hint_range(0, 1) = 0.5 ;
uniform vec4 vig_color : source_color = vec4(0.0, 0.0, 0.0, 1.0);

uniform sampler2D noiseTexture : repeat_enable;
uniform float speed : hint_range(0.01,1.0) = 0.02; 
uniform float amplitude : hint_range(0.01,1.0) = 0.2; 
uniform float aliasing = 0.01;

float vignette(vec2 uv){
	uv *= 1.0 - uv.xy;
	float vig = uv.x * uv.y * 15.0;
	return pow(vig, intensity * alpha);
}

float circle(vec2 center, float radius, vec2 p){
	return length(p - center) - radius;
}

void fragment() {
	vec4 color = texture(screen_texture, SCREEN_UV);
	vec4 text = texture(TEXTURE, UV);
	
	text *= vig_color;
	text *= vignette(UV);
	
	vec4 noise;
	noise = texture(noiseTexture, UV + speed * (TIME)) - 0.5;
	
	float sdf = -circle(vec2(0.5, 0.5), 0.4, UV) + amplitude * noise.x;
	
	COLOR = vec4((text.rgb) + color.rgb, text.a + sdf);
	
}
