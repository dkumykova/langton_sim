#ifdef GL_ES
precision mediump float;
#endif

uniform vec2 resolution;
uniform vec2 mouse;
uniform float time;
uniform mediump float speed;
uniform mediump float red;
uniform mediump float blue;
uniform mediump float green;
uniform mediump float scale;
uniform mediump float mouseX;
uniform mediump float mouseY;

vec2 random2( vec2 p ) {
    return fract(sin(vec2(dot(p,vec2(127.1,311.7)),dot(p,vec2(269.5,183.3))))*43758.5453);
}

float rand(vec2 c){
	return fract(sin(dot(c.xy ,vec2(12.9898,78.233))) * 43758.5453);
}

void main() {
    vec2 p = gl_FragCoord.xy/resolution.xy;
    p.x *= resolution.x/resolution.y;
    vec3 color = vec3(1.);

    // Scale
    p *= scale;

    // Tile the space
    vec2 i_p = floor(p);
    vec2 f_p = fract(p);
    vec2 point;
    float m_dist = 1.;  // minimun distance

    for (int y= -1; y <= 1; y++) {
        for (int x= -1; x <= 1; x++) {
            // Neighbor place in the grid
            vec2 neighbor = vec2(float(x),float(y));

            if(x == 1 ){
                 point = random2(i_p + neighbor);
            } else {
                // Random position from current + neighbor place in the grid
                point = random2(i_p + neighbor);
            }

			// Animate the point
            point = 0.5 + 0.5*sin(time/(speed) + 6.2831*point);

			// Vector between the pixel and the point
            vec2 diff = neighbor + point - f_p;

            // Distance to the point
            float dist = length(diff);

            // Keep the closer distance
            m_dist = min(m_dist, dist);
            //m_dist = smoothstep(dist, diff, m_dist);
        }
    }

    // Draw the min distance (distance field)
    color += m_dist*m_dist;    

    color+= fract(m_dist) * mouseX;

    // Draw cell center
   // color += 1.-step(.02, m_dist);

    // Draw grid
    //color.r += step(.98, f_p.x) + step(.98, f_p.y);

    // Show isolines
    // color -= step(.7,abs(sin(27.0*m_dist)))*.5;

    gl_FragColor = vec4(vec3(color.x*sin(mouseX), color.y*blue, color.z*green),1.0);
}