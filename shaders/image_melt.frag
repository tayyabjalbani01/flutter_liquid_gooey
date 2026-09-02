#version 460 core
#include <flutter/runtime_effect.glsl>

uniform vec2 uResolution;
uniform vec2 uContactPoint;
uniform float uWarpStrength;
uniform float uMixStrength;
uniform float uTime;
uniform sampler2D uImageTexture;

out vec4 fragColor;

float hash(vec2 p) {
    p = fract(p * vec2(123.34, 456.21));
    p += dot(p, p + 45.32);
    return fract(p.x * p.y);
}

float noise(vec2 p) {
    vec2 i = floor(p);
    vec2 f = fract(p);
    f = f * f * (3.0 - 2.0 * f);
    float a = hash(i);
    float b = hash(i + vec2(1.0, 0.0));
    float c = hash(i + vec2(0.0, 1.0));
    float d = hash(i + vec2(1.0, 1.0));
    return mix(mix(a, b, f.x), mix(c, d, f.x), f.y);
}

void main() {
    vec2 uv = FlutterFragCoord().xy / uResolution;
    vec2 pixelCoord = FlutterFragCoord().xy;

    float distToContact = length(pixelCoord - uContactPoint);
    float falloff = exp(-distToContact * 0.05);

    // Anisotropic flow displacement along contact
    vec2 flowDir = normalize(pixelCoord - uContactPoint + vec2(1e-4));
    float n = noise(uv * 18.0 + vec2(uTime * 0.4));
    vec2 warpedUV = uv + flowDir * (n - 0.5) * (uWarpStrength * 0.001) * falloff;

    vec4 texColor = texture(uImageTexture, warpedUV);

    // Alpha erosion tendrils
    float tendrilAlpha = smoothstep(0.3, 0.7, n * uMixStrength + (1.0 - falloff));
    fragColor = texColor * tendrilAlpha;
}
