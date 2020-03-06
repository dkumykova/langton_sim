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
    
    if(self == 0.2 && cell == 0 ){ //i am an ant! and the cell is black
        
      
        //change self value to be white, and also have no ant
        gl_FragColor = vec4( 1., 1., newDir, 1. );
        
    } else if(self == 0.2 && cell == 1){ //i am ant and cell is white

        gl_FragColor = vec4( vec3(0.0, 0.0, newDir), 1.0 );

    } else {

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

        if( (leftAnt == 0.2 && 0.75 < leftDir && leftDir < 1.0) || (bottomAnt == 0.2 && 0.5 < bottomDir && bottomDir < 0.75) ||
          (rightAnt == 0.2 && 0.25 < rightDir && rightDir < 0.5) || (topAnt == 0.2 && 0.0 < topDir && topDir < 0.25)){ //above square is white ant and direction is down
            gl_FragColor = vec4(cell, 0.2, newDir, 1.);
        }
  
        else {
          
          float current = float( getRed(0, 0) );
          gl_FragColor = vec4( vec3( current ), 1.0 );

        }


    }

    //float current = float( getRed(0, 0) );
    //gl_FragColor = vec4( vec3( current ), 1.0 );

}