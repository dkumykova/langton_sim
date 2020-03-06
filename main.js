const glslify = require('glslify')
const toy     = require('gl-toy')
const fbo     = require('gl-fbo')
const fillScreen = require('a-big-triangle')
const createShader = require('gl-shader')

const draw = glslify('./draw.glsl')
      vert = glslify.file('./vert.glsl'),
      gol  = glslify.file('./sim.glsl')

let   initialized = false,
      sim = null
      
const state = []


function getRandomFloat(max) {
  return Math.random() * Math.floor(max);
}


function pokeAnt( x, y, value, texture ) {  
  const gl = texture.gl
  texture.bind()

  gl.texSubImage2D( 
    gl.TEXTURE_2D, 0, 
    x, y, 1, 1,
    gl.RGBA, gl.UNSIGNED_BYTE,
    new Uint8Array([ value,51,getRandomFloat(255), 255 ]) //store direction in blue value, ifAnt in green, ifAlive in red
  )
}

function setInitialState( width, height, tex ) {
  for( i = 0; i < width; i++ ) {
    for( j = 0; j < height; j++ ) {
      if( Math.random() > .9999) {
        pokeAnt( i, j, 255, tex )
      }
    }
  }
}

//var ant1 = {x:200, y:500}
//var ant2 = {x:1, y:1}
var whiteDirs = [(-1,0),(0,-1),(1,0),(0,1)]
var blackDirs = [(1,0),(0,-1),(-1,0),(0,1)]

function init( gl ) {
  const w = gl.drawingBufferWidth
  const h = gl.drawingBufferHeight
  state[0] = fbo( gl, [w,h] )
  state[1] = fbo( gl, [w,h] )
  
  sim = createShader( gl, vert, gol )

  //create starting ants
  //add to ants array
  //ants.push(ant1, ant2)
  pokeAnt(w/2, h/2, 255, state[0].color[0])
  pokeAnt((w/2)+5, (h/2)-5, 255, state[0].color[0])
  pokeAnt((w/2)-5, (h/2)-5, 255, state[0].color[0])
  //setInitialState( w,h, state[0].color[0] )
  initialized = true
}

let current = 0
var newDir = 0
function tick( gl ) {
  const prevState = state[current]
  const curState = state[current ^= 1]
 
  curState.bind() // fbo
  sim.bind()      // shader

  newDir = getRandomFloat(1)
  
  sim.uniforms.resolution = [ gl.drawingBufferWidth, gl.drawingBufferHeight ]
  sim.uniforms.state = prevState.color[0].bind()
  sim.uniforms.newDir = newDir
  
  sim.attributes.a_position.location = 0

  fillScreen( gl )
}

let count = 0
toy( draw, (gl, shader) => {
  if( !initialized ) init( gl )
  tick( gl )
  shader.bind()

  // restore default framebuffer binding after overriding in tick
  gl.bindFramebuffer( gl.FRAMEBUFFER, null )

  shader.uniforms.resolution = [ gl.drawingBufferWidth, gl.drawingBufferHeight ]
  shader.uniforms.uSampler = state[ 0 ].color[0].bind()
  shader.uniforms.time = count++

})

var mouse = require('mouse-event')
 
let x,y
window.addEventListener( 'mousemove', e => {
  x = e.pageX
  y = e.pageY
  console.log(x)
  console.log(y)
})

window.addEventListener('click', function(ev){
  console.log('mouse has been clicked')
  // if(y < gl.drawingBufferHeight/2){
  //   y = gl.drawingBufferHeight/2
  // } else {
  //   y = y + gl.drawingBufferHeight/2
  // }
  pokeAnt(x, y , 255, state[0].color[0])
  
  click = true;
})




