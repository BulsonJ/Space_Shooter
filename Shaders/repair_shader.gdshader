shader_type canvas_item;

uniform vec4 repair_color: hint_color = vec4(1.0);
uniform float repair_texture_mix: hint_range(0.0, 1.0) = 0.8;
uniform float repair_modifier: hint_range(0.0, 1.0) = 1;

uniform sampler2D noise_texture;
uniform float noise_modifier: hint_range(0.0, 1.0) = 1;

uniform float speed = 0.25;
uniform float noise_speed = 0.5;

uniform vec2 direction = vec2(-1,0);

void fragment(){

	vec2 noise_uv_offset;
	noise_uv_offset.x = TIME * noise_speed;
	noise_uv_offset.y = TIME * noise_speed;
	noise_uv_offset = noise_uv_offset * direction;
	

	vec4 noise = texture(noise_texture, UV + noise_uv_offset);
	vec4 repair_effect = repair_color;
	repair_effect.rgb = mix(repair_effect.rgb, vec3(0,0,0), noise.rgb);
	
	vec4 sprite = texture(TEXTURE, UV);
	sprite.rgb = mix(sprite.rgb, repair_effect.rgb, repair_modifier);
	
	//COLOR = vec4(UV, 0.0, 1.0);
	COLOR = sprite;
}