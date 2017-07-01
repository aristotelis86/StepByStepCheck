///*******************************************************************
//// Testing Particle Class  //
//// The particles are tested in terms of their update methods for velocity and position
//// - Update methods are working as expected, storing the previous velocity and position of the particle
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
//PrintWriter outputPos; // declare output file for positions
//PrintWriter outputPosOLD; // declare output file for positions
//PrintWriter outputVel; // declare output file for velocities
//PrintWriter outputVelOLD; // declare output file for velocities

//float [] x, y;
//float [] vx, vy;

////--------------------------- Setup Section ---------------------------//
//void setup() {
//  size(800, 600); // window size
  
//  x = new float[N];
//  y = new float[N];
//  vx = new float[N];
//  vy = new float[N];
  
//  p = new Particle[N];
//  for (int i = 0; i < N; i++) {
//    p[i] = new Particle(xpos, ypos+i*20, M, 2*M);
//  }
  
  
//  outputPos = createWriter("positions.txt");
//  outputPos.println("=========== Positions ==========");
//  outputPos.println("Mass: "+M+" Points: "+N);
  
//  outputPosOLD = createWriter("positionsOLD.txt");
//  outputPosOLD.println("=========== Positions OLD ==========");
//  outputPosOLD.println("Mass: "+M+" Points: "+N);
  
//  outputVel = createWriter("velocities.txt");
//  outputVel.println("=========== Velocities ==========");
//  outputVel.println("Mass: "+M+" Points: "+N);
  
//  outputVelOLD = createWriter("velocitiesOLD.txt");
//  outputVelOLD.println("=========== Velocities OLD ==========");
//  outputVelOLD.println("Mass: "+M+" Points: "+N);

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
//    x[j] = xpos + 20*sin(2*PI*t);  
//    y[j] = (ypos+j*20)+ 10*sin(2*PI*t);
//    p[j].updatePosition(x[j],y[j]);
    
//    vx[j] = 20*cos(2*PI*t);  
//    vy[j] = 10*cos(2*PI*t);
//    p[j].updateVelocity(vx[j],vy[j]);
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
//  outputPos.println("============= t = "+t+" ================");
//  outputPosOLD.println("============= t = "+t+" ================");
//  outputVel.println("============= t = "+t+" ================");
//  outputVelOLD.println("============= t = "+t+" ================");
//  for (Particle PP : p) {
//    outputPos.println(PP.position.x + " " + PP.position.y);
//    outputPosOLD.println(PP.positionOld.x + " " + PP.positionOld.y);
//    outputVel.println(PP.velocity.x + " " + PP.velocity.y);
//    outputVelOLD.println(PP.velocityOld.x + " " + PP.velocityOld.y);
//  }
//}

//// Gracefully terminate writing...
//void keyPressed() {
  
//  outputPos.flush(); // Writes the remaining data to the file
//  outputPos.close(); // Finishes the file
  
//  outputPosOLD.flush(); // Writes the remaining data to the file
//  outputPosOLD.close(); // Finishes the file
  
//  outputVel.flush(); // Writes the remaining data to the file
//  outputVel.close(); // Finishes the file
  
//  outputVelOLD.flush(); // Writes the remaining data to the file
//  outputVelOLD.close(); // Finishes the file
  
//  exit(); // Stops the program 
//}