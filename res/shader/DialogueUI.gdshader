shader_type canvas_item;

uniform float transparent_ratio = 0.1;

uniform vec4 modulate_color :source_color;
uniform float modulate_ratio =.5;

void fragment() {
	
	vec4 tex = texture(TEXTURE, UV);
	
	if(UV.y < transparent_ratio){
		float val = smoothstep(0.0, 1.0, (UV.y / transparent_ratio));
		
		tex.a = val;
		
	}
	
	vec4 final = mix(tex, modulate_color, modulate_ratio);
	
	final.a = tex.a;	
	COLOR = final;
}
