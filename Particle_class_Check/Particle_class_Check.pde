/*******************************************************************
// Testing Particle Class  //
// The particles are expected to be positioned exactly where they are asked 
*******************************************************************/


//--------------------- INPUTS Section ---------------------------//

float M = 5; // Mass of particle
int N = 6; // number of particles
float xpos = 400; // x-location of leading edge
float ypos = 30; // y-location of leading edge

float t = 0; // timer
float dt = 0.1; // time step size
//--------------------- END of INPUTS Section ---------------------------//


Particle [] p;
PrintWriter outputPos; // declare output file for positions
PrintWriter outputPosOLD; // declare output file for positions

//--------------------------- Setup Section ---------------------------//
void setup() {
  size(800, 600); // window size
  
  p = new Particle[N];
  for (int i = 0; i < N; i++) {
    p[i] = new Particle(xpos, ypos+i*20, M, 2*M);
  }
  
  
  outputPos = createWriter("positions.txt");
  outputPos.println("=========== Positions ==========");
  outputPos.println("Mass: "+M+" Points: "+N);
  
  outputPosOLD = createWriter("positionsOLD.txt");
  outputPosOLD.println("=========== Positions OLD ==========");
  outputPosOLD.println("Mass: "+M+" Points: "+N);

} // end of setup


//--------------------------- Draw Section ---------------------------//
void draw() {
  background(25); // color of background
  fill(0, 225, 225); // color of text for timer
  textSize(32); // text size of timer
  text(t, 10, 30); // position of timer
  
  // Display
  for (Particle PP : p) PP.display();
  
  // Write info
  outputPos.println("============= t = "+t+" ================");
  outputPosOLD.println("============= t = "+t+" ================");
  for (Particle PP : p) {
    outputPos.println(PP.position.x + " " + PP.position.y);
    outputPosOLD.println(PP.positionOld.x + " " + PP.positionOld.y);
  }
  
  t += dt; // increment time
  noLoop();
} // end Draw()


//-------------------------- Additional Utilities ---------------------//
void mousePressed() {
  loop();
}

void mouseReleased() {
  noLoop();
}

// Gracefully terminate writing...
void keyPressed() {
  
  outputPos.flush(); // Writes the remaining data to the file
  outputPos.close(); // Finishes the file
  
  outputPosOLD.flush(); // Writes the remaining data to the file
  outputPosOLD.close(); // Finishes the file
  
  exit(); // Stops the program 
}