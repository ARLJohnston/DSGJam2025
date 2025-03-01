shader_type canvas_item;

void fragment() {
    vec2 uv = UV;
    
    // Create a shimmer effect that moves over time
    float shine = sin(TIME * 3.0 + uv.x * 10.0) * 0.5 + 0.5;

    // Get the sprite's current modulated color
    vec4 tex_color = texture(TEXTURE, uv) * COLOR; // Applies modulate color

    // Create a white shine overlay
    vec4 shine_color = vec4(1.0, 1.0, 1.0, shine * 0.5); 
    
    // Blend the shine with the sprite’s modulated color
    COLOR = mix(tex_color, shine_color, shine * 0.4);
}
