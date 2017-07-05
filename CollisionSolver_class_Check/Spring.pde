//==================== Spring Class ==================//

//************ Depends on Particle Class *************//
//**** Extended from original to include dashpot ****//

class Spring {
  //========== Attributes - Physical ============//
  float stiffness; // stiffness of spring
  float restLength; // resting length 
  float damping; // damping for simulating the presence of dashpot
  Particle p1, p2; // particle that it is connected to
  
  //=============== Constructor =================//
  Spring( Particle a, Particle b, float r, float s, float d) {
    p1 = a;
    p2 = b;
    
    stiffness = s;
    restLength = r;
    damping = d;
  }
  
  
  //=================== Methods ================//
  // Display
  void display(){
    strokeWeight(1);
    stroke(255);
    line(p1.position.x, p1.position.y, p2.position.x, p2.position.y);
  }
  
  // Display when into collision
  void CollisionDisplay(){
    strokeWeight(1);
    stroke(255, 0, 0);
    line(p1.position.x, p1.position.y, p2.position.x, p2.position.y);
  }
  
  // Apply Forces on connected particles
  void applyAllForces() {
    // apply force due to spring
    PVector springDir = PVector.sub(p1.position, p2.position);
    
    float stretch = springDir.mag();
    stretch -= restLength;
    
    springDir.normalize();
    PVector Tension = springDir.mult(-stiffness * stretch);
    p1.force.add(Tension);
    Tension.mult(-1);
    p2.force.add(Tension);
    
    // apply force due to dashpot
    PVector DashDir = PVector.sub(p1.position, p2.position);
    DashDir.normalize();
    
    PVector RelatVel = PVector.sub(p1.velocity, p2.velocity);
    
    float DampMag = PVector.dot(RelatVel, DashDir);
    
    DampMag = (-1)*DampMag*damping;
    
    DashDir.mult(DampMag);
    
    p1.force.add(DashDir);
    DashDir.mult(-1);
    p2.force.add(DashDir);
    
  }
  
  // Get the stretch of the spring
  float getStretch() {
    PVector SpringDir = PVector.sub(p1.position, p2.position);
    float stretch = SpringDir.mag();
    stretch -= restLength;
    
    return stretch;
  }
  
  // Assign different stiffness from the one constructed
  void updateStiffness(float kk) {
    stiffness = kk;
  }
  
  // Update the damping coefficient if needed
  void UpdateDamping(float dd) {
    damping = dd;
  }
  
}