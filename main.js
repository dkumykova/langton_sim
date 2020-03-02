const glslify = require( 'glslify' )
const toy     = require( 'gl-toy' )

const shader = glslify( './fragment.glsl' )

controls = function() {
  this.speed = 35;
  this.reload = function(){location.reload();}

};

let count = 0
let ui = new controls();
window.onload = function() {
  //ui = new controls();
      var gui = new dat.GUI();
      gui.add(ui, 'speed', 1, 50);
      gui.add(ui, 'reload');
}


toy( shader, (gl, shader) => {
  // this function runs once per frame
  shader.uniforms.resolution = [ gl.drawingBufferWidth, gl.drawingBufferHeight ]
  shader.uniforms.time = count++
  shader.uniforms.speed = ui.speed;
})



