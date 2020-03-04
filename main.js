const glslify = require( 'glslify' )
const toy     = require( 'gl-toy' )

const shader = glslify( './fragment2.glsl' )

controls = function() {
  this.speed = 35;
  this.red = .5;
  this.blue = .5;
  this.green = .5;
  this.scale = 10;
  this.reload = function(){location.reload();}

};

let count = 0
let ui = new controls();
let mouseX, mouseY, click
window.onload = function() {
  //ui = new controls();
      var gui = new dat.GUI();
      gui.add(ui, 'speed', 1, 50);
      gui.add(ui, 'red', 0, 1);
      gui.add(ui, 'blue', 0, 1);
      gui.add(ui, 'green', 0, 1);
      gui.add(ui, 'scale', 1, 20);
      gui.add(ui, 'reload');

}


toy( shader, (gl, shader) => {
  // this function runs once per frame
  shader.uniforms.resolution = [ gl.drawingBufferWidth, gl.drawingBufferHeight ]
  shader.uniforms.time = count++
  shader.uniforms.speed = ui.speed;
  shader.uniforms.red = ui.red;
  shader.uniforms.blue = ui.blue;
  shader.uniforms.green = ui.green;
  shader.uniforms.scale = ui.scale;
  shader.uniforms.mouseX = mouseX;
  shader.uniforms.mouseY = mouseY;
  //shader.uniforms.click = click;
})


var mouse = require('mouse-event')
 
window.addEventListener('mousemove', function(ev) {
 
  //console.log('element' + mouse.element(ev))
  console.log('x' + mouse.x(ev))
  console.log('y' + mouse.y(ev))

})

window.addEventListener('click', function(ev){
  console.log('mouse has been clicked')
  mouseX = mouse.x(ev);
  mouseY = mouse.y(ev);
  click = true;
})




