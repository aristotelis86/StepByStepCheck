///*******************************************************************
//// Testing CollisionSolver Class  //
//// Test Detecting collision with boundaries.
//// - The test is successful in DETECTING the oncoming collision with a boundary.
//*******************************************************************/


////--------------------- INPUTS Section ---------------------------//
//float L = 100; // total (unstretched) length of sheet
//float M = 6; // total mass of sheet
//int N = 6; // number of control points used to represent the sheet
//float stiff = 100; // stiffness of each spring in the sheet (overall stiffness = value given/N)
//boolean damp = true; // flag to include damping in the simulation (numerical reasons mostly)
//boolean alignX = false; // should it be aligned with x-axis

//float offsetX = 400, offsetY = 30; // position of leading point

//PVector gravity = new PVector(0,0);

//float t;
//float dt;
////int Nfil = 2; // number of sheets to create (if needed)

////--------------------- END of INPUTS Section ---------------------------//
//FlexibleSheet sheet, sheet2;
////FlexibleSheet [] sheet;
//CollisionSolver Collide;

//PrintWriter outputPos; // declare output file for positions
//PrintWriter outputVel; // declare output file for velocities
//PrintWriter outputPosOLD; // declare output file for positions
//PrintWriter outputVelOLD; // declare output file for velocities
//PrintWriter outputForce; // declare output file for forces
//PrintWriter outputEnergy; // declare output file for positions

////--------------------------- Setup Section ---------------------------//
//void setup() {
//  size(800, 600); // window size
  
//  sheet = new FlexibleSheet(L, M, N, stiff, damp, offsetX, offsetY, alignX);
//  //sheet.prtcl[0].makeFixed();
//  //sheet.prtcl[N-1].makeFixed();
//  for (int j=0; j<N; j++) sheet.prtcl[j].velocity.x = 100;
  
//  //sheet.Calculate_Stretched_Positions(gravity);
  
//  Collide = new CollisionSolver(sheet);
  
//  dt = sheet.Determine_time_step();
//  float Damp = sheet.damping;
  
//  outputPos = createWriter("positions.txt");
//  outputPos.println("=========== Positions ==========");
//  outputPos.println("Length: "+L+" Mass: "+M+" Points: "+N+" Stiffness: "+stiff+" Damping: "+Damp);
  
//  outputVel = createWriter("velocities.txt");
//  outputVel.println("=========== Velocities ==========");
//  outputVel.println("Length: "+L+" Mass: "+M+" Points: "+N+" Stiffness: "+stiff+" Damping: "+Damp);
  
//  outputPosOLD = createWriter("positionsOLD.txt");
//  outputPosOLD.println("=========== Positions Old ==========");
//  outputPosOLD.println("Length: "+L+" Mass: "+M+" Points: "+N+" Stiffness: "+stiff+" Damping: "+Damp);
  
//  outputVelOLD = createWriter("velocitiesOLD.txt");
//  outputVelOLD.println("=========== Velocities Old ==========");
//  outputVelOLD.println("Length: "+L+" Mass: "+M+" Points: "+N+" Stiffness: "+stiff+" Damping: "+Damp);
  
//  outputForce = createWriter("forces.txt");
//  outputForce.println("=========== Forces ==========");
//  outputForce.println("Length: "+L+" Mass: "+M+" Points: "+N+" Stiffness: "+stiff+" Damping: "+Damp);
  
//  outputEnergy = createWriter("energy.txt");
//  outputEnergy.println("=========== Energy ==========");
//  outputEnergy.println("Length: "+L+" Mass: "+M+" Points: "+N+" Stiffness: "+stiff+" Damping: "+Damp);
  
//} // end of setup


////--------------------------- Draw Section ---------------------------//
//void draw() {
//  background(25); // color of background
//  fill(0, 225, 225); // color of text for timer
//  textSize(32); // text size of timer
//  text(t, 10, 30); // position of timer
  
//  // Display
//  sheet.display();
//  //sheet2.display();
  
//  // Write info
//  sheet.calculate_Energy(gravity, height);
//  Write_Info();
  
//  // Update
//  //sheet2.RungeKutta4(dt, gravity);
//  sheet.Trapezoid(dt, gravity);
//  Collide.DetectBoundaryCollision();
  
  
//  if (t>2) {
//    sheet.prtcl[0].makeFree(); // release the top at t=3+
//    sheet.prtcl[N-1].makeFree(); // release the bottom at t=3+
//  }
  
//  t += dt;
//  //noLoop();
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
//  outputEnergy.println("============= t = "+t+" ================");
  
  
//  outputEnergy.println(sheet.Energy);
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
  
//  outputEnergy.flush(); // Writes the remaining data to the file
//  outputEnergy.close(); // Finishes the file
  
//  exit(); // Stops the program 
//}