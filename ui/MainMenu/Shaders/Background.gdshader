shader_type canvas_item;

// Versión corregida: animación estable y controlada, sin acumulación infinita.

uniform float spin_rotation_speed : hint_range(0.0, 10.0) = 2.0;
uniform float move_speed : hint_range(0.0, 20.0) = 7.0;
uniform vec2 offset = vec2(2.2, 0.0);
uniform vec4 colour_1 : source_color = vec4(0.9, 0.0, 0.0, 1.0);
uniform vec4 colour_2 : source_color = vec4(0.3, 0.0, 0.0, 1.0);
uniform vec4 colour_3 : source_color = vec4(0.0, 0.0, 0.0, 1.0);
uniform float contrast : hint_range(0.0, 5.0) = 3.5;
uniform float lighting : hint_range(0.0, 2.0) = 0.4;
uniform float spin_amount : hint_range(0.0, 1.0) = 0.25;
uniform float pixel_filter : hint_range(100.0, 2000.0) = 980.0;
uniform bool is_rotating = true;

float noise(vec2 uv) {
	return fract(sin(dot(uv.xy, vec2(12.9898, 78.233))) * 43758.5453);
}

vec4 effect(vec2 screenSize, vec2 screen_coords){
	float pixel_size = length(screenSize) / pixel_filter;
	vec2 uv = (floor(screen_coords / pixel_size) * pixel_size - 0.5 * screenSize) / length(screenSize) - offset;
	float uv_len = length(uv);

	// Tiempo modulado para evitar acumulación infinita
	float time_mod = mod(TIME, 1000.0); // reinicia cada 1000s suavemente

	// Rotación con estabilidad
	float spin_t = is_rotating ? time_mod * (spin_rotation_speed * 0.2) : 302.2;

	float angle = atan(uv.y, uv.x) + spin_t - spin_amount * uv_len;
	vec2 mid = (screenSize / length(screenSize)) / 2.0;
	uv = vec2(uv_len * cos(angle) + mid.x, uv_len * sin(angle) + mid.y) - mid;

	uv *= 24.0;

	// Movimiento fluido y estable
	float speed = time_mod * move_speed;

	vec2 uv2 = uv + vec2(noise(uv * 1.3 + speed), noise(uv.yx * 1.7 - speed));

	for (int i = 0; i < 4; i++) {
		uv2 += sin(uv * 1.1 + speed * 0.1);
		uv += 0.6 * vec2(cos(uv2.y + speed * 0.05), sin(uv2.x - speed * 0.05)); // suavizado
		uv -= 0.7 * cos(uv.x + uv.y) - 0.4 * sin(uv.x - uv.y);
	}

	float contrast_mod = (contrast * 0.25 + 0.5 * spin_amount + 1.0);
	float paint = clamp(length(uv) * 0.035 * contrast_mod, 0.0, 2.0);
	float c1 = max(0.0, 1.0 - contrast_mod * abs(1.0 - paint));
	float c2 = max(0.0, 1.0 - contrast_mod * abs(paint));
	float c3 = 1.0 - min(1.0, c1 + c2);

	vec3 base_col = colour_1.rgb * c1 + colour_2.rgb * c2 + colour_3.rgb * c3;
	base_col += vec3(lighting * max(c2 * 5.0 - 4.0, 0.0));
	return vec4(base_col, 1.0);
}

void fragment() {
	vec2 uv = UV;
	COLOR *= effect(TEXTURE_PIXEL_SIZE, uv);
}
