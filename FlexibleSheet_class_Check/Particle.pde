//==================== Particle Class ==================//

//**************** No Dependancies  ********************//

class Particle {
  //================= Attributes ====================//
  // Physical
  PVector position;
  PVector positionOld;
  PVector velocity;
  PVector velocityOld;
  PVector force;
  float mass;
  
  // Display
  boolean fixed; // fix the particle at its location
  float diameter; // 
  color c;
  
  
  //================= Constructor ====================//
  Particle(float tempX, float tempY, float m, float r) {
    position = new PVector(tempX, tempY);
    velocity = new PVector(0, 0);
    force = new PVector(0, 0);
    mass = m;
    
    fixed = false;
    diameter = r;
    c = color(random(25), random(200,255), random(25));
    
    positionOld = position.copy();
    velocityOld = velocity.copy();
  }
  
  
  //================= Methods =====================//
  // Update the position of the particle
  void updatePosition(float xpos, float ypos) {
    position.x = xpos;
    position.y = ypos;
  }
  
  // Update the velocity of the particle
  void updateVelocity(float vx, float vy) {
    velocity.x = vx;
    velocity.y = vy;
  }
  
  // Clear any forces acting on the particle
  void clearForce() {
    force.mult(0);
  }
  
  // Accumulate all the forces acting on the particle
  void applyForce(PVector FF) {
    force.add(FF);
  }
  
  // Display the particle
  void display() {
    noStroke();
    fill(c);
    ellipse(position.x, position.y, diameter, diameter);
  }
  
  // Make the particle free of constraints
  void makeFree() {
    fixed = false;
  }
  
  // Constrain the particle at its location
  void makeFixed() {
    fixed = true;
  }
  
  // Calculate distance of the particle from other particles
  float distance2point(Particle otherP) {
    float dist = position.dist(otherP.position);
    float myRad = diameter/2;
    float otherRad = otherP.diameter/2;
    dist -= (myRad+otherRad);
    return dist;
  }
  
  // Update the position of the particle
  void updatePositionOLD() {
    positionOld = position.copy();
  }
  
  // Update the velocity of the particle
  void updateVelocityOLD() {
    velocityOld = velocity.copy();
  }
  
} 