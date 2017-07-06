//==================== FlexibleSheet Class ==================//

//******** Depends on Particle and Spring classes **********//

class FlexibleSheet {
  //==================== Attributes ====================//
  // Physical Parameters
  float Length; // Initial length of filament
  float Mass; // Total mass of the filament
  float stiffness; // stiffness of each spring
  float damping; // damping coeff of each dashpot(included in springs)
  
  // Simulation related
  int numOfpoints; // Number of points used to distribute the mass
  float offsetX, offsetY; // position of 1st point
  boolean dampFlag; // using damping?
  boolean alignX; // is it aligned with x-axis
  
  // Dependancy from other objects
  Particle [] prtcl; // stores the particles of the system
  Spring [] springs; // stores the connecting springs
  
  // Parameterization of simulation variables
  int numOfsprings; // Number of springs used
  float segLength; // Unstretched length of each spring
  float diam; // radius of circles showing the points (only for design purposes)
  float pointMass; // mass of each point
 
  float Energy; // Total energy of the filament (kinetic, spring potential, gravity potential)
  
  float dtmax; // maximum value of the time step for numerical stability


  //==================== Constructor ======================//
  FlexibleSheet(float L, float M, int N, float stiff, boolean damp_, float xpos, float ypos, boolean align) {
    float [] x, y;

    Length = L;
    Mass = M;
    numOfpoints = N;
    stiffness = stiff;
    
    offsetX = xpos; // position-x of leading edge 
    offsetY = ypos; // position-y of leading edge

    alignX = align; // is principal direction of filament the x-axis?
    
    numOfsprings = N-1; // number of springs used
    segLength = Length/numOfsprings; // resting length of each spring
    diam = Length / (3*numOfpoints); // diameter of circles representing particles
    pointMass = Mass/N;
    
    // calculate the minimum required damping for numerical stability
    dampFlag = damp_;
    if (damp_) {
      damping = Determine_damping();
    }
    else damping = 0.0;
    
    if (diam>10) diam = 10; // constrain the size of each particle

    x = new float[numOfpoints];
    y = new float[numOfpoints];
    prtcl = new Particle[numOfpoints];
    springs = new Spring[numOfsprings];
    
    if (!alignX) {
      y[0] = offsetY;
      x[0] = offsetX;
      prtcl[0] = new Particle(x[0], y[0], pointMass, diam);
      for (int i = 1; i < numOfpoints; i++) {
        x[i] = x[i-1];
        y[i] = segLength + y[i-1];
        prtcl[i] = new Particle(x[i], y[i], pointMass, diam);
      }
    } else if (alignX) {
      y[0] = offsetY;
      x[0] = offsetX;
      prtcl[0] = new Particle(x[0], y[0], pointMass, diam);
      for (int i = 1; i < numOfpoints; i++) {
        y[i] = y[i-1];
        x[i] = segLength + x[i-1];
        prtcl[i] = new Particle(x[i], y[i], pointMass, diam);
      }
    }

    for (int i = 0; i < numOfsprings; i++) {
      springs[i] = new Spring( prtcl[i], prtcl[i+1], segLength, stiffness, damping);
    }
    
    // get the max time step
    dtmax = Determine_time_step();
    
  } // end of Constructor


  //======================== Methods =======================// 
  
  // Display   
  void display() {
    for (Spring s : springs) s.display();
    for (Particle p : prtcl) p.display();
  }
  
  
  // Apply internal Forces to particles
  void ApplyAllForces() {
    for (Particle p : prtcl) p.clearForce();
    for (Spring s : springs) s.applyAllForces();
  }

  
  // Calculate the total energy of the sheet 
  void calculate_Energy(PVector g, float refHeight) {
    float gravMag = g.mag();
    Energy = 0;
    for (int i=0; i < numOfpoints; i++) {
      Energy += pointMass * (.5*sq(prtcl[i].velocity.mag()));
    }
    for (int j=0; j < numOfsprings; j++) {
      Energy += .5*stiffness*sq(springs[j].getStretch());
    }
    for (int ij=0; ij < numOfpoints; ij++) {
      float myHeight = prtcl[ij].position.y - refHeight;
      Energy += pointMass * gravMag * myHeight;
    }
  }

  // Update the state of the sheet 
  void UpdateState(float [] Xnew, float [] Ynew, float [] VXnew, float [] VYnew) {
    for (int i = 0; i < numOfpoints; i++) {
      prtcl[i].updatePosition(Xnew[i], Ynew[i]);
      prtcl[i].updateVelocity(VXnew[i], VYnew[i]);
    }
  }
  
  // Determine relative positions based on the stiffness
  void Calculate_Stretched_Positions(PVector F) {
    
    float g = F.mag();
    float [] ll = new float[numOfsprings];
    PVector FDir = F.copy();
    FDir.normalize();
    
    for (int i = 0; i < numOfsprings; i++) {
      ll[i] = (float(numOfpoints) - float(i) - 1)*(pointMass*g/stiffness) + segLength;
      
      prtcl[i+1].position = PVector.add(prtcl[i].position, PVector.mult(FDir,ll[i]));
    }
    
  } // end of calculate_positions
  
  // Determine the size of the time step
  //float Determine_time_step() {
  //  //float Nn = float(numOfpoints);
  //  //float dt = PI*(3/Nn)*sqrt(pointMass/stiffness);
    
  //  dt = sqrt(pointMass/stiffness);
    
  //  return dt;
  //}
  float Determine_time_step() {
    float ReLam, ImLam, dt;
    float n = float(numOfpoints);
    
    float RootDet = 1-stiffness*pointMass*sq(Length)/(2*sq(damping)*sq(n));
    float fact = 4*damping*sq(n)/(pointMass*sq(Length));
    
    if (RootDet<0) {
      ReLam = -fact;
      ImLam = -fact*sqrt(-RootDet);
    }
    else {
      ReLam = fact*(-1-sqrt(RootDet));
      ImLam = 0.0;
    }
    
    dt = -2*ReLam/(sq(ReLam)+sq(ImLam));
    dt = dt - dt/100;
    return dt;
  }
  
  // Calculate damping coefficient for numerical purposes
  float Determine_damping() {
    float d = sqrt(stiffness*pointMass);
    return d;
  }
  
  // Update the damping coefficient if needed
  void UpdateDamping(float dd) {
    dampFlag = true;
    damping = dd;
    for (Spring ss : springs) ss.UpdateDamping(dd);
  }
  
  // Update the stiffness coefficient of all springs if needed
  void UpdateStiffness(float kk) {
    stiffness = kk;
    for (Spring ss : springs) ss.updateStiffness(kk);
    
    if (dampFlag) {
      float newDamp = Determine_damping();
      damping = newDamp;
      UpdateDamping(newDamp);
    }
    
    dtmax = Determine_time_step();
  }
  
  // Get the stretch ratio of the entire sheet (must be in a straight line though)
  float getStretchRatio() {
    PVector FilLength = PVector.sub(prtcl[0].position, prtcl[numOfpoints-1].position);
    float newLength = FilLength.mag();
    float stretchRatio = (newLength-Length)/Length;
    return stretchRatio;
  }
  
  //======================= Update Methods =========================//
  
  // Forward Euler Scheme
  void ForwardEuler(float dt, PVector ExtForce) {
    
    if (dt>dtmax) {
      println("WARNING dt constrained to maximum permitted:"+dtmax);
      dt = dtmax;
    }
    
    int N = numOfpoints;
    
    PVector [] OldPosition = new PVector[N];
    PVector [] OldVelocity = new PVector[N];
    PVector [] accel = new PVector[N];
    float pMass = pointMass;
    float [] xnew = new float[N];
    float [] ynew = new float[N];
    float [] vxnew = new float[N];
    float [] vynew = new float[N];
    
    // Store old state of sheet
    for (int i = 0; i < N; i++) {
      OldPosition[i] = prtcl[i].position.copy();
      OldVelocity[i] = prtcl[i].velocity.copy();
      prtcl[i].updatePositionOLD();
      prtcl[i].updateVelocityOLD();
    }
    
    // Apply Forces for this step
    ApplyAllForces();
    
    // calculate acceleration
    for (int i = 0; i < N; i++) {
      pMass = prtcl[i].mass;
      accel[i] = prtcl[i].force.copy();
      accel[i].div(pMass);
    }
    // accumulate any acceleration due to external forces
    for (int i = 0; i < N; i++) {
      accel[i].add(ExtForce);
    }
    
    // Find new state
    for (int i = 0; i < N; i++) {
      if (!prtcl[i].fixed) {
        xnew[i] = OldPosition[i].x + dt*OldVelocity[i].x;
        ynew[i] = OldPosition[i].y + dt*OldVelocity[i].y;
        vxnew[i] = OldVelocity[i].x + dt*accel[i].x;
        vynew[i] = OldVelocity[i].y + dt*accel[i].y;
      }
      else {
        xnew[i] = OldPosition[i].x;
        ynew[i] = OldPosition[i].y;
        vxnew[i] = OldVelocity[i].x;
        vynew[i] = OldVelocity[i].y;
      }
    }
    
    // Update the state of the filament
    UpdateState(xnew, ynew, vxnew, vynew);
  } // end of ForwardEuler
  
  
  // Trapezoid (Predictor-Corrector) Scheme
  void Trapezoid(float dt, PVector ExtForce) {
    
    if (dt>dtmax) {
      println("WARNING dt constrained to maximum permitted:"+dtmax);
      dt = dtmax;
    }
    
    int N = numOfpoints;
    
    float pMass = pointMass;
    PVector [] accelCurrent = new PVector[N];
    PVector [] accelPred = new PVector[N];
    
    PVector [] OldPosition = new PVector[N];
    PVector [] OldVelocity = new PVector[N];
    
    float [] xPred = new float[N];
    float [] yPred = new float[N];
    float [] vxPred = new float[N];
    float [] vyPred = new float[N];
    
    float [] xnew = new float[N];
    float [] ynew = new float[N];
    float [] vxnew = new float[N];
    float [] vynew= new float[N];
    
    // Store old state of sheet
    for (int i = 0; i < N; i++) {
      OldPosition[i] = prtcl[i].position.copy();
      OldVelocity[i] = prtcl[i].velocity.copy();
      if (!prtcl[i].fixed) {
        prtcl[i].updatePositionOLD();
        prtcl[i].updateVelocityOLD();
      }
    }
    
    // Apply Forces for this step
    ApplyAllForces();
    
    // calculate acceleration
    for (int i = 0; i < N; i++) {
      accelCurrent[i] = prtcl[i].force.copy();
      accelCurrent[i].div(pMass);
    }
    // accumulate any acceleration due to external forces
    for (int i = 0; i < N; i++) {
      accelCurrent[i].add(ExtForce);
    }
    
    // Calculate estimation
    for (int i = 0; i < N; i++) {
      if (!prtcl[i].fixed) {
        xPred[i] = OldPosition[i].x + dt*OldVelocity[i].x;
        yPred[i] = OldPosition[i].y + dt*OldVelocity[i].y;
        vxPred[i] = OldVelocity[i].x + dt*accelCurrent[i].x;
        vyPred[i] = OldVelocity[i].y + dt*accelCurrent[i].y;
      }
      else {
        xPred[i] = OldPosition[i].x;
        yPred[i] = OldPosition[i].y;
        vxPred[i] = OldVelocity[i].x;
        vyPred[i] = OldVelocity[i].y;
      }
    }
    // Update the state of the filament for the correction
    UpdateState(xPred, yPred, vxPred, vyPred);
    
    // Apply Forces for the correction
    ApplyAllForces();
    
    // calculate acceleration for the correction
    for (int i = 0; i < N; i++) {
      accelPred[i] = prtcl[i].force.copy();
      accelPred[i].div(pMass);
    }
    // accumulate any acceleration due to external forces
    for (int i = 0; i < N; i++) {
      accelPred[i].add(ExtForce);
    }
    
    // Calculate at the new state
    for (int i = 0; i < N; i++) {
      if (!prtcl[i].fixed) {
        xnew[i] = OldPosition[i].x + 0.5*dt*(OldVelocity[i].x+vxPred[i]);
        ynew[i] = OldPosition[i].y + 0.5*dt*(OldVelocity[i].y+vyPred[i]);
        vxnew[i] = OldVelocity[i].x + 0.5*dt*(accelCurrent[i].x+accelPred[i].x);
        vynew[i] = OldVelocity[i].y + 0.5*dt*(accelCurrent[i].y+accelPred[i].y);
      }
      else {
        xnew[i] = OldPosition[i].x;
        ynew[i] = OldPosition[i].y;
        vxnew[i] = OldVelocity[i].x;
        vynew[i] = OldVelocity[i].y;
      }
    }
    // Update the state of the filament for the correction
    UpdateState(xnew, ynew, vxnew, vynew);
  } // end of Trapezoid
  
  
  // Runge-Kutta 4th Order
  void RungeKutta4(float dt, PVector ExtForce) {
    
    if (dt>dtmax) {
      println("WARNING dt constrained to maximum permitted:"+dtmax);
      dt = dtmax;
    }
    
    int N = numOfpoints;
    float pMass = pointMass;
    
    // Runge-Kutta temp variables
    float [] x1, y1, x2, y2, x3, y3, x4, y4;
    float [] vx1, vy1, vx2, vy2, vx3, vy3, vx4, vy4;
    float [] ax1, ay1, ax2, ay2, ax3, ay3, ax4, ay4;  
    float [] xnew, ynew, vxnew, vynew;
    ///////////////////////////////
    
    PVector [] OldPosition = new PVector[N];
    PVector [] OldVelocity = new PVector[N];

    // Initialize intermediate arrays
    x1 = new float[N]; 
    y1 = new float[N];
    vx1 = new float[N]; 
    vy1 = new float[N];
    ax1 = new float[N]; 
    ay1 = new float[N];

    x2 = new float[N]; 
    y2 = new float[N];
    vx2 = new float[N]; 
    vy2 = new float[N];
    ax2 = new float[N]; 
    ay2 = new float[N];

    x3 = new float[N]; 
    y3 = new float[N];
    vx3 = new float[N]; 
    vy3 = new float[N];
    ax3 = new float[N]; 
    ay3 = new float[N];

    x4 = new float[N]; 
    y4 = new float[N];
    vx4 = new float[N]; 
    vy4 = new float[N];
    ax4 = new float[N]; 
    ay4 = new float[N];
    
    xnew = new float[N]; 
    ynew = new float[N];
    vxnew = new float[N]; 
    vynew = new float[N];
    
    // Store old state of filament
    for (int i = 0; i < N; i++) {
      OldPosition[i] = prtcl[i].position.copy();
      OldVelocity[i] = prtcl[i].velocity.copy();
      prtcl[i].updatePositionOLD();
      prtcl[i].updateVelocityOLD();
    }

    /////// Calculate step k1 /////////
    // Apply forces on particles
    ApplyAllForces();    

    for (int i = 0; i < N; i++) {
      x1[i] = OldPosition[i].x;
      y1[i] = OldPosition[i].y;
      vx1[i] = OldVelocity[i].x;
      vy1[i] = OldVelocity[i].y;
    }
    // calculate acceleration
    for (int i = 0; i < N; i++) {
      ax1[i] = prtcl[i].force.x/pMass; 
      ay1[i] = prtcl[i].force.y/pMass;
    }
    for (int i = 0; i < N; i++) {
      ax1[i] += ExtForce.x;
      ay1[i] += ExtForce.y;
    }

    /////// Calculate step k2 /////////
    // Apply forces on particles
    ApplyAllForces();

    for (int i = 0; i < N; i++) {
      if (!prtcl[i].fixed) {
        x2[i] = OldPosition[i].x + 0.5*vx1[i]*dt;
        y2[i] = OldPosition[i].y + 0.5*vy1[i]*dt;
        vx2[i] = OldVelocity[i].x + 0.5*ax1[i]*dt;
        vy2[i] = OldVelocity[i].y + 0.5*ay1[i]*dt;
      }
      else {
        x2[i] = OldPosition[i].x;
        y2[i] = OldPosition[i].y;
        vx2[i] = OldVelocity[i].x;
        vy2[i] = OldVelocity[i].y;
      } 
    }
    UpdateState(x2, y2, vx2, vy2);

    // calculate acceleration
    for (int i = 0; i < N; i++) {
      ax2[i] = prtcl[i].force.x/pMass; 
      ay2[i] = prtcl[i].force.y/pMass;
    }
    for (int i = 0; i < N; i++) {
      ax2[i] += ExtForce.x;
      ay2[i] += ExtForce.y;
    }

    /////// Calculate step k3 /////////
    // Apply forces on particles
    ApplyAllForces();

    for (int i = 0; i < N; i++) {
      if (!prtcl[i].fixed) {
        x3[i] = OldPosition[i].x + 0.5*vx2[i]*dt;
        y3[i] = OldPosition[i].y + 0.5*vy2[i]*dt;
        vx3[i] = OldVelocity[i].x + 0.5*ax2[i]*dt;
        vy3[i] = OldVelocity[i].y + 0.5*ay2[i]*dt;
      }
      else {
        x3[i] = OldPosition[i].x;
        y3[i] = OldPosition[i].y;
        vx3[i] = OldVelocity[i].x;
        vy3[i] = OldVelocity[i].y;
      }
    }
    UpdateState(x3, y3, vx3, vy3);

    // calculate acceleration
    for (int i = 0; i < N; i++) {
      ax3[i] = prtcl[i].force.x/pMass; 
      ay3[i] = prtcl[i].force.y/pMass;
    }
    for (int i = 0; i < N; i++) {
      ax3[i] += ExtForce.x;
      ay3[i] += ExtForce.y;
    }

    /////// Calculate step k4 /////////
    // Apply forces on particles
    ApplyAllForces();

    for (int i = 0; i < N; i++) {
      if (!prtcl[i].fixed) {
        x4[i] = OldPosition[i].x + vx3[i]*dt;
        y4[i] = OldPosition[i].y + vy3[i]*dt;
        vx4[i] = OldVelocity[i].x + ax3[i]*dt;
        vy4[i] = OldVelocity[i].y + ay3[i]*dt;
      }
      else {
        x4[i] = OldPosition[i].x;
        y4[i] = OldPosition[i].y;
        vx4[i] = OldVelocity[i].x;
        vy4[i] = OldVelocity[i].y;
      }
    }

    // calculate acceleration
    for (int i = 0; i < N; i++) {
      ax4[i] = prtcl[i].force.x/pMass; 
      ay4[i] = prtcl[i].force.y/pMass;
    }
    for (int i = 0; i < N; i++) {
      ax4[i] += ExtForce.x;
      ay4[i] += ExtForce.y;
    }


    ////// Final step - Update positions + velocities /////
    for (int i = 0; i < N; i++) {
      if (!prtcl[i].fixed) {
        xnew[i] = OldPosition[i].x + (dt/6)*(vx1[i] + 2*vx2[i] + 2*vx3[i] + vx4[i]);
        ynew[i] = OldPosition[i].y + (dt/6)*(vy1[i] + 2*vy2[i] + 2*vy3[i] + vy4[i]);

        vxnew[i] = OldVelocity[i].x + (dt/6)*(ax1[i] + 2*ax2[i] + 2*ax3[i] + ax4[i]);
        vynew[i] = OldVelocity[i].y + (dt/6)*(ay1[i] + 2*ay2[i] + 2*ay3[i] + ay4[i]);
      }
      else {
        xnew[i] = OldPosition[i].x;
        ynew[i] = OldPosition[i].y;
        vxnew[i] = OldVelocity[i].x;
        vynew[i] = OldVelocity[i].y;
      }
    }
    UpdateState(xnew, ynew, vxnew, vynew);
  } // end of update method RK4
  

} //=========== end of FlexibleSheet class ===============