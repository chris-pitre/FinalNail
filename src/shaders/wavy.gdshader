shader_type canvas_item;

uniform float height = 3.0;
uniform float frequency = 3.0;
uniform float speed = 2.0;

void vertex(){
	VERTEX.y += height * sin((frequency * UV.x) + (speed * TIME));
}