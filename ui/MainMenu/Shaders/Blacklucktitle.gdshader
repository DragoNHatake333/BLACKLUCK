shader_type canvas_item;

uniform vec4 font_color : source_color = vec4(0.46, 0.05, 0.05, 1.0);
uniform float noise_scale = 80.0;
uniform float darkness = 0.4;
uniform float glitch_strength = 0.01;
uniform float time_slowdown = 2.5;
uniform float glitch_start_time = 1.0;
uniform float glitch_ramp_duration = 2.0; // cuánto tarda en llegar a su fuerza máxima

float rand(vec2 co) {
    return fract(sin(dot(co.xy, vec2(12.9898, 78.233))) * 43758.5453);
}

void fragment() {
    float slow_time = TIME / time_slowdown;

    // === Glitch fuerza progresiva ===
    float glitch_t = clamp((TIME - glitch_start_time) / glitch_ramp_duration, 0.0, 1.0);
    float glitch_factor = smoothstep(0.0, 1.0, glitch_t);
    float active_glitch_strength = glitch_strength * glitch_factor;

    // === Glitch horizontal ===
    vec2 offset = vec2(0.0);
    float line_noise = fract(sin(UV.y * 60.0 + slow_time * 0.5) * 43758.5453);
    if (line_noise < 0.25) {
        offset.x += sin(UV.y * 15.0 + slow_time) * active_glitch_strength;
    }

    vec4 tex_color = texture(TEXTURE, UV + offset);

    // === Ruido negro ===
    vec2 noise_uv = FRAGCOORD.xy / noise_scale;
    float noise = rand(noise_uv + vec2(slow_time * 0.9, slow_time * 0.6));
    float darkness_mask = 1.0 - (noise * darkness);

    vec3 final_color = tex_color.rgb * font_color.rgb * darkness_mask;

    COLOR = vec4(final_color * tex_color.a, tex_color.a);
}