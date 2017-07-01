///*******************************************************************
//// Testing Particle Class  //
//// Distance function test. Particles report their distance from other particles considering their radius.
//// The test is successful in general. The only problem is when asked to compare against itself, where a negative value is reported, indicating collision.
//*******************************************************************/


////--------------------- INPUTS Section ---------------------------//


////--------------------- END of INPUTS Section ---------------------------//


//Particle p1, p2, p3;

////--------------------------- Setup Section ---------------------------//
//void setup() {
//  size(800, 600); // window size
  
//  p1 = new Particle(400, 100, 10, 10);
//  p2 = new Particle(450, 100+sqrt(3)*50, 10, 10);
//  p3 = new Particle(350, 100+sqrt(3)*50, 10, 10);
  
  
//} // end of setup


////--------------------------- Draw Section ---------------------------//
//void draw() {
//  background(25); // color of background
  
//  // Display
//  p1.display();
//  p2.display();
//  p3.display();
  
//  // Write info
//  println("p1->p2: "+p1.distance2point(p2));
//  println("p1->p3: "+p1.distance2point(p3));
  
//  println("p2->p1: "+p2.distance2point(p1));
//  println("p2->p3: "+p2.distance2point(p3));
  
//  println("p3->p2: "+p3.distance2point(p2));
//  println("p3->p1: "+p3.distance2point(p1));
  
//  println("p1->p1: "+p1.distance2point(p1));
  
//  noLoop();
//} // end Draw()


////-------------------------- Additional Utilities ---------------------//
//void mousePressed() {
//  loop();
//}

//void mouseReleased() {
//  noLoop();
//}