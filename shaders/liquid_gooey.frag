#version 460 core
#include <flutter/runtime_effect.glsl>

uniform vec2 uResolution;
uniform vec4 uBlob0;      // left, top, width, height
uniform vec4 uBlob1;      // left, top, width, height
uniform vec4 uBlob2;      // left, top, width, height
uniform vec4 uBlob3;      // left, top, width, height
uniform float uRadius0;
uniform float uRadius1;
uniform float uRadius2;
uniform float uRadius3;
uniform float uGooStrength;
uniform float uWaviness;
uniform float uTime;
uniform vec4 uFillColor;
uniform vec4 uInnerColor;
uniform float uInnerSpread;

out vec4 fragColor;

vec3 permute(vec3 x) { return mod(((x*34.0)+1.0)*x, 289.0); }

float snoise(vec2 v) {
  const vec4 C = vec4(0.211324865405187, 0.366025403784439,
                     -0.577350269189626, 0.024390243902439);
  vec2 i  = floor(v + dot(v, C.yy));
  vec2 x0 = v - i + dot(i, C.xx);
  vec2 i1 = (x0.x > x0.y) ? vec2(1.0, 0.0) : vec2(0.0, 1.0);
  vec4 x12 = x0.xyxy + C.xxzz;
  x12.xy -= i1;
  i = mod(i, 289.0);
  vec3 p = permute(permute(i.y + vec3(0.0, i1.y, 1.0))
        + i.x + vec3(0.0, i1.x, 1.0));
  vec3 m = max(0.5 - vec3(dot(x0,x0), dot(x12.xy,x12.xy), dot(x12.zw,x12.zw)), 0.0);
  m = m*m;
  m = m*m;
  vec3 x = 2.0 * fract(p * C.www) - 1.0;
  vec3 h = abs(x) - 0.5;
  vec3 ox = floor(x + 0.5);
  vec3 a0 = x - ox;
  m *= 1.79284291400159 - 0.85373472095314 * (a0*a0 + h*h);
  vec3 g;
  g.x  = a0.x  * x0.x  + h.x  * x0.y;
  g.yz = a0.yz * x12.xz + h.yz * x12.yw;
  return 130.0 * dot(m, g);
}

float sdRoundedBox(vec2 p, vec2 b, float r) {
    r = min(r, min(b.x, b.y));
    vec2 q = abs(p) - b + r;
    return min(max(q.x, q.y), 0.0) + length(max(q, 0.0)) - r;
}

float calcBlobDist(vec2 p, vec4 blob, float radius) {
    if (blob.x < -5000.0 || blob.z <= 0.0 || blob.w <= 0.0) return 1e5;
    vec2 c = blob.xy + blob.zw * 0.5;
    return sdRoundedBox(p - c, blob.zw * 0.5, radius);
}

float smin(float a, float b, float k) {
    if (k <= 0.001) return min(a, b);
    float h = clamp(0.5 + 0.5 * (b - a) / k, 0.0, 1.0);
    return mix(b, a, h) - k * h * (1.0 - h);
}

void main() {
    vec2 uv = FlutterFragCoord().xy;

    float d0 = calcBlobDist(uv, uBlob0, uRadius0);
    float d1 = calcBlobDist(uv, uBlob1, uRadius1);
    float d2 = calcBlobDist(uv, uBlob2, uRadius2);
    float d3 = calcBlobDist(uv, uBlob3, uRadius3);

    // Chained polynomial smooth-min ensures all shapes blend organically
    float dist = d0;
    if (uBlob1.x > -5000.0 && uBlob1.z > 0.0) dist = smin(dist, d1, uGooStrength);
    if (uBlob2.x > -5000.0 && uBlob2.z > 0.0) dist = smin(dist, d2, uGooStrength);
    if (uBlob3.x > -5000.0 && uBlob3.z > 0.0) dist = smin(dist, d3, uGooStrength);

    if (uWaviness > 0.0) {
        float noise = snoise(uv * 0.015 + vec2(uTime * 0.5, uTime * 0.3));
        dist += noise * uWaviness;
    }

    // Razor-sharp sub-pixel anti-aliased Impeller edge
    float alpha = 1.0 - smoothstep(-0.7, 0.7, dist);

    if (alpha <= 0.001) {
        fragColor = vec4(0.0);
        return;
    }

    vec4 color = uFillColor * alpha;

    if (uInnerSpread > 0.0 && uInnerColor.a > 0.0) {
        float innerDist = abs(dist);
        float innerMask = 1.0 - smoothstep(0.0, uInnerSpread, innerDist);
        color = mix(color, uInnerColor, innerMask * uInnerColor.a * alpha);
    }

    fragColor = color;
}
