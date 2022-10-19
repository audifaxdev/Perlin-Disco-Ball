import * as THREE from "three";
import vertexShader from './vertex.glsl';
import fragmentShader from './fragment.glsl';
import fragmentPost from './fragmentPost.glsl';
import vertexPost from './vertexPost.glsl';
import {OrbitControls} from './OrbitControls';
import Stats from 'stats.js';

function screenXY(obj, camera){

  var vector = obj.clone();
  // console.log({before: JSON.stringify(vector)})

  vector.project(camera);
  // console.log({after: JSON.stringify(vector)})



  return vector;

};

class App {
  constructor () {
    this.stats = new Stats()
    this.stats.showPanel(0) // 0: fps, 1: ms, 2: mb, 3+: custom
    document.body.appendChild(this.stats.dom);

    console.log({'pixelRatio': window.devicePixelRatio})

    this.container = document.getElementById('three-container');
    this.width = this.container.offsetWidth;
    this.height = this.container.offsetHeight;
    this.renderer = new THREE.WebGLRenderer();
    this.renderer.setPixelRatio(1);
    this.renderer.setClearColor(0x00000000, 1);
    this.renderer.setSize(innerWidth, innerHeight);
    this.container.appendChild(this.renderer.domElement);
    this.camera = new THREE.PerspectiveCamera(50, this.width / this.height);
    this.camera.position.set(0,0, 8);

    const frustrumSize = 1;
    const aspect = 1;
    this.cameraPost = new THREE.OrthographicCamera(
      frustrumSize * aspect / -2,
      frustrumSize * aspect / 2 ,
      frustrumSize / 2 ,
      frustrumSize / -2,
      -1000, 1000
    );

    this.scene = new THREE.Scene();

    this.time = 0;
    const geometry = new THREE.SphereGeometry( 1, 32, 32 );
    // const material = new THREE.MeshBasicMaterial( { color: 0xffffff } );
    this.material = new THREE.ShaderMaterial({
      side: THREE.DoubleSide,
      uniforms: {
        time: { value: 0.0}
      },
      fragmentShader,
      vertexShader
    });

    this.sphere = new THREE.Mesh( geometry, this.material );
    this.scene.add( this.sphere );

    this.baseTexture = new THREE.WebGLRenderTarget(this.width, this.height, {
      minFilter: THREE.LinearFilter,
      magFilter: THREE.LinearFilter,
      format: THREE.RGBAFormat
    });
    this.materialOrtho = new THREE.ShaderMaterial({
      side: THREE.DoubleSide,
      uniforms: {
        uMap: { value: null},
        oPosition: { value: new THREE.Uniform(screenXY(this.sphere.position, this.camera))}
      },
      fragmentShader: fragmentPost,
      vertexShader: vertexPost
    });

    this.postQuadMesh = new THREE.Mesh(new THREE.PlaneBufferGeometry(1,1), this.materialOrtho);

    this.scenePost = new THREE.Scene();
    this.scenePost.add(this.postQuadMesh);


    this.controls = new OrbitControls(this.camera, this.renderer.domElement);

    window.addEventListener('resize', this.resize);

    requestAnimationFrame(this.render);
  }

  resize = () => {
    this.width = this.container.offsetWidth;
    this.height = this.container.offsetHeight;
    this.renderer.setSize(this.width, this.height);
    this.camera.aspect = this.width / this.height;
    this.camera.updateProjectionMatrix();
  }

  render = (time) => {
    this.sphere.rotateY(0.001);
    this.sphere.rotateX(0.001);
    this.sphere.rotateZ(0.001);
    this.stats.end();

    this.stats.begin();
    requestAnimationFrame(this.render);
    this.time = time;
    this.material.uniforms.time.value = this.time;

    let screenCoord = screenXY(this.sphere.position, this.camera);

    this.renderer.setRenderTarget(this.baseTexture);
    this.renderer.render(this.scene, this.camera);
    this.renderer.setRenderTarget(null);
    this.materialOrtho.uniforms.uMap.value = this.baseTexture.texture;
    this.materialOrtho.uniforms.oPosition.value = screenCoord;
    this.renderer.render(this.scenePost, this.cameraPost);

  }
}

window.onload = () => new App();