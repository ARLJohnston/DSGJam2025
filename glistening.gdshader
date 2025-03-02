shader_type canvas_item;


void fragment() {
    vec2 uv = UV;
    
    // Get the sprite's original color (including transparency)
    vec4 tex_color = texture(TEXTURE, uv) * COLOR; // Uses sprite's modulated color
    
    // Only apply the shine effect if the pixel is not fully transparent
    if (tex_color.a > 0.1) { // Avoid affecting transparent areas
        float shine = sin(TIME * 3.0 + uv.x * 10.0) * 0.5 + 0.5;

        // Create a white shine overlay
        vec4 shine_color = vec4(1.0, 1.0, 1.0, shine * 0.5); 
        
        // Blend the shine with the sprite’s existing color
        tex_color = mix(tex_color, shine_color, shine * 0.4);
    }

    COLOR = tex_color; // Output final color
}
