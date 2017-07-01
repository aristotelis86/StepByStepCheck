///*******************************************************************
//// Testing Particle Class  //
//// The forces methods are tested here
//// - Application of forces is successful, the accuracy of the numerical system tends to be 1e-5
//*******************************************************************/


////--------------------- INPUTS Section ---------------------------//

//float M = 5; // Mass of particle
//int N = 6; // number of particles
//float xpos = 400; // x-location of leading edge
//float ypos = 30; // y-location of leading edge

//float t = 0; // timer
//float dt = 0.1; // time step size
////--------------------- END of INPUTS Section ---------------------------//


//Particle [] p;
//PrintWriter outputForce; // declare output file for positions

//PVector gravity = new PVector(0,10);
//PVector [] pressure; 


////--------------------------- Setup Section ---------------------------//
//void setup() {
//  size(800, 600); // window size
  
//  pressure = new PVector[N];
  
//  p = new Particle[N];
//  for (int i = 0; i < N; i++) {
//    p[i] = new Particle(xpos, ypos+i*20, M, 2*M);
//  }
  
//  outputForce = createWriter("forces.txt");
//  outputForce.println("=========== Forces ==========");
//  outputForce.println("Mass: "+M+" Points: "+N);
  
//} // end of setup


////--------------------------- Draw Section ---------------------------//
//void draw() {
//  background(25); // color of background
//  fill(0, 225, 225); // color of text for timer
//  textSize(32); // text size of timer
//  text(t, 10, 30); // position of timer
  
//  // Display
//  for (Particle PP : p) PP.display();
  
//  // Write info
//  Write_Info();
  
  
  
//  // Update
//  for (int j = 0; j < N; j++) {
//    pressure[j] = new PVector(sin(2*PI*t), cos(2*PI*t));
    
//    PVector F = PVector.add(PVector.mult(gravity,p[j].mass), pressure[j]);
    
//    p[j].clearForce();
    
//    p[j].applyForce(F);
//  }
  
  
//  t += dt; // increment time
//  noLoop();
//} // end Draw()


////-------------------------- Additional Utilities ---------------------//
//void mousePressed() {
//  loop();
//}

//void mouseReleased() {
//  noLoop();
//}

//// Write information to files
//void Write_Info() {
//  outputForce.println("============= t = "+t+" ================");
  
//  for (Particle PP : p) {
//    outputForce.println(PP.force.x + " " + PP.force.y);
//  }
//}

//// Gracefully terminate writing...
//void keyPressed() {
  
//  outputForce.flush(); // Writes the remaining data to the file
//  outputForce.close(); // Finishes the file
  
//  exit(); // Stops the program 
//}