shader_type canvas_item;

uniform sampler2D SCREEN_TEXTURE : hint_screen_texture;
uniform vec2 resolution = vec2(320.0, 180.0); // Emulated resolution

uniform float warp_amount : hint_range(0.0, 5.0) = 0.1;
uniform float noise_amount : hint_range(0.0, 0.3) = 0.03;
uniform float vignette_amount : hint_range(0.0, 2.0) = 0.6;
uniform float vignette_intensity : hint_range(0.0, 1.0) = 0.4;
uniform float aberration_amount : hint_range(0.0, 1.0) = 0.5;

float random(vec2 uv) {
    return fract(sin(dot(uv ,vec2(12.9898,78.233))) * 43758.5453);
}

vec2 warp(vec2 uv) {
    vec2 delta = uv - 0.5;
    float delta2 = dot(delta, delta);
    float delta4 = delta2 * delta2;
    return uv + delta * delta4 * warp_amount;
}

float vignette(vec2 uv) {
    uv *= 1.0 - uv;
    float v = uv.x * uv.y * 15.0;
    return pow(v, vignette_intensity * vignette_amount);
}

void fragment() {
    vec2 uv = SCREEN_UV;

    // Apply warp
    uv = warp(uv);

    // Get chromatic offsets
    vec2 chroma_x = vec2(aberration_amount, 0.0) / resolution;
    vec2 chroma_y = vec2(0.0, aberration_amount * 0.5) / resolution;

    // Fetch RGB with slight offset
    float r = texture(SCREEN_TEXTURE, uv - chroma_x).r;
    float g = texture(SCREEN_TEXTURE, uv + chroma_y).g;
    float b = texture(SCREEN_TEXTURE, uv + chroma_x).b;
    vec3 color = vec3(r, g, b);

    // Add noise
    float n = random(uv + fract(TIME)) * noise_amount;
    color += n;

    // Apply vignette
    color *= vignette(uv);

    COLOR = vec4(color, 1.0);
}
