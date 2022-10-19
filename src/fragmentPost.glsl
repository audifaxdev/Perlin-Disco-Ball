uniform sampler2D uMap;
varying vec2 vUv;
varying vec3 myPosition;

//Y = (X-A)/(B-A) * (D-C) + C
vec2 mapVectorRange(vec2 x, vec2 a, vec2 b, vec2 c, vec2 d) {
    return (x - a) / (b - a) * (d - c) + c;
}

float PI = 3.1415592653589793238;
float rand(vec2 n) {
    return fract(sin(dot(n, vec2(12.9898, 4.1414))) * 43758.5453);
}
vec4 blend(vec4 source, vec4 dest) {
    return 1. - (1. - source) * (1. - dest);
}
void main() {

//    vec2 origin = vec2(0.5, 0.5);
//    vec2 origin =  vec2(.9);
    vec2 origin =  mapVectorRange(myPosition.xy, vec2(-1., -1.), vec2(1., 1.), vec2(0.,0.), vec2(1., 1.)) ;

    vec2 toCenter = origin - vUv;

    vec4 original = vec4(0.);
//    vec4 original = texture2D(uMap, vUv);

    //good looking disco ball is max 100 with 1.39 scalar lerp
    float max = 60.;
    vec4 color = vec4(0.);
    for(float i=0.;i<max;i++) {
        float lerp = (i + rand(vec2(gl_FragCoord.xy))) / max;
//        float lerp = 1.4 * (i + rand(vec2(gl_FragCoord.xy))) / max;
        float weight = sin(lerp * PI);

        vec2 sampleCoord = vUv + toCenter*lerp * 1.4;
//        vec2 sampleCoord = clamp(vUv + toCenter*lerp * 10., vec2(0., 0.), vec2(1., 1.));
        vec4 mySample = texture2D(uMap, sampleCoord);
        mySample.rgb /= 20.;
        color += mySample * weight;
    }

//    gl_FragColor = color;
    gl_FragColor = blend(color, original);
//    gl_FragColor = vec4(origin, 0., 1.);
}