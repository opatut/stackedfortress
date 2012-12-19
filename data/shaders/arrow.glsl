extern number time;

vec4 effect(vec4 color, Image texture, vec2 texture_coords, vec2 pixel_coords) {
    float a = 0.05;
    float x = (clamp(sin((texture_coords.y + texture_coords.x) * 0.8 - time * 3), 1 - a, 1) - 1 + a) / a;
    vec4 c = texture2D(texture, texture_coords) * color;
    return vec4(mix(c.rgb, vec3(1, 1, 1), x * 0.5), mix(c.a, 1, x * 0.5) * texture2D(texture, texture_coords).a);
}
