#ifdef GL_ES
precision mediump float;
#endif

uniform vec2 resolution;
uniform vec2 whiteDirs[4];
uniform vec2 blackDirs[4];

// simulation texture state, swapped each frame
uniform sampler2D state;

// look up individual cell values 
int getRed(int x, int y) {
  return int( 
    texture2D( state, ( gl_FragCoord.xy + vec2(x, y) ) / resolution ).r 
  );
}

float getGreen(int x, int y) { //if equals 2.04, then ant
  return float( 
    texture2D( state, ( gl_FragCoord.xy + vec2(x, y) ) / resolution ).g 
  );
}

int blackIndex = 0;
int whiteIndex = 0;

 

void main() {

    float self = getGreen(0, 0);
    int cell = getRed(0, 0); //check if square ant is on is filled or not
    
    if(self == 2.04 && cell == 1){ //i am an ant! and the cell i'm on is alive!
        
       // whiteDir()
        //change self value to be black, and also have no ant
        //move right + change current cell value to black
        gl_FragColor = vec4( vec3( 0.0 ), 1.0 );
    } else if(self == 2.04 && cell == 0){ //i am ant and cell is dead
        //move left + change current cell value to white
        gl_FragColor = vec4( 1. );
    } else {

        //am i the new ant? change green value to reflect that 
        //check all 4 neighbors + their cell colors

        int nTopCell = getRed(0,1);
        float nTopAnt = getGreen(0,1);

        int nLeftCell = getRed(-1,0);
        float nLeftAnt = getGreen(-1,0);

        int nBottomCell = getRed(0,-1);
        float nBottomAnt = getGreen(0,-1);

        int nRightCell = getRed(1,0);
        float nRightAnt = getGreen(1,0);

        


        float current = float( getRed(0, 0) );
        gl_FragColor = vec4( vec3( current ), 1.0 );
    }

    //float current = float( getGreen(0, 0) );
    //gl_FragColor = vec4( vec3( current ), 1.0 );

}