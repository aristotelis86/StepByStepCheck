class Dashpot {
  
  //=================== Attributes ==================//
  float damping; // stiffness of spring 
  Particle p1, p2; // particle that it is connected to
  
  //================== Constructor =================//
  Dashpot( Particle a, Particle b,  float d) {
    p1 = a;
    p2 = b;
    
    damping = d;
  }
  
  //=============== Methods ======================//
  // Apply Forces on connected particles
  void applyAllForces() {
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
  
  // Update the damping coefficient if needed
  void UpdateDamping(float dd) {
    damping = dd;
  }

} // end of Dashpot class