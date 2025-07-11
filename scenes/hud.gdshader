shader_type canvas_item;

uniform sampler2D SCREEN_TEXTURE : hint_screen_texture, filter_linear_mipmap;
uniform float multi : hint_range(-2.0, 3.0) = 1.0;

void fragment() {
    vec4 screen_color = texture(SCREEN_TEXTURE, SCREEN_UV);
    COLOR = vec4(screen_color.r*multi, screen_color.g*multi, screen_color.b*multi,screen_color.a);
}