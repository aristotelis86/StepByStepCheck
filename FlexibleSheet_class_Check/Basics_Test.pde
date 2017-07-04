///*******************************************************************
//// Testing FlexibleSheet Class  //
//// Basic test for creating, displaying, calculating stretch ratio and updating of stiffness and damping.
//// - Test is successful. Updating the stiffnes though, should incur a different maximum time step size, which is NOT tested here.
//*******************************************************************/


////--------------------- INPUTS Section ---------------------------//
//float L = 200; // total (unstretched) length of sheet
//float M = 5; // total mass of sheet
//int N = 11; // number of control points used to represent the sheet
//float stiff = 100; // stiffness of each spring in the sheet (overall stiffness = value given/N)
//boolean damp = true; // flag to include damping in the simulation (numerical reasons mostly)
//boolean alignX = false; // should it be aligned with x-axis

//float offsetX = 400, offsetY = 30; // position of leading point

//float t;
//float dt = 0.1;
////int Nfil = 2; // number of sheets to create (if needed)
////--------------------- END of INPUTS Section ---------------------------//
//FlexibleSheet sheet;
////FlexibleSheet [] sheet;

//PrintWriter outputPos; // declare output file for positions


////--------------------------- Setup Section ---------------------------//
//void setup() {
//  size(800, 600); // window size
  
//  sheet = new FlexibleSheet(L, M, N, stiff, damp, offsetX, offsetY, alignX);
  
  
//  outputPos = createWriter("positions.txt");
//  outputPos.println("=========== Positions ==========");
//  outputPos.println("Mass: "+M+" Points: "+N);
  
//} // end of setup


////--------------------------- Draw Section ---------------------------//
//void draw() {
//  background(25); // color of background
//  fill(0, 225, 225); // color of text for timer
//  textSize(32); // text size of timer
//  text(t, 10, 30); // position of timer
  
//  // Display
//  sheet.display();
  
//  // Write info
//  Write_Info();
//  println("Stretch Ratio="+sheet.getStretchRatio());
//  println("Current Stiffness="+sheet.stiffness);
//  println("Current Damping="+sheet.damping);
  
//  // Update
//  if (t>0.3) sheet.prtcl[N-1].position.y += 10;
//  if (t>0.3) sheet.UpdateStiffness(stiff+100);
//  if (t>0.5) sheet.UpdateDamping(sheet.damping+5);
  
  
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
  
//  for (Particle PP : sheet.prtcl) outputPos.println(PP.position.x + " " + PP.position.y);
  
//}

//// Gracefully terminate writing...
//void keyPressed() {
  
//  outputPos.flush(); // Writes the remaining data to the file
//  outputPos.close(); // Finishes the file
  
//  exit(); // Stops the program 
//}