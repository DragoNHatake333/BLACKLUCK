shader_type canvas_item;

uniform sampler2D screen_texture : hint_screen_texture, repeat_disable, filter_nearest;
uniform float brightnessMult:hint_range(0.0, 10.0, 0.1)=4.0;
uniform float wiggleMult:hint_range(0.0, 0.01, 0.0001)=0.005;
uniform float chromaticAberrationOffset:hint_range(0.0, 0.01, 0.00001)=0.001;
uniform float warp_amount : hint_range(0.0, 5.0) = 0.1;  // Add warp amount parameter

// Vignette control parameters
uniform float vignette_amount : hint_range(0.0, 2.0) = 1.0;  // Vignette strength
uniform float vignette_radius : hint_range(0.0, 1.0) = 0.7;  // Vignette radius (how wide it is)

// Warp function (from second shader)
vec2 warp(vec2 uv) {
    vec2 delta = uv - 0.5;
    float delta2 = dot(delta, delta);
    float delta4 = delta2 * delta2;
    return uv + delta * delta4 * warp_amount;
}

// Vignette function with adjustable strength and radius
float vignette(vec2 uv) {
    uv *= 1.0 - uv;  // Adjust for the corners (vignette shape)
    float vignette_factor = uv.x * uv.y * vignette_radius * 15.0;
    return pow(vignette_factor, vignette_amount);
}

void fragment() {
    // Set up
    vec2 iResolution = 1.0 / SCREEN_PIXEL_SIZE;
    vec2 uv = FRAGCOORD.xy / iResolution.xy;
    vec3 color;

    // Apply warp effect
    uv = warp(uv); // Apply the warp to the UV coordinates

    // Wiggle effect
    float x = sin(0.3 * TIME + uv.y * 21.0) * sin(0.7 * TIME + uv.y * 29.0) * sin(0.3 + 0.33 * TIME + uv.y * 31.0) * wiggleMult;

    // Chromatic Aberration effect
    color.r = texture(screen_texture, vec2(x + uv.x + chromaticAberrationOffset, uv.y + chromaticAberrationOffset)).x + 0.045;
    color.g = texture(screen_texture, vec2(x + uv.x, uv.y - chromaticAberrationOffset)).y + 0.05;
    color.b = texture(screen_texture, vec2(x + uv.x - chromaticAberrationOffset, uv.y)).z + 0.055;

    // Apply vignette
    color *= vec3(vignette(uv));

    // Adjust brightness
    color *= vec3(0.95, 1.05, 0.95);
    color *= brightnessMult;

    // Add scanlines
    float scans = clamp(0.35 + 0.35 * sin(3.5 * TIME + uv.y * iResolution.y * 1.5), 0.0, 1.0);
    float s = pow(scans, 1.7);
    color = color * vec3(0.4 + 0.7 * s);

    // Set final color output
    COLOR = vec4(color, 1.0);
}
