#ifdef GL_ES
precision mediump float;
#endif

uniform vec2 resolution;
uniform float newDir;

// simulation texture state, swapped each frame
uniform sampler2D state;

// look up individual cell values 
int getRed(int x, int y) {
  return int( 
    texture2D( state, ( gl_FragCoord.xy + vec2(x, y) ) / resolution ).r 
  );
}

float getGreen(int x, int y) { //if equals 0.2, then ant
  return float( 
    texture2D( state, ( gl_FragCoord.xy + vec2(x, y) ) / resolution ).g 
  );
}

float getBlue(int x, int y) { 
  return float( 
    texture2D( state, ( gl_FragCoord.xy + vec2(x, y) ) / resolution ).b 
  );
}

void main() {

    float self = getGreen(0, 0);
    int cell = getRed(0, 0); //check if square ant is on is filled or not

        //am i the new ant? change green value to reflect that 
        //check all 4 neighbors + their cell colors

        int topCell = getRed(0,1);
        float topAnt = getGreen(0,1);
        float topDir = getBlue(0,1);

        int leftCell = getRed(-1,0);
        float leftAnt = getGreen(-1,0);
        float leftDir = getBlue(-1,0);

        int bottomCell = getRed(0,-1);
        float bottomAnt = getGreen(0,-1);
        float bottomDir = getBlue(0,-1);

        int rightCell = getRed(1,0);
        float rightAnt = getGreen(1,0);
        float rightDir = getBlue(1,0);


        //need to randomize order things are checked

        if(leftAnt == 0.2 && 0.75 < leftDir && leftDir < 1.0){
          if(cell==0){ //black
              //this cell now has an ant with direction down
              gl_FragColor = vec4(cell, 0.2, .1, 1.);

            } else if (cell==1){//white
              //this cell now has an ant with direction up
              gl_FragColor = vec4(cell, 0.2, .6, 1.);
            }

        } else if (bottomAnt == 0.2 && 0.5 < bottomDir && bottomDir < 0.75){
          if(cell==0){ //black
              //this cell now has an ant with direction right
              gl_FragColor = vec4(cell, 0.2, .8, 1.);

            } else if (cell==1){//white
              //this cell now has an ant with direction left
              gl_FragColor = vec4(cell, 0.2, .4, 1.);
            }

        } else if(rightAnt == 0.2 && 0.25 < rightDir && rightDir < 0.5){
          if(cell==0){ //black
              //this cell now has an ant with direction up
              gl_FragColor = vec4(cell, 0.2, .6, 1.);

            } else if (cell==1){//white
              //this cell now has an ant with direction down
              gl_FragColor = vec4(cell, 0.2, .1, 1.);
            }

        } else if(topAnt == 0.2 && 0.0 < topDir && topDir < 0.25){
          if(cell==0){ //black
              //this cell now has an ant with direction left
              gl_FragColor = vec4(cell, 0.2, .4, 1.);

            } else if (cell==1){//white
              //this cell now has an ant with direction right
              gl_FragColor = vec4(cell, 0.2, .8, 1.);
            }

        }
        

        if(self == 0.2 && cell == 0 ){ //i am an ant! and the cell is black
      
          //change self value to be white, and also have no ant, direction is right
          gl_FragColor = vec4( 1., 1., .8, 1. );
          
        } else if(self == 0.2 && cell == 1){ //i am ant and cell is white, direction is left

            gl_FragColor = vec4( vec3(0.0, 0.0, .5), 1. );

        } 
        
}