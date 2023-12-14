/*
 By Student ID No. 21011025
 ---------------------------------------
  - This sketch code contains the Planet class used to create the planets, and the Element class used to create the elements
  - The main code is located in a seperate file called: KeeleInteraction_21011025.pde
 
 The Planet class is responsible for:
  - Generating elements, each with its own random position and type
  
 The Element class is responsible for:
  - Checking if the element is near the player
  - Animating the element towards the player once they are within close range
  - Playing a collect sound when the item reaches the player
 */

class Planet {
  PVector pos; // Position of planet
  int type = 0; // Type of planet
  Element[] elements = new Element[3]; // Elements that are located on the planet

  Planet(float x, float y, int inputType) {
    pos = new PVector(x, y);
    type = inputType;
    
    if (type != 4) { // If planet is not Earth
      for (int i = 0; i < elements.length; i++) {
        float randX = random(pos.x - 130, pos.x + 130);
        float randY = random(pos.y - 130, pos.y + 130);
        
        elements[i] = new Element(randX, randY, round(random(0, elementImages.length - 1)));
      }
    } 

    // Adds this instance to the global planets array
    planets.add(this);
  }
}

class Element {
  PVector pos; // Position of element
  PVector vel; // Velocity of element
  
  int type = 0; // Type of element
  
  Boolean collected = false;
  float distanceFromPlayer = 1E6;

  Element(float x, float y, int inputType) {
    pos = new PVector(x, y);
    vel = new PVector(0, 0);
    
    type = inputType;
  }
  
  void Update() {
    distanceFromPlayer = pos.dist(myPlayer.pos);
    
    // Animates towards the player once its close enough
    if (distanceFromPlayer < 150) {
        vel.x = (myPlayer.pos.x - pos.x) / distanceFromPlayer * 25;
        vel.y = (myPlayer.pos.y - pos.y) / distanceFromPlayer * 25;
    
        if (distanceFromPlayer < 50) {
           // Player has collected item
           collected = true;
           collectSound.play();
        }
    }
    
    pos.add(vel); // Update position according to velocity
  }
}
