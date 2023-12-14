/*
 By Student ID No. 21011025
 ---------------------------------------
  - This sketch code contains the Asteroid class used to create the asteroids
  - The main code is located in a seperate file called: Space_Game.pde
 
 This Asteroid class is responsible for:
  - Generating a random position, velocity and rotation speed for each new asteroid
  - Animating the position of the asteroid
  - Playing a collision sound if the asteroid collides with the player
  - Handling the collision interaction between the asteroid and the player
 */

class Asteroid {
  PVector pos; // Position of asteroid
  PVector vel; // Velocity of asteroid
  
  float rotateAngle = 0;
  float rotateSpeed = 0;
  
  PVector impactPos; // Position of asteroid inpact-site

  int timeElapsed = 0; // Time elapsed after the asteroid was created

  Boolean isOffScreen = true;
  Boolean isCollided = false;
  int animationFrame = 0;

  Asteroid() {
    // Generates random position
    float angle = random(0, 2 * PI);
    float x = myPlayer.pos.x + sin(angle) * width;
    float y = myPlayer.pos.y + cos(angle) * width;
    pos = new PVector(x, y);
    
    // Generates random velocity
    float dx = (myPlayer.pos.x + myPlayer.vel.x * FPS) - pos.x;
    float dy = (myPlayer.pos.y + myPlayer.vel.y * FPS) - pos.y;
    float velAngle = atan2(dx, dy);
    vel = new PVector(sin(velAngle) * width / FPS, cos(velAngle) * width / FPS);
    
    // Generates random rotation speed
    rotateSpeed = random(0.01, 0.2);

    // Adds this instance to the global asteroids array
    asteroids.add(this);
  }

  void Update() {
    timeElapsed++;
    rotateAngle += rotateSpeed;
    
    pos.add(vel); // Update position according to velocity

    // Removes asteroid once it leaves the screen
    int radius = 50;
    float relX = pos.x - myPlayer.pos.x + width / 2;
    float relY = pos.y - myPlayer.pos.y + height / 2;
    isOffScreen = (relX + radius < 0 || relX - radius > width || relY + radius < 0 || relY - radius > height);
    
    if (isOffScreen && (isCollided || timeElapsed > FPS * 5)) { 
      asteroids.remove(this);
    }

    // Player-Asteroid Collision
    if (pos.dist(myPlayer.pos) < 100) {
      isCollided = true;
      
      float dx = myPlayer.pos.x - pos.x;
      float dy = myPlayer.pos.y - pos.y;
      
      float impactAngle = atan2(dx, dy);
      
      float playerMass = 100;
      float asteroidMass = 1000;
      
      // Calculates new velocities to simulate collision
      float newVelX1 = (myPlayer.vel.x * (playerMass - asteroidMass) + (2 * asteroidMass * vel.x)) / (playerMass + asteroidMass);
      float newVelY1 = (myPlayer.vel.y * (playerMass - asteroidMass) + (2 * asteroidMass * vel.y)) / (playerMass + asteroidMass);
      // Update velocities
      myPlayer.vel = new PVector(newVelX1, newVelY1);
      vel.mult(-0.5);

      // Play collision sound
      if (!collisionSound.isPlaying()) {
        collisionSound.play();
      }
      
      // Records the position where the collision happened
      impactPos = new PVector(width / 2 - dx / 2, height / 2 - dy / 2);
      
      // Updates asteroid's position to ensure it does not collide with the player again
      pos.x = myPlayer.pos.x - sin(atan2(dx, dy)) * 125;
      pos.y = myPlayer.pos.y - cos(atan2(dx, dy)) * 125;
    }
  }
}
