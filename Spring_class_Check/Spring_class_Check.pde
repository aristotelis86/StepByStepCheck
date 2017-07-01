/*******************************************************************
// Testing Spring Class  //
// The proper application of forces and stretching calculation are tested. 
*******************************************************************/


//--------------------- INPUTS Section ---------------------------//
int N = 2;
float M = 10;
float stiffness = 100;
float restLength = 100;
float xpos = 400;
float ypos = 100;

float t = 0; // timer
float dt = 0.1; // time step size
//--------------------- END of INPUTS Section ---------------------------//

Spring s;
Particle [] p;

PrintWriter outputPos; // declare output file for positions
PrintWriter outputForce; // declare output file for positions

float [] x, y;
float [] vx, vy;

//--------------------------- Setup Section ---------------------------//
void setup() {
  size(800, 600); // window size
  
  p = new Particle[N];
  
  x = new float[N];
  y = new float[N];
  vx = new float[N];
  vy = new float[N];
  
  // Two particles with a distance of 100 units (pixels)
  p[0] = new Particle(xpos, ypos, M, 10);
  p[1] = new Particle(xpos+sqrt(2)*50, ypos+sqrt(2)*50, M, 10);
  
  s = new Spring(p[0], p[1], restLength, stiffness);
  
  outputForce = createWriter("forces.txt");
  outputForce.println("=========== Forces ==========");
  outputForce.println("Mass: "+M+" Points: "+N);
  
  outputPos = createWriter("positions.txt");
  outputPos.println("=========== Positions ==========");
  outputPos.println("Mass: "+M+" Points: "+N);
  
} // end of setup


//--------------------------- Draw Section ---------------------------//
void draw() {
  background(25); // color of background
  fill(0, 225, 225); // color of text for timer
  textSize(32); // text size of timer
  text(t, 10, 30); // position of timer
  
  // Display
  for (Particle P : p) P.display();
  s.display();
  
  // Write info
  Write_Info();
  
  // Update
  for (Particle P : p) P.clearForce();
  s.applyAllForces();
  
  x[0] = xpos + sqrt(2)*10*sin(5*PI*t);  
  y[0] = ypos + sqrt(2)*10*sin(5*PI*t);
  
  x[1] = xpos+sqrt(2)*50 - sqrt(2)*10*sin(5*PI*t);  
  y[1] = ypos+sqrt(2)*50 - sqrt(2)*10*sin(5*PI*t);
  
  p[0].updatePosition(x[0],y[0]);
  p[1].updatePosition(x[1],y[1]);
    
  //  vx[j] = 20*cos(2*PI*t);  
  //  vy[j] = 10*cos(2*PI*t);
  //  p[j].updateVelocity(vx[j],vy[j]);
  //}
  
  t += dt;
  noLoop();
} // end Draw()


//-------------------------- Additional Utilities ---------------------//
void mousePressed() {
  loop();
}

void mouseReleased() {
  noLoop();
}

// Write information to files
void Write_Info() {
  outputForce.println("============= t = "+t+" ================");
  outputPos.println("============= t = "+t+" ================");
  
  for (Particle PP : p) {
    outputForce.println(PP.force.x + " " + PP.force.y);
    outputPos.println(PP.position.x + " " + PP.position.y);
  }
}

// Gracefully terminate writing...
void keyPressed() {
  
  outputForce.flush(); // Writes the remaining data to the file
  outputForce.close(); // Finishes the file
  
  outputPos.flush(); // Writes the remaining data to the file
  outputPos.close(); // Finishes the file
  
  exit(); // Stops the program 
}