///*******************************************************************
//// Testing FlexibleSheet Class  //
//// Check the correct application of forces and the calculation of total energy of the sheet.
//// - Test is ok in general. Numerical discrepancies of the order of 1e-5 are present (sim-true/true = 1e-5)
//*******************************************************************/


////--------------------- INPUTS Section ---------------------------//
//float L = 200; // total (unstretched) length of sheet
//float M = 6; // total mass of sheet
//int N = 6; // number of control points used to represent the sheet
//float stiff = 100; // stiffness of each spring in the sheet (overall stiffness = value given/N)
//boolean damp = true; // flag to include damping in the simulation (numerical reasons mostly)
//boolean alignX = false; // should it be aligned with x-axis

//float offsetX = 400, offsetY = 30; // position of leading point

//PVector gravity = new PVector(0,10);

//float t;
//float dt = 0.1;
////int Nfil = 2; // number of sheets to create (if needed)
////--------------------- END of INPUTS Section ---------------------------//
//FlexibleSheet sheet;
////FlexibleSheet [] sheet;

//PrintWriter outputPos; // declare output file for positions
//PrintWriter outputVel; // declare output file for velocities
//PrintWriter outputPosOLD; // declare output file for positions
//PrintWriter outputVelOLD; // declare output file for velocities
//PrintWriter outputForce; // declare output file for positions

//float [] x = new float[N];
//float [] y = new float[N];
//float [] vx = new float[N];
//float [] vy = new float[N];


////--------------------------- Setup Section ---------------------------//
//void setup() {
//  size(800, 600); // window size
  
//  sheet = new FlexibleSheet(L, M, N, stiff, damp, offsetX, offsetY, alignX);
  
//  sheet.Calculate_Stretched_Positions(gravity);
  
//  outputPos = createWriter("positions.txt");
//  outputPos.println("=========== Positions ==========");
//  outputPos.println("Mass: "+M+" Points: "+N);
  
//  outputVel = createWriter("velocities.txt");
//  outputVel.println("=========== Velocities ==========");
//  outputVel.println("Mass: "+M+" Points: "+N);
  
//  outputPosOLD = createWriter("positionsOLD.txt");
//  outputPosOLD.println("=========== Positions Old ==========");
//  outputPosOLD.println("Mass: "+M+" Points: "+N);
  
//  outputVelOLD = createWriter("velocitiesOLD.txt");
//  outputVelOLD.println("=========== Velocities Old ==========");
//  outputVelOLD.println("Mass: "+M+" Points: "+N);
  
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
//  sheet.display();
  
//  // Apply the forces
//  sheet.ApplyAllForces();
//  for (Particle PP : sheet.prtcl) PP.applyForce(PVector.mult(gravity,PP.mass));
  
//  // Write info
//  sheet.calculate_Energy(gravity, height);
//  println("Total energy is "+sheet.Energy);
//  Write_Info();
  
  
//  // Update
//  //for (int j=0; j<N; j++) {
//  //  x[j] = sheet.prtcl[j].position.x + sin(t);
//  //  y[j] = sheet.prtcl[j].position.y + cos(t);
    
//  //  vx[j] = 2*t+1;
//  //  vy[j] = -3*t;
//  //}
//  //sheet.UpdateState(x, y, vx, vy);
  
  
//  t += dt;
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
//  outputVel.println("============= t = "+t+" ================");
//  outputPosOLD.println("============= t = "+t+" ================");
//  outputVelOLD.println("============= t = "+t+" ================");
//  outputForce.println("============= t = "+t+" ================");
  
//  for (Particle PP : sheet.prtcl) {
//    outputPos.println(PP.position.x + " " + PP.position.y);
//    outputVel.println(PP.velocity.x + " " + PP.velocity.y);
//    outputPosOLD.println(PP.positionOld.x + " " + PP.positionOld.y);
//    outputVelOLD.println(PP.velocityOld.x + " " + PP.velocityOld.y);
//    outputForce.println(PP.force.x + " " + PP.force.y);
//  }
  
//}

//// Gracefully terminate writing...
//void keyPressed() {
  
//  outputPos.flush(); // Writes the remaining data to the file
//  outputPos.close(); // Finishes the file
  
//  outputVel.flush(); // Writes the remaining data to the file
//  outputVel.close(); // Finishes the file
  
//  outputPosOLD.flush(); // Writes the remaining data to the file
//  outputPosOLD.close(); // Finishes the file
  
//  outputVelOLD.flush(); // Writes the remaining data to the file
//  outputVelOLD.close(); // Finishes the file
  
//  outputForce.flush(); // Writes the remaining data to the file
//  outputForce.close(); // Finishes the file
  
//  exit(); // Stops the program 
//}