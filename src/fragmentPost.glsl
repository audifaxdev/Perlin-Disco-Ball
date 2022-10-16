uniform sampler2D uMap;
varying vec2 vUv;
float PI = 3.1415592653589793238;
float rand(vec2 n) {
    return fract(sin(dot(n, vec2(12.9898, 4.1414))) * 43758.5453);
}
void main() {

    vec2 toCenter = vec2(.5) - vUv;

    vec4 original = texture2D(uMap, vUv);

    //good looking disco ball is max 100 with 1.39 scalar lerp
    float max = 100.;
    vec4 color = vec4(0.);
    for(float i=0.;i<max;i++) {
        float lerp = 1.4 * (i + rand(vec2(gl_FragCoord.xy))) / max;
        float weight = sin(lerp * PI);
        vec4 mySample = texture2D(uMap, vUv + toCenter*lerp);
        mySample.rgb /= 20.;
        color += mySample * weight;
    }

//    gl_FragColor = color;
    gl_FragColor = 1. - (1. - color) * (1. - original);
//    gl_FragColor = original;
}