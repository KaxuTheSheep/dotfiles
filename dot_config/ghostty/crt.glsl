#define SCANLINE_INTENSITY 0.08
#define SCANLINE_COUNT 2400.0
#define CURVATURE 0.05

vec2 curve(vec2 uv) {
    uv = uv * 2.0 - 1.0;
    vec2 offset = abs(uv.yx) / vec2(6.0, 4.0);
    uv = uv + uv * offset * offset * CURVATURE;
    uv = uv * 0.5 + 0.5;
    return uv;
}

void mainImage(out vec4 fragColor, in vec2 fragCoord) {
    vec2 uv = fragCoord / iResolution.xy;
    vec2 curvedUV = curve(uv);

    // Black border outside curved screen
    if (curvedUV.x < 0.0 || curvedUV.x > 1.0 || curvedUV.y < 0.0 || curvedUV.y > 1.0) {
        fragColor = vec4(0.0, 0.0, 0.0, 1.0);
        return;
    }

    // Sample terminal content
    vec3 color = texture(iChannel0, curvedUV).rgb;

    // Scanlines
    float scanline = pow(sin(curvedUV.y * SCANLINE_COUNT) * 0.5 + 0.5, 0.4) * (1.0 - SCANLINE_INTENSITY) + SCANLINE_INTENSITY;
    color *= scanline;

    fragColor = vec4(color, 1.0);
}
