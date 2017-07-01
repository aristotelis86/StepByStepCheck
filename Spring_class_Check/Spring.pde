//==================== Spring Class ==================//

//************ Depends on Particle Class *************//

class Spring {
  //========== Attributes - Physical ============//
  float stiffness; // stiffness of spring
  float restLength; // resting length 
  Particle p1, p2; // particle that it is connected to
  
  //=============== Constructor =================//
  Spring( Particle a, Particle b, float r, float s) {
    p1 = a;
    p2 = b;
    
    stiffness = s;
    restLength = r;
  }
  
  
  //=================== Methods ================//
  // Display
  void display(){
    strokeWeight(1);
    stroke(255);
    line(p1.position.x, p1.position.y, p2.position.x, p2.position.y);
  }
  
  // Apply Forces on connected particles
  void applyAllForces() {
    PVector springDir = PVector.sub(p1.position, p2.position);
    
    float stretch = springDir.mag();
    stretch -= restLength;
    
    springDir.normalize();
    PVector Tension = springDir.mult(-stiffness * stretch);
    p1.force.add(Tension);
    Tension.mult(-1);
    p2.force.add(Tension);
    
  }
  
  // Get the stretch of the spring
  float getStretch() {
    PVector Tension = PVector.sub(p1.position, p2.position);
    float stretch = Tension.mag();
    stretch -= restLength;
    
    return stretch;
  }
  
  // Assign different stiffness from the one constructed
  void updateStiffness(float kk) {
    stiffness = kk;
  }
  
}