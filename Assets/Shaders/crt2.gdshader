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


///OTHER CODE
shader_type canvas_item;
uniform sampler2D screen_texture : hint_screen_texture, repeat_disable, filter_nearest;
uniform float brightnessMult:hint_range(0.0, 10.0, 0.1)=4.0;
uniform float wiggleMult:hint_range(0.0, 0.01, 0.0001)=0.005;
uniform float chromaticAberrationOffset:hint_range(0.0, 0.01, 0.00001)=0.001;

void fragment( ){
//	set up
	vec2 iResolution = 1.0 / SCREEN_PIXEL_SIZE;
    vec2 uv = FRAGCOORD.xy / iResolution.xy;
    vec3 color;
//	wiggle
	float x=  sin(0.3*TIME+uv.y*21.0)*sin(0.7*TIME+uv.y*29.0)*sin(0.3+0.33*TIME+uv.y*31.0)*wiggleMult;
//draw the actual game lol
	//the color adjustments is a simpler chromatic aberration
    color.r = texture(screen_texture,vec2(x+uv.x+chromaticAberrationOffset,uv.y+chromaticAberrationOffset)).x+0.045;
    color.g = texture(screen_texture,vec2(x+uv.x,uv.y-chromaticAberrationOffset)).y+0.05;
    color.b = texture(screen_texture,vec2(x+uv.x-chromaticAberrationOffset,uv.y)).z+0.055;

	//simple vignette
    float vignette = (0.0 + 1.0*16.0*uv.x*uv.y*(1.0-uv.x)*(1.0-uv.y));
	color *= vec3(pow(vignette,0.3));

	//adjust brightness
    color *= vec3(0.95,1.05,0.95);
	color *= brightnessMult;

	//add scanlines
	float scans = clamp( 0.35+0.35*sin(3.5*TIME+uv.y*iResolution.y*1.5), 0.0, 1.0);
	float s = pow(scans,1.7);
	color = color*vec3( 0.4+0.7*s) ;

    COLOR = vec4(color,1.0);
}
