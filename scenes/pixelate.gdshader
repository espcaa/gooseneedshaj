shader_type canvas_item;
render_mode unshaded;

// Texture must have 'Filter'-flag enabled!
uniform vec4 modulate : source_color = vec4(1.0, 1.0, 1.0, 1.0); // RGBA

uniform float progress : hint_range(0.0, 1.0) = 0.0;
uniform sampler2D dissolve_noise;
uniform float edge_width : hint_range(0.0, 0.2) = 0.05;
uniform vec4 burn_color : source_color = vec4(1.0, 0.7, 0.2, 1.0);

// Automatic smoothing
// independent of geometry and perspective
vec4 texturePointSmooth(sampler2D smp, vec2 uv, vec2 pixel_size)
{
	vec2 ddx = dFdx(uv);
	vec2 ddy = dFdy(uv);
	vec2 lxy = sqrt(ddx * ddx + ddy * ddy);

	vec2 uv_pixels = uv / pixel_size;

	vec2 uv_pixels_floor = round(uv_pixels) - vec2(0.5f);
	vec2 uv_dxy_pixels = uv_pixels - uv_pixels_floor;

	uv_dxy_pixels = clamp((uv_dxy_pixels - vec2(0.5f)) * pixel_size / lxy + vec2(0.5f), 0.0f, 1.0f);

	uv = uv_pixels_floor * pixel_size;

	return textureGrad(smp, uv + uv_dxy_pixels * pixel_size, ddx, ddy);
}

void fragment()
{
	vec4 tex_color = texturePointSmooth(TEXTURE, UV, TEXTURE_PIXEL_SIZE);
	float noise = texture(dissolve_noise, UV).r;
	float alpha = step(progress, noise);
	float burn_mix = smoothstep(progress, progress - edge_width, noise);
	vec3 final_rgb = mix(tex_color.rgb, burn_color.rgb, burn_mix);
	COLOR = vec4(final_rgb, tex_color.a) * alpha * modulate;
}