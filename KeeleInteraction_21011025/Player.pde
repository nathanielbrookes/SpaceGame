/*
 By Student ID No. 21011025
 ---------------------------------------
  - This sketch code contains the Player class used to create the player
  - The main code is located in a seperate file called: KeeleInteraction_21011025.pde
 
 This Player class is responsible for:
  - Updating the velocity according the current forces applied
 */

class Player {
  PVector pos; // Position of player
  PVector vel; // Velocity of player

  float terminalVelocity = 15;
  float frictionMultiplier = 0.99; // Friction force applied relative to the player's velocity
  
  ArrayList<PVector> forces = new ArrayList<PVector>();

  Boolean hasWon = false;
  Boolean isDead = false;
  Boolean hasCollectedAllElements = false;

  Player(float x, float y) {
    pos = new PVector(x, y);
    vel = new PVector(0, 0);
  }

  void Update() {
    // Restrict player velocity
    vel.x = max(min(vel.x, terminalVelocity), -terminalVelocity);
    vel.y = max(min(vel.y, terminalVelocity), -terminalVelocity);
    
    vel.mult(frictionMultiplier); // Apply friction force
    
    // Update velocity according to the forces currently applied to the player
    for (int i = 0; i < forces.size(); i++) {
       vel.add(forces.get(i)); 
    }

    pos.add(vel); // Update position according to velocity
  }
  
  PVector AddForce(PVector force) {
    forces.add(force); 
    return force;
  }

  void RemoveForce(PVector force) {
    this.forces.remove(force);
  }
}
