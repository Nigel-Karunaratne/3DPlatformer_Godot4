shader_type spatial;

uniform vec4 out_color : source_color = vec4(0,0.35,1,1);
uniform float metallic = 0.6;
uniform float specular = 0.5;
uniform float roughness = 0.2;

uniform float offsetAmount : hint_range(0.2, 1.7) = 0.8;

float generateOffset(float x, float z, float v1, float v2, float time) {
	float speed = 1.0;
	
	float radX = ((mod(x+z * x+v1, offsetAmount) / offsetAmount) + (time * speed) * mod(x * 0.8 + z, 1.5)) * 2.0 * 3.1415;
	float radZ = ((mod(v2 * 2.0 * (x*z), offsetAmount) / offsetAmount) + (time * speed) * 2.0 * mod(x,2.0))  * 2.0 * 3.1415;
	
	return offsetAmount * 0.5 * (sin(radZ) + cos(radX));
}

vec3 applyDistortion(vec3 vert, float time) {
	float xd = generateOffset(vert.x, vert.z, 0.2, 0.1, time);
	float yd = generateOffset(vert.x, vert.z, 0.1, 0.3, time);
	float zd = generateOffset(vert.x, vert.z, 0.15, 0.2, time);
	return vert + vec3(0.0, yd, 0.0);
}

void vertex() {
	VERTEX = applyDistortion(VERTEX, TIME * 0.1);
}

void fragment() {
	NORMAL = normalize(cross(dFdx(VERTEX), dFdy(VERTEX)));
	
	METALLIC = metallic;
	SPECULAR = specular;
	ROUGHNESS = roughness;
	
	ALBEDO = out_color.xyz;
}
