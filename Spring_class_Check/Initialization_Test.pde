///*******************************************************************
//// Testing Spring Class  //
//// Constructor, display and stiffness update are tested.
//// All 3 components are working as expected. 
//*******************************************************************/


////--------------------- INPUTS Section ---------------------------//
//float stiffness = 100;
//float restLength = 50;

//float t = 0; // timer
//float dt = 0.1; // time step size
////--------------------- END of INPUTS Section ---------------------------//

//Spring s;
//Particle p1, p2;

////--------------------------- Setup Section ---------------------------//
//void setup() {
//  size(800, 600); // window size
  
//  // Two particles with a distance of 100 units (pixels)
//  p1 = new Particle(400, 100, 10, 10);
//  p2 = new Particle(450, 100+sqrt(3)*50, 10, 10);
  
//  s = new Spring(p1, p2, restLength, stiffness);
  
//} // end of setup


////--------------------------- Draw Section ---------------------------//
//void draw() {
//  background(25); // color of background
//  fill(0, 225, 225); // color of text for timer
//  textSize(32); // text size of timer
//  text(t, 10, 30); // position of timer
  
//  // Display
//  p1.display();
//  p2.display();
//  s.display();
  
//  // Write info
//  println("Current spring stiffness: "+s.stiffness);
  
//  if (t>.3) s.updateStiffness(stiffness+50);
  
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