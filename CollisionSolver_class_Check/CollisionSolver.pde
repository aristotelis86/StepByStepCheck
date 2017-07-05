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
  
  
  
  // Detect Boundary Collisions
  void DetectBoundaryCollision() {
    float clearRad;
    
    for (int i=0; i < N; i++) {
      Particle P = LocalMass[i];
      clearRad = P.diameter/2;
      
      if ((P.position.x < clearRad) || (P.position.x > width - clearRad)) {
        println("Particle "+i+" colliding with vertical walls.");
        noLoop();
      }
      if ((P.position.y < clearRad) || (P.position.y > height - clearRad)) {
        println("Particle "+i+" colliding with horizontal walls.");
        P.CollisionDisplay();
        noLoop();
      }
    } // end for loop over particles

  } // end of Detect Boundary Collisions
  
  // Detect Particle-Particle Collisions
  void DetectPointPointCollision() {
    float clearRad;
    
    for (int i = 0; i < N-1; i++) {
      Particle pi = LocalMass[i];
      
      for (int j = i+1; j < N; j++) {
        Particle pj = LocalMass[j];
        
        clearRad = (pi.diameter + pj.diameter)/4;
        
        if (pi.distance2point(pj)<=clearRad) {
          println("Particle "+i+" is colliding with particle "+j);
          println(pi.diameter);
          println(pj.diameter);
          println(pi.distance2point(pj));
          pi.CollisionDisplay();
          pj.CollisionDisplay();
          noLoop();
        }
      } // end for loop over particles #2
    } // end for loop over particles #1
    
  } // end of Detect Point-Point Collisions
  
  
  // Detect Particle-Spring Collisions
  void DetectPointEdgeCollision() {
    float velThreshold = 0.01;
    
    for (int i = 0; i<N; i++) {
      Particle p = LocalMass[i];
      for (int j=0; j<Ns; j++) {
        Spring s = LocalSpring[j];
        
        // continue only if the particle is not connected to the current spring
        if ((p!=s.p1) && (p!=s.p2)) {
          PVector C0 = p.positionOld.copy();
          PVector C1 = p.position.copy();
          
          PVector P0 = s.p1.positionOld.copy();
          PVector P1 = s.p1.position.copy();
          
          PVector Q0 = s.p2.positionOld.copy();
          PVector Q1 = s.p2.position.copy();
          
          PVector C0P0 = PVector.sub(C0,P0);
          PVector C0Q0 = PVector.sub(C0,Q0);
          
          PVector C1P1 = PVector.sub(C1,P1);
          PVector C1Q1 = PVector.sub(C1,Q1);
          
          PVector crossOld = C0P0.cross(C0Q0);
          PVector crossNew = C1P1.cross(C1Q1);
          
          if (crossOld.z*crossNew.z<0) {
            boolean col;
            col = Point_Edge_Penetration(P0, P1, Q0, Q1, C0, C1);
            if (col) {
              println("Particle "+i+" is colliding with spring "+j);
              p.CollisionDisplay();
              s.CollisionDisplay();
              noLoop();
            }
          }
          
        } // end if check for particle belonging to the spring
      } // end of loop over springs
    } // end of loop over particles
    
  } // end of Detect Point-Edge Collisions
  
  // Detect Point penetrating line segment
  boolean Point_Edge_Penetration(PVector p0_, PVector p1_, PVector q0_, PVector q1_, PVector c0_, PVector c1_) {
    
    boolean penetFlag = false;
    float [] T = new float[2];
    float t, s;
    
    PVector C0P0 = PVector.sub(c0_,p0_);
    PVector Q0P0 = PVector.sub(q0_,p0_);
    
    PVector C1C0P1P0 = PVector.sub(PVector.add(c1_,p0_),PVector.add(c0_,p1_));
    PVector Q1Q0P1P0 = PVector.sub(PVector.add(q1_,p0_),PVector.add(q0_,p1_));
    
    PVector A0 = C1C0P1P0.cross(Q1Q0P1P0);
    PVector A11 = C1C0P1P0.cross(Q0P0);
    PVector A12 = C0P0.cross(Q1Q0P1P0);
    PVector A1 = PVector.add(A11,A12);
    PVector A2 = C1C0P1P0.cross(Q1Q0P1P0);
    
    T = SolveQuadratic(A2.z,A1.z,A0.z);
    
    for (int ii=0; ii<2; ii++) {
      t = T[ii];
      if ((t>=0) && (t<=1)) {
        PVector pt = PVector.add(p0_,PVector.mult(PVector.sub(p1_,p0_),t));
        PVector qt = PVector.add(q0_,PVector.mult(PVector.sub(q1_,q0_),t));
        PVector ct = PVector.add(c0_,PVector.mult(PVector.sub(c1_,c0_),t));
        
        s = PVector.dot(PVector.sub(ct,pt),PVector.sub(qt,pt))/PVector.dot(PVector.sub(qt,pt),PVector.sub(qt,pt));
        
        if ((s>=0) && (s<=1)) penetFlag = true;
        else penetFlag = false;
    
      } // end if 0<t<1
      
    }
    
    return penetFlag;
  } // end of point-edge penetration detection method
  
  
  // Solve Quadratic equation given the coefficients
  float [] SolveQuadratic(float a, float b, float c) {
    
    float [] Tf = new float[2]; 
    
    float d = sq(b) - 4*a*c;
    
    if ((a==0) && (b!=0)) {
      Tf[0] = -c/b;
      Tf[1] = -c/b;
    }
    else if ((a==0) && (b==0)) {
      Tf[0] = 0.0;
      Tf[1] = 0.0;
    }
    else {
      if (d<0) {
        Tf[0] = -999;
        Tf[1] = -999;
      }
      else if (d==0) {
        Tf[0] = -b/(2*a);
        Tf[1] = -b/(2*a);
      }
      else {
        Tf[0] = (-b+sqrt(d))/(2*a);
        Tf[1] = (-b-sqrt(d))/(2*a);
      }
    }
    
    if (Tf[0]>Tf[1]) {
      float temp = Tf[0];
      Tf[0] = Tf[1];
      Tf[1] = temp;
    }
    
    return Tf;
  } // end of quadratic solver
  
} // end of Collision solver class