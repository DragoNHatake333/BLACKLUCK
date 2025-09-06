shader_type canvas_item;

uniform sampler2D screen_texture : hint_screen_texture, repeat_disable, filter_nearest;
uniform float brightnessMult:hint_range(0.0, 10.0, 0.1) = 4.0;
uniform float wiggleMult:hint_range(0.0, 0.01, 0.0001) = 0.005;
uniform float chromaticAberrationOffset:hint_range(0.0, 0.01, 0.00001) = 0.001;
uniform float warp_amount : hint_range(0.0, 5.0) = 0.1;

// Vignette control parameters
uniform float vignette_amount : hint_range(0.0, 2.0) = 1.0;
uniform float vignette_radius : hint_range(0.0, 1.0) = 0.7;

// Warp function
vec2 warp(vec2 uv) {
    vec2 delta = uv - 0.5;
    float delta2 = dot(delta, delta);
    float delta4 = delta2 * delta2;
    return uv + delta * delta4 * warp_amount;
}

// Vignette function (for smooth fade to black)
float vignette(vec2 uv) {
    uv *= 1.0 - uv;
    float vignette_factor = uv.x * uv.y * vignette_radius * 15.0;
    return pow(vignette_factor, vignette_amount);
}

void fragment() {
    vec2 iResolution = 1.0 / SCREEN_PIXEL_SIZE;
    vec2 uv = FRAGCOORD.xy / iResolution.xy;

    // Warp effect
    uv = warp(uv);

    // Wiggle effect
    float x = sin(0.3 * TIME + uv.y * 21.0) *
              sin(0.7 * TIME + uv.y * 29.0) *
              sin(0.3 + 0.33 * TIME + uv.y * 31.0) * wiggleMult;

    // Distance from center for attenuated chromatic aberration
    float dist = length(uv - 0.5);
    float atten = smoothstep(0.0, 0.7, 0.5 - dist);
    float ca = chromaticAberrationOffset * atten;

    // Clamp UVs to avoid sampling outside
    vec2 uv_r = clamp(vec2(x + uv.x + ca, uv.y + ca), 0.0, 1.0);
    vec2 uv_g = clamp(vec2(x + uv.x, uv.y - ca), 0.0, 1.0);
    vec2 uv_b = clamp(vec2(x + uv.x - ca, uv.y), 0.0, 1.0);

    // Sample with chromatic aberration
    vec3 color;
    color.r = texture(screen_texture, uv_r).r + 0.045;
    color.g = texture(screen_texture, uv_g).g + 0.05;
    color.b = texture(screen_texture, uv_b).b + 0.055;

    // Vignette
    float vig = vignette(uv);
    color *= vig;
    if (vig < 0.001) color = vec3(0.0); // hard cut to black at edges

    // Brightness
    color *= vec3(0.95, 1.05, 0.95);
    color *= brightnessMult;

    // Scanlines
    float scans = clamp(0.35 + 0.35 * sin(3.5 * TIME + uv.y * iResolution.y * 1.5), 0.0, 1.0);
    float s = pow(scans, 1.7);
    color *= vec3(0.4 + 0.7 * s);

    COLOR = vec4(color, 1.0);
}
