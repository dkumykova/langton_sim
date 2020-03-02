#ifdef GL_ES
    precision mediump float;
    #endif
    
    uniform mediump float time;
    uniform mediump vec2 resolution;
    uniform mediump float speed;
    

    vec2 random2( vec2 p ) {
    return fract(sin(vec2(dot(p,vec2(127.1,311.7)),dot(p,vec2(269.5,183.3))))*43758.5453);
  } 

  void main() {
      vec2 p = gl_FragCoord.xy/resolution.xy;
      p.x *= resolution.x/resolution.y;
      vec3 color = vec3(.0);

      // Scale
      p *= 5.;

      // Tile the space
      vec2 i_p = floor(p);
      vec2 f_p = fract(p);

      float m_dist = 1.;  // minimun distance

      for (int y= -1; y <= 1; y++) {
          for (int x= -1; x <= 1; x++) {
              // Neighbor place in the grid
              vec2 neighbor = vec2(float(x),float(y));

              // Random position from current + neighbor place in the grid
              vec2 point = random2(i_p + neighbor);
              //point =vec2(2.*sin(point.x), 2.*sin(point.y));

        // Animate the point
              point = 0.9 + 0.9*sin(time*point/speed);

        // Vector between the pixel and the point
              vec2 diff = neighbor + point - f_p;

              // Distance to the point
              float dist = length(diff);

              // Keep the closer distance
              m_dist = min(m_dist, dist);
          }
      }

      // Draw the min distance (distance field)
      color += m_dist;

      // Draw cell center
      //color += 1.-step(.02, m_dist);

      // Draw grid
      color.r += step(.98, f_p.x) + step(.98, f_p.y);

      // Show isolines
     // color -= step(.7,abs(sin(27.0*m_dist)))*.5;

      gl_FragColor = vec4(color,1.0);
  }
