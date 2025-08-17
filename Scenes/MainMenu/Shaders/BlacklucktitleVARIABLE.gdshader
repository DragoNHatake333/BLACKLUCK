shader_type canvas_item;

// Keep uniforms that control the effect.
uniform float noise_scale = 80.0;
uniform float darkness = 0.4;
uniform float glitch_strength = 0.01;
uniform float time_slowdown = 2.5;
uniform float glitch_start_time = 1.0;
uniform float glitch_ramp_duration = 2.0;

// Optional extra tint (neutral by default). The :source_color hint keeps colors correct in HDR/linear pipelines.
uniform vec4 tint : source_color = vec4(1.0);

float rand(vec2 co) {
    return fract(sin(dot(co.xy, vec2(12.9898, 78.233))) * 43758.5453);
}

void fragment() {
    float slow_time = TIME / max(time_slowdown, 0.0001);

    // Progressive glitch ramp.
    float glitch_t = clamp((TIME - glitch_start_time) / max(glitch_ramp_duration, 0.0001), 0.0, 1.0);
    float glitch_factor = smoothstep(0.0, 1.0, glitch_t);
    float active_glitch_strength = glitch_strength * glitch_factor;

    // Horizontal glitch offset.
    vec2 offset = vec2(0.0);
    float line_noise = fract(sin(UV.y * 60.0 + slow_time * 0.5) * 43758.5453);
    if (line_noise < 0.25) {
        offset.x += sin(UV.y * 15.0 + slow_time) * active_glitch_strength;
    }

    // Sample glyph; we only need its alpha for text shapes.
    vec4 glyph = texture(TEXTURE, UV + offset);

    // Black noise mask.
    vec2 noise_uv = FRAGCOORD.xy / max(noise_scale, 0.0001);
    float n = rand(noise_uv + vec2(slow_time * 0.9, slow_time * 0.6));
    float darkness_mask = 1.0 - (n * darkness);

    // IMPORTANT: Use incoming COLOR (Label theme/LabelSettings color) and multiply by optional tint.
    vec3 base_rgb = COLOR.rgb * tint.rgb;
    float base_a = COLOR.a * tint.a;

    COLOR = vec4(base_rgb * darkness_mask, glyph.a * base_a);
}
