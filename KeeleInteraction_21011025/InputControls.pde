/*
 By Student ID No. 21011025
 ---------------------------------------
  - This sketch code contains the functions used to handle keyboard and mouse input events
  - The main code is located in a seperate file called: KeeleInteraction_21011025.pde
 */

PVector MovementForce = new PVector(0, 0); // Force applied to move the player
float mouseRadius = height / 2;

void mousePressed() {
  // Calculates the movement force based on the location of the mouse cursor
  MovementForce.x = max(min((mouseX - width / 2) / mouseRadius, 1), -1);
  MovementForce.y = max(min((mouseY - height / 2) / mouseRadius, 1), -1);
  MovementForce = MovementForce.div(3);
  MovementForce = myPlayer.AddForce(MovementForce);
  
  // Sets volume of thruster sound according to the mouse position
  maxThrusterSoundVolume = min(1, new PVector(width / 2, height / 2).dist(new PVector(mouseX, mouseY)) / new PVector(0, 0).dist(new PVector(width / 2, height / 2)));
  thrusterSound.amp(thrusterSoundVolume);
}

void mouseDragged() {
  // Calculates the movement force based on the location of the mouse cursor
  MovementForce.x = max(min((mouseX - width / 2) / mouseRadius, 1), -1);
  MovementForce.y = max(min((mouseY - height / 2) / mouseRadius, 1), -1);
  MovementForce = MovementForce.div(3);
  
  // Sets volume of thruster sound according to the mouse position
  maxThrusterSoundVolume = min(1, new PVector(width / 2, height / 2).dist(new PVector(mouseX, mouseY)) / new PVector(0, 0).dist(new PVector(width / 2, height / 2)));
  thrusterSound.amp(thrusterSoundVolume);
}

void mouseReleased() {
  myPlayer.RemoveForce(MovementForce);
}

void keyPressed() {
  // Allows the user to navigate through the introduction
  if (systemState < 2) {
    systemState += 1;
  }  
}
