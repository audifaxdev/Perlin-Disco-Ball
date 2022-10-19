uniform float time;
uniform vec3 oPosition;

varying vec2 vUv;
varying vec3 myPosition;

void main() {
    vUv = uv;
    myPosition = oPosition;
    gl_Position = projectionMatrix * modelViewMatrix * vec4(position, 1.0);
}