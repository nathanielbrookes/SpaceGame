/*
 By Student ID No. 21011025
 ---------------------------------------
  - This sketch code contains classes used to create the rocket thruster particles
  - The main code is located in a seperate file called: KeeleInteraction_21011025.pde
 
 The ThrusterParticleSystem class is responsible for:
  - Creating new particles, each with its own random wind force and lifespan
  
 The Particle class is responsible for:
  - Generating a random velocity for each new particle
  - Updating the velocity according the current forces applied
 */

class ThrusterParticleSystem {
  ArrayList<Particle> particles = new ArrayList<Particle>();
  
  PVector pos; // Position
  float lifeSpan = 0; // Controls how long each particle will last
  int mode = 0;
  
  ThrusterParticleSystem(float x, float y, float inputLifeSpan, int inputMode) {
    pos = new PVector(x, y);
    
    lifeSpan = inputLifeSpan;
    mode = inputMode;
  }
  
  void Update() {
    for (int i = 0; i < particles.size(); i++) {
      Particle element = particles.get(i);
      element.Update();
      
      if (element.lifeSpan <= 0) {
         particles.remove(element);
      }
    }
    
    if (mousePressed) {
      for (int i = 0; i < 10; i++) {
        Particle element = new Particle(this.pos.x, this.pos.y, this.lifeSpan);
        
        if (this.mode == 0) {
           // Left Thruster:
           
           element.windForce = element.AddForce(new PVector(2, 0)); 
           
           if ((width / 2) - mouseX > 0) {
             element.lifeSpan = min(abs((width / 2) - mouseX), height / 2) / 15;
           }
           else {
              element.lifeSpan = 0; 
           }
        }
        else if (this.mode == 1) {
          // Right Thruster: 
          
          element.windForce = element.AddForce(new PVector(-2, 0)); 
           
           if ((width / 2) - mouseX <= 0) {
             element.lifeSpan = min(abs((width / 2) - mouseX), height / 2) / 15;
           }
           else {
              element.lifeSpan = 0; 
           }
        }
        else if (this.mode == 2) {
          // Up Thruster:  
          
          element.windForce = element.AddForce(new PVector(0, -2)); 
           
           if ((height / 2) - mouseY < 0) {
             element.lifeSpan = min(abs((height / 2) - mouseY), height / 2) / 15;
           }
           else {
             element.lifeSpan = 0; 
           }
        }
        else if (this.mode == 3) {
          // Down Thruster:  
          
          element.windForce = element.AddForce(new PVector(0, 2)); 
           
           if ((height / 2) - mouseY >= 0) {
             element.lifeSpan = min(abs((height / 2) - mouseY), height / 2) / 15;
           }
           else {
             element.lifeSpan = 0; 
           }
        }
         
        this.particles.add(element);
      }
    } 
  }
}

class Particle {
  PVector pos; // Position of particle
  PVector vel; // Velocity of particle
  
  float terminalVelocity = 5;
  float friction = 0.99;
  
  int fillR = 129, fillG = 217, fillB = 241;
  
  float lifeSpan = 0;

  ArrayList<PVector> forces = new ArrayList<PVector>();
  PVector windForce;

  Particle(float x, float y, float inputLifeSpan) {
    pos = new PVector(x, y);
    lifeSpan = random(0, inputLifeSpan);

    // Initialise particle with small, random velocity
    vel = new PVector(random(-1, 1), random(-1, 1));
  }

  void Update() {
    // Restrict particle velocity
    vel.x = max(min(vel.x, terminalVelocity), -terminalVelocity);
    vel.y = max(min(vel.y, terminalVelocity), -terminalVelocity);

    vel.mult(friction);  // Apply friction force
    
    // Update velocity according to the forces currently applied to the particle
    for (int i = 0; i < forces.size(); i++) {
      vel.add(forces.get(i)); 
    }

    pos.add(vel); // Update position according to velocity
    
    this.lifeSpan -= 1;
  }

  PVector AddForce(PVector force) {
    forces.add(force); 
    return force;
  }

  void RemoveForce(PVector force) {
    this.forces.remove(force);
  }
}
