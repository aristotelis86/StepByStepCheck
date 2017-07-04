//==================== CollisionSolver Class ==================//

//*** Depends on Particle, Spring and FlexibleSheet classes ***//

class CollisionSolver {
  
  //================ Attributes ================//
  int N, Ns, NFil;
  int [] NMass, NSpring;
  FlexibleSheet FSheet;
  float [] xold, yold, vxold, vyold;
  
  ArrayList<Particle> ListMass = new ArrayList<Particle>();
  ArrayList<Spring> ListSpring = new ArrayList<Spring>();
  
  Particle [] LocalMass;
  Spring [] LocalSpring;
  
  //================ Constructor ================//
  CollisionSolver(FlexibleSheet filament_) { // single Sheet
    
    FSheet = filament_;
    N = FSheet.numOfpoints;
    Ns = FSheet.numOfsprings;
    
    LocalMass = new Particle[N];
    LocalSpring = new Spring[Ns];
    
    LocalMass = FSheet.prtcl;
    LocalSpring = FSheet.springs;
    
    // For storing old configuration of filament
    xold = new float[N]; 
    yold = new float[N];
    vxold = new float[N]; 
    vyold = new float[N];    
  } // end of constructor #1
  
  CollisionSolver(FlexibleSheet [] filament_) { // multiple sheets
    NFil = filament_.length;
    
    NMass = new int[NFil];
    NSpring = new int[NFil];
    
    for (int j = 0; j < NFil; j++) {
      NMass[j] = filament_[j].numOfpoints;
      NSpring[j] = filament_[j].numOfsprings;
    }
    
    N = 0; 
    Ns = 0;
    for (int nm : NMass) N += nm;
    for (int ns : NSpring) Ns += ns;
    
    for (int j = 0; j < NFil; j++) {
      for (int i = 0; i < NMass[j]; i++) {
        ListMass.add(filament_[j].prtcl[i]);
      }
    }
    for (int j = 0; j < NFil; j++) {
      for (int i = 0; i < NSpring[j]; i++) {
        ListSpring.add(filament_[j].springs[i]);
      }
    }
    
    LocalMass = new Particle[N];
    LocalSpring = new Spring[Ns];
    
    for (int i = 0; i < N; i++) LocalMass[i] = ListMass.get(i);
    for (int i = 0; i < Ns; i++) LocalSpring[i] = ListSpring.get(i);
    
    
    // For storing old configuration of sheet
    xold = new float[N]; 
    yold = new float[N];
    vxold = new float[N]; 
    vyold = new float[N];
  } // end of constructor #2
  
  
  //======================== Methods ===========================//
  
  // Collision with boundaries of simulation
  void Boundary_collisions() {
    float coll_rad;
    
    for (Particle m : LocalMass) {
      coll_rad = m.diameter/2;
      if (m.position.x < coll_rad) {
        if (m.velocity.x > 0.01) {
          m.updatePosition(coll_rad, m.position.y);
          m.updateVelocity((-1)*m.velocity.x, m.velocity.y);
          m.updatePositionOLD();
          m.updateVelocityOLD();
        }
        else {
          m.updatePosition(coll_rad, m.position.y);
          m.updateVelocity(0, m.velocity.y);
          m.updatePositionOLD();
          m.updateVelocityOLD();
        }
          
      } 
      else if (m.position.x > width - coll_rad) {
        if (m.velocity.x > 0.01) {
          m.updatePosition(width - coll_rad, m.position.y);
          m.updateVelocity((-1)*m.velocity.x, m.velocity.y);
          m.updatePositionOLD();
          m.updateVelocityOLD();
        }
        else {
          m.updatePosition(width - coll_rad, m.position.y);
          m.updateVelocity(0, m.velocity.y);
          m.updatePositionOLD();
          m.updateVelocityOLD();
        }
      }
      if (m.position.y < coll_rad) {
        if (m.velocity.y > 0.01) {
          m.updatePosition(m.position.x, coll_rad);
          m.updateVelocity(m.velocity.x, (-1)*m.velocity.y);
          m.updatePositionOLD();
          m.updateVelocityOLD();
        }
        else {
          m.updatePosition(m.position.x, coll_rad);
          m.updateVelocity(m.velocity.x, 0);
          m.updatePositionOLD();
          m.updateVelocityOLD();
        }
      } 
      else if (m.position.y > height - coll_rad) {
        if (m.velocity.y > 0.01) {
          m.updatePosition(m.position.x, height - coll_rad);
          m.updateVelocity(m.velocity.x, (-1)*m.velocity.y);
          m.updatePositionOLD();
          m.updateVelocityOLD();
        }
        else {
          m.updatePosition(m.position.x, height - coll_rad);
          m.updateVelocity(m.velocity.x, 0);
          m.updatePositionOLD();
          m.updateVelocityOLD();
        }
      }
    }
  } // end of Boundary collisions
  
  
  // Collision of particles with each other
  void Mass_collisions() {
    float clearRad, piMass, pjMass;
    float Vxi, Vyi, Vxj, Vyj; 
    Particle pi, pj;
    
    for (int i = 0; i < N-1; i++) {
      pi = LocalMass[i];
      piMass = LocalMass[i].mass;
      for (int j = i+1; j < N; j++) {
        pj = LocalMass[j];
        pjMass = LocalMass[j].mass;
        
        clearRad = (pi.diameter + pj.diameter)/2; 
        
        if (pi.position.dist(pj.position)<=clearRad) {
          
          Vxi = (pi.velocity.x*(piMass-pjMass)/(piMass+pjMass)) + (2*pjMass/(piMass+pjMass))*pj.velocity.x;
          Vyi = (pi.velocity.y*(piMass-pjMass)/(piMass+pjMass)) + (2*pjMass/(piMass+pjMass))*pj.velocity.y;

          Vxj = (pj.velocity.x*(pjMass-piMass)/(piMass+pjMass)) + (2*pjMass/(piMass+pjMass))*pi.velocity.x;
          Vyj = (pj.velocity.y*(pjMass-piMass)/(piMass+pjMass)) + (2*pjMass/(piMass+pjMass))*pi.velocity.y;

          if ((!pi.fixed) && (!pj.fixed)) {
            pi.updateVelocity(Vxi, Vyi);
            pi.position = pi.positionOld.copy();
            pj.updateVelocity(Vxj, Vyj);
            pj.position = pj.positionOld.copy();
          }
          else if ((pi.fixed) && (!pj.fixed)) {
            pj.updateVelocity((-1)*pj.velocity.x,(-1)*pj.velocity.y);
            pj.position = pj.positionOld.copy();
          }
          else if ((!pi.fixed) && (pj.fixed)) {
            pi.updateVelocity((-1)*pi.velocity.x,(-1)*pi.velocity.y);
            pi.position = pi.positionOld.copy();
          }
          
        } // end if (distance)
      } // end for (j)
    } // end for (i)
    
  } // end of Mass collisions
  
} // end of Collision solver class