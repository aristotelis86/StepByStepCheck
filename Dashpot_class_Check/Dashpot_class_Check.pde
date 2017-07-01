/*******************************************************************
// Testing Dashpot Class  //
// The class is tested for correct application of forces and the ability for a live update of the damping coefficient.
// - The test is successful. Since it is a very simple class, it could be merged with the Spring class, extending its capabilities.
*******************************************************************/


//--------------------- INPUTS Section ---------------------------//
int N = 2;
float M = 10;
float damping = 10;
float xpos = 400;
float ypos = 100;

float t = 0; // timer
float dt = 0.1; // time step size
//--------------------- END of INPUTS Section ---------------------------//

Dashpot d;
Particle [] p;

PrintWriter outputPos; // declare output file for positions
PrintWriter outputVel; // declare output file for velocities
PrintWriter outputForce; // declare output file for forces

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
  //p[1] = new Particle(xpos+sqrt(2)*50, ypos+sqrt(2)*50, M, 10);
  p[1] = new Particle(xpos+100, ypos, M, 10);
  
  d = new Dashpot(p[0], p[1], damping);
  
  outputForce = createWriter("forces.txt");
  outputForce.println("=========== Forces ==========");
  outputForce.println("Mass: "+M+" Points: "+N);
  
  outputPos = createWriter("positions.txt");
  outputPos.println("=========== Positions ==========");
  outputPos.println("Mass: "+M+" Points: "+N);
  
  outputVel = createWriter("velocities.txt");
  outputVel.println("=========== Velocities ==========");
  outputVel.println("Mass: "+M+" Points: "+N);
  
  
} // end of setup


//--------------------------- Draw Section ---------------------------//
void draw() {
  background(25); // color of background
  fill(0, 225, 225); // color of text for timer
  textSize(32); // text size of timer
  text(t, 10, 30); // position of timer
  
  // Display
  for (Particle P : p) P.display();
  
  // Write info
  Write_Info();
  
  // Update
  for (Particle P : p) P.clearForce();
  d.applyAllForces();
  
  
  //x[0] = xpos + 5*t;  
  //y[0] = ypos + 2*t;
  
  //x[1] = xpos+200; //+sqrt(2)*50 - sqrt(2)*10*sin(5*PI*t);  
  //y[1] = ypos+100;//sqrt(2)*50 - sqrt(2)*10*sin(5*PI*t);
  
  //p[0].updatePosition(x[0],y[0]);
  //p[1].updatePosition(x[1],y[1]);
    
  vx[0] = -20*t;  
  vy[0] = 0*t;
  
  vx[1] = 20*t;  
  vy[1] = 0*t;
  
  p[0].updateVelocity(vx[0],vy[0]);
  p[1].updateVelocity(vx[1],vy[1]);
  
  if (t>0.3) d.UpdateDamping(damping+10);
  
  println("Damping="+d.damping);
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
  outputVel.println("============= t = "+t+" ================");
  
  for (Particle PP : p) {
    outputForce.println(PP.force.x + " " + PP.force.y);
    outputPos.println(PP.position.x + " " + PP.position.y);
    outputVel.println(PP.velocity.x + " " + PP.velocity.y);
  }
}

// Gracefully terminate writing...
void keyPressed() {
  
  outputForce.flush(); // Writes the remaining data to the file
  outputForce.close(); // Finishes the file
  
  outputPos.flush(); // Writes the remaining data to the file
  outputPos.close(); // Finishes the file
  
  outputVel.flush(); // Writes the remaining data to the file
  outputVel.close(); // Finishes the file
  
  exit(); // Stops the program 
}