/*
 By Student ID No. 21011025
 ---------------------------------------
  - This sketch code contains the BlackHole class used to create the black holes
  - The main code is located in a seperate file called: KeeleInteraction_21011025.pde
 
 This BlackHole class is responsible for:
  - Checking if the black hole is near the player
  - Applying a suction force to the player if they are close enough
 */

class BlackHole {
  PVector pos; // Position of black hole
  float size = 25;

  Boolean consumedPlayer = false;
  Boolean warning = false;

  PVector suctionForce = new PVector(0, 0);

  BlackHole(float x, float y) {
    pos = new PVector(x, y);

    // Adds this instance to the global blackHoles array
    blackHoles.add(this);
  }

  void Update() {
    if (consumedPlayer) {
      // Player has fallen into black hole
      
      // Add suction force to player
      myPlayer.RemoveForce(suctionForce);
      suctionForce = myPlayer.AddForce(new PVector((pos.x - myPlayer.pos.x) / 500, (pos.y - myPlayer.pos.y) / 500));

      size += 1;

      if (size >= 100) {
        myPlayer.isDead = true;
      }
    } else {
      myPlayer.RemoveForce(suctionForce);

      float warningDistance = 300;
      float finalDistance = 100;

      // Check if black hole is near player
      float distance = pos.dist(myPlayer.pos);

      if (distance <= finalDistance) {
        consumedPlayer = true;
      } else if (distance <= warningDistance) {
        warning = true;
      } else {
        warning = false;
      }
    }
  }
}
