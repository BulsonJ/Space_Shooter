shader_type canvas_item;

uniform vec2 tiled_factor = vec2(1.0,1.0);
uniform float aspect_ratio = 0.25;

uniform sampler2D repair_texture;
uniform vec4 repair_color: hint_color = vec4(1.0);
uniform float repair_texture_mix: hint_range(0.0, 1.0) = 0.8;
uniform float repair_modifier: hint_range(0.0, 1.0) = 1;

uniform sampler2D noise_texture;
uniform float noise_modifier: hint_range(0.0, 1.0) = 1;

uniform float speed = 0.25;
uniform float noise_speed = 0.5;

void fragment(){
	vec2 tiled_uvs = UV * tiled_factor;
	tiled_uvs.y *= aspect_ratio;
	
	vec2 effect_uv_offset;
	effect_uv_offset.y = TIME * speed;
	effect_uv_offset = effect_uv_offset * vec2(0,1);
	
	vec2 noise_uv_offset;
	noise_uv_offset.y = TIME * noise_speed;
	noise_uv_offset = noise_uv_offset * vec2(0,1);
	
	vec4 repair_effect = texture(repair_texture, tiled_uvs + effect_uv_offset);
	repair_effect.rgb = mix(repair_effect.rgb, repair_color.rgb, repair_texture_mix);
	
	vec4 noise = texture(noise_texture, UV + noise_uv_offset);
	//repair_effect.rgb = mix(repair_effect.rgb, noise.rgb, noise_modifier);
	repair_effect.rgb = mix(repair_effect.rgb, vec3(0,0,0), noise.rgb);
	
	vec4 sprite = texture(TEXTURE, UV);
	sprite.rgb = mix(sprite.rgb, repair_effect.rgb, repair_modifier);
	
	//COLOR = vec4(UV, 0.0, 1.0);
	COLOR = sprite;
}