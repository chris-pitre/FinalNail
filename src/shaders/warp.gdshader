// Written in part by Erich_L, MIT and free to use <3
shader_type canvas_item;

// Displacement map (set this manually in editor)
uniform sampler2D flowMap; 

 // Strength of the displacement effect
uniform float strength = 0.3;   

// Direction of displacement flow (set this with GDscript)
uniform vec2 direction = vec2(1.0, 1.0);

// Two colors to interpolate between (noise based)
uniform vec4 color1 : source_color = vec4(0.007843, 1.0, 0.972549, 1.0);
uniform vec4 color2 : source_color = vec4(1.0, 1.0, 1.0, 1.0);


void fragment(){
	vec4 noise_sample = texture(flowMap, vec2(UV.x + (TIME * direction.x * -1.0), UV.y + (TIME * direction.y))); // Sample the noise
	vec4 offset = noise_sample * strength; // Apply strength scalar for a UV offset 
	vec4 texture_check = texture(TEXTURE, vec2(UV.x,UV.y) + offset.xy - vec2(0.5,0.5)*strength); // Sample the texture using the UV offset
	vec4 color = mix(color1, color2, noise_sample.x * 1.3); // Sample the two colors
	COLOR = vec4(color.xyz, texture_check.a); // Define final output, using the alpha of the original image
}