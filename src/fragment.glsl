uniform float time;
varying vec2 vUv;
#define M_PI 3.14159265358979323846

float rand(vec2 co){return fract(sin(dot(co.xy ,vec2(12.9898,78.233))) * 43758.5453);}
float rand (vec2 co, float l) {return rand(vec2(rand(co), l));}
float rand (vec2 co, float l, float t) {return rand(vec2(rand(co, l), t));}

float perlin(vec2 p, float dim, float time) {
    vec2 pos = floor(p * dim);
    vec2 posx = pos + vec2(1.0, 0.0);
    vec2 posy = pos + vec2(0.0, 1.0);
    vec2 posxy = pos + vec2(1.0);

    float c = rand(pos, dim, time);
    float cx = rand(posx, dim, time);
    float cy = rand(posy, dim, time);
    float cxy = rand(posxy, dim, time);

    vec2 d = fract(p * dim);
    d = -0.5 * cos(d * M_PI) + 0.5;

    float ccx = mix(c, cx, d.x);
    float cycxy = mix(cy, cxy, d.x);
    float center = mix(ccx, cycxy, d.y);

    return center * 2.0 - 1.0;
}

void main() {
    float dims = 200.;
    float myTime = 0.00000000000001 * time;

//    vec3 sunColor = vec3(myNoise, myNoise, myNoise);

//    float myNoise = max(.5, perlin(vUv, dims, myTime));
    float myNoise = perlin(vUv, dims, myTime);
    float myNoise2 = perlin(vUv-vec2(1.), dims, myTime);
    float myNoise3 = perlin(vUv-vec2(2.), dims, myTime);

//    vec3 sunColor = vec3(0.9568 * myNoise, 0.9137 * myNoise, 0.6078 * myNoise);
//    gl_FragColor = vec4(sunColor, 1.0);
    gl_FragColor = vec4(vec3(myNoise, myNoise2, myNoise3), 1.0);
}