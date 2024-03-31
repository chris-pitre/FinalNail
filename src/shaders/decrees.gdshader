shader_type canvas_item;

void vertex() {
	vec2 pivot =  0.5 / TEXTURE_PIXEL_SIZE;
	VERTEX -= pivot;
	
	vec3 layer1 = vec3(cos(TIME), -sin(TIME), pivot.x);
	vec3 layer2 = vec3(sin(TIME),  cos(TIME), pivot.y);
	vec3 layer3 = vec3(0.0, 0.0, 1.0);
	mat3 rotation_matrix = mat3(layer1, layer2, layer3);
	
	vec3 vertex_vec3 = vec3(VERTEX, 0.0);
	vec3 new_vertex_vec3 = vertex_vec3 * rotation_matrix;
	VERTEX = new_vertex_vec3.xy;
	VERTEX += pivot;
}


