///*******************************************************************
//// Testing CollisionSolver Class  //
//// Test Detecting collision between particles and particle-spring.
//// - 
//*******************************************************************/


////--------------------- INPUTS Section ---------------------------//
//float L1 = 100; // total (unstretched) length of sheet
//float M1 = 6; // total mass of sheet
//int N1 = 6; // number of control points used to represent the sheet
//float stiff1 = 100; // stiffness of each spring in the sheet (overall stiffness = value given/N)
//boolean damp1 = true; // flag to include damping in the simulation (numerical reasons mostly)
//boolean alignX1 = false; // should it be aligned with x-axis
//float offsetX1 = 400, offsetY1 = 30; // position of leading point

//float L2 = 300; // total (unstretched) length of sheet
//float M2 = 60; // total mass of sheet
//int N2 = 31; // number of control points used to represent the sheet
//float stiff2 = 2000; // stiffness of each spring in the sheet (overall stiffness = value given/N)
//boolean damp2 = true; // flag to include damping in the simulation (numerical reasons mostly)
//boolean alignX2 = true; // should it be aligned with x-axis
//float offsetX2 = 325, offsetY2 = 400; // position of leading point


//PVector gravity = new PVector(0,10);

//float t;
//float dt;
////int Nfil = 2; // number of sheets to create (if needed)

////--------------------- END of INPUTS Section ---------------------------//
////FlexibleSheet sheet, sheet2;
//FlexibleSheet [] sheet;
//CollisionSolver Collide;

//PrintWriter outputPos; // declare output file for positions
//PrintWriter outputVel; // declare output file for velocities
//PrintWriter outputPosOLD; // declare output file for positions
//PrintWriter outputVelOLD; // declare output file for velocities
//PrintWriter outputForce; // declare output file for forces
//PrintWriter outputEnergy; // declare output file for positions

//float xDrive, yDrive, vxDrive, vyDrive;

////--------------------------- Setup Section ---------------------------//
//void setup() {
//  size(800, 600); // window size
//  frameRate(10);
  
//  sheet = new FlexibleSheet[2]; 
  
//  sheet[0] = new FlexibleSheet(L1, M1, N1, stiff1, damp1, offsetX1, offsetY1, alignX1);
//  sheet[0].prtcl[0].makeFixed();
//  sheet[0].Calculate_Stretched_Positions(gravity);
  
//  sheet[1] = new FlexibleSheet(L2, M2, N2, stiff2, damp2, offsetX2, offsetY2, alignX2);
//  sheet[1].prtcl[0].makeFixed();
//  sheet[1].prtcl[N2-1].makeFixed();
  
//  Collide = new CollisionSolver(sheet);
  
//  float dt1 = sheet[0].Determine_time_step();
//  float dt2 = sheet[1].Determine_time_step();
  
//  println(dt1);
//  println(dt2);
  
//  if (dt1<dt2) dt = dt1;
//  else dt=dt2;
  
//  println(dt);
  
//  float Damp1 = sheet[0].damping;
//  //float Damp2 = sheet[1].damping;
  
//  outputPos = createWriter("positions.txt");
//  outputPos.println("=========== Positions ==========");
//  outputPos.println("Length: "+L1+" Mass: "+M1+" Points: "+N1+" Stiffness: "+stiff1+" Damping: "+Damp1+" dt: "+dt);
  
//  outputVel = createWriter("velocities.txt");
//  outputVel.println("=========== Velocities ==========");
//  outputVel.println("Length: "+L1+" Mass: "+M1+" Points: "+N1+" Stiffness: "+stiff1+" Damping: "+Damp1+" dt: "+dt);
  
//  outputPosOLD = createWriter("positionsOLD.txt");
//  outputPosOLD.println("=========== Positions Old ==========");
//  outputPosOLD.println("Length: "+L1+" Mass: "+M1+" Points: "+N1+" Stiffness: "+stiff1+" Damping: "+Damp1+" dt: "+dt);
  
//  outputVelOLD = createWriter("velocitiesOLD.txt");
//  outputVelOLD.println("=========== Velocities Old ==========");
//  outputVelOLD.println("Length: "+L1+" Mass: "+M1+" Points: "+N1+" Stiffness: "+stiff1+" Damping: "+Damp1+" dt: "+dt);
  
//  outputForce = createWriter("forces.txt");
//  outputForce.println("=========== Forces ==========");
//  outputForce.println("Length: "+L1+" Mass: "+M1+" Points: "+N1+" Stiffness: "+stiff1+" Damping: "+Damp1+" dt: "+dt);
  
//  outputEnergy = createWriter("energy.txt");
//  outputEnergy.println("=========== Energy ==========");
//  outputEnergy.println("Length: "+L1+" Mass: "+M1+" Points: "+N1+" Stiffness: "+stiff1+" Damping: "+Damp1+" dt: "+dt);
  
//} // end of setup


////--------------------------- Draw Section ---------------------------//
//void draw() {
//  background(25); // color of background
//  fill(0, 225, 225); // color of text for timer
//  textSize(32); // text size of timer
//  text(t, 10, 30); // position of timer
  
//  // Display
//  for (FlexibleSheet FS : sheet) FS.display();
  
//  // Write info
//  sheet[0].calculate_Energy(gravity, height);
//  Write_Info();
  
//  // Update
//  for (FlexibleSheet FS : sheet) FS.Trapezoid(dt, gravity);
//  Collide.SolveCollisions();
  
//  if (t>3) sheet[0].prtcl[0].makeFree();
  
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
  
  
//  outputEnergy.println(sheet[0].Energy);
//  for (Particle PP : sheet[0].prtcl) {
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