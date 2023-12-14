/*
 By Student ID No. 21011025
 ---------------------------------------
  - This sketch code contains the functions used to draw to the screen
  - The main code is located in a seperate file called: KeeleInteraction_21011025.pde
 */

void DrawIntroText(int state) {
  if (state == 0) {
    // Page 1 of Introduction:
    
    // Displays title text
    textFont(createFont("Arial Bold", 26));
    text("Space Game", width / 2, 100);

    // Displays instructions text
    textFont(createFont("Arial", 20));
    text("On Earth, there is only a limited suply of important raw materials and we are running out.\nThese are needed to make electronic components such as batteries\nfor electric vehicles.", width / 2, 200);
    text("Your goal is to find elements from other planets and bring them\nback to Earth in time for the BCS Human-Computer Interaction conference at Keele University.", width / 2, 300);

    image(keeleLogo, 300, 430);
    image(bcsLogo, 700, 430);

    String str = "Press any key to continue...";
    float strWidth = textWidth(str);
    float strAscent = textAscent();
    float strDescent = textDescent();
    float strHeight = strAscent + strDescent;
    float strPadding = 5;

    // Creates white text background
    fill(255);
    rect(width / 2 - strWidth / 2 - strPadding, height - 50 - strAscent / 2 - strPadding, strWidth + 2 * strPadding, strHeight + 2 * strPadding);

    // Creates black text
    fill(0);
    textFont(createFont("Arial Bold", 17));
    text(str, width / 2, height - 50);
  } else if (state == 1) {
    // Page 2 of Introduction:
    
    // Displays title text
    textFont(createFont("Arial Bold", 26));
    text("Space Game", width / 2, 100);

    // Displays instruction title text
    textFont(createFont("Arial Bold", 20));
    text("HOW TO PLAY", width / 2, height * 1 / 4);

    // Displays instruction text
    textFont(createFont("Arial", 20));
    text("Move the cursor in the direction you want to travel\nand hold the mouse down to move", width / 2, 200);
    text("Watch out for asteroid debris\nAND black holes!", width / 2, 310);
    
    image(asteroidImage, 315, 310, 65, 65);
    image(blackHoleIcon, 685, 310, 65, 65);

    // Creates divider line
    strokeWeight(1);
    stroke(255);
    line(250, 360, width - 250, 360);

    image(clockIcon, width / 2, 400, 45, 45);
    text("You only have 2 minutes to get back to Earth\nbefore the conference begins!", width / 2, 455);

    String str = "Press any key to start...";
    float strWidth = textWidth(str);
    float strAscent = textAscent();
    float strDescent = textDescent();
    float strHeight = strAscent + strDescent;
    float strPadding = 5;

    // Creates white text background
    fill(255);
    rect(width / 2 - strWidth / 2 - strPadding, height - 50 - strAscent / 2 - strPadding, strWidth + 2 * strPadding, strHeight + 2 * strPadding);

    // Creates black text
    fill(0);
    textFont(createFont("Arial Bold", 17));
    text(str, width / 2, height - 50);
  }
}

void DrawStars() {
  noStroke();
  fill(255);

  // Calculates the offset XY coordinates to display the stars
  float offsetX1 = (-myPlayer.pos.x * starSpeed - width) % (2 * width) + width;
  float offsetX2 = (-myPlayer.pos.x * starSpeed) % (2 * width) + width;
  float offsetY1 = (-myPlayer.pos.y * starSpeed - height) % (2 * height) + height;
  float offsetY2 = (-myPlayer.pos.y * starSpeed) % (2 * height) + height;

  // Draws the stars as ellipses
  for (int i = 0; i < stars.length; i++) {
    float[] element = stars[i];
    
    ellipse(offsetX1 + element[0], offsetY1 + element[1], element[2], element[2]);
    ellipse(offsetX2 + element[0], offsetY1 + element[1], element[2], element[2]);
    ellipse(offsetX1 + element[0], offsetY2 + element[1], element[2], element[2]);
    ellipse(offsetX2 + element[0], offsetY2 + element[1], element[2], element[2]);
  }
}

void DrawSpaceNebula() {
  // Calculates the XY coordinates to display the images
  int spaceMapX1 = floor((myPlayer.pos.x * spaceSpeed + width) / (width * 2)) * 2;
  int spaceMapX2 = floor((myPlayer.pos.x * spaceSpeed) / (width * 2)) * 2 + 1;
  int spaceMapY1 = floor((myPlayer.pos.y * spaceSpeed + height) / (height * 2)) * 2;
  int spaceMapY2 = floor((myPlayer.pos.y * spaceSpeed) / (height * 2)) * 2 + 1;

  // Procedurally generates new images as the player moves
  if (previousSpaceMapX1 != spaceMapX1 || previousSpaceMapY1 != spaceMapY1) {
    GenerateSpaceBackground(spaceMapX1, spaceMapY1, 0);
  }
  if (previousSpaceMapX2 != spaceMapX2 || previousSpaceMapY1 != spaceMapY1) {
    GenerateSpaceBackground(spaceMapX2, spaceMapY1, 1);
  }
  if (previousSpaceMapX1 != spaceMapX1 || previousSpaceMapY2 != spaceMapY2) {
    GenerateSpaceBackground(spaceMapX1, spaceMapY2, 2);
  }
  if (previousSpaceMapX2 != spaceMapX2 || previousSpaceMapY2 != spaceMapY2) {
    GenerateSpaceBackground(spaceMapX2, spaceMapY2, 3);
  }

  // Updates previous map positions
  previousSpaceMapX1 = spaceMapX1;
  previousSpaceMapX2 = spaceMapX2;
  previousSpaceMapY1 = spaceMapY1;
  previousSpaceMapY2 = spaceMapY2;

  // Translates the canvas to the player's current location
  pushMatrix();
  translate(-myPlayer.pos.x * spaceSpeed + width / 2, -myPlayer.pos.y * spaceSpeed + height / 2);

  // Displays nebula images
  image(spaceImages[0], spaceMapX1 * width, spaceMapY1 * height, width, height);
  image(spaceImages[1], spaceMapX2 * width, spaceMapY1 * height, width, height);
  image(spaceImages[2], spaceMapX1 * width, spaceMapY2 * height, width, height);
  image(spaceImages[3], spaceMapX2 * width, spaceMapY2 * height, width, height);

  popMatrix();
}

void DrawThrusters() {
  // Left Thruster:
  for (int i = 0; i < thrusterL.particles.size(); i++) {
    Particle element = thrusterL.particles.get(i);
    float size = min(element.lifeSpan * 2, 30);

    if (size > 10) {
      fill(element.fillR, element.fillG, element.fillB, 50);
      ellipse(element.pos.x, element.pos.y, size, size);
    }
  }

  // Right Thruster:
  for (int i = 0; i < thrusterR.particles.size(); i++) {
    Particle element = thrusterR.particles.get(i);
    float size = min(element.lifeSpan * 2, 30);

    if (size > 10) {
      fill(element.fillR, element.fillG, element.fillB, 50);
      ellipse(element.pos.x, element.pos.y, size, size);
    }
  }

  // Up Thruster:
  for (int i = 0; i < thrusterU.particles.size(); i++) {
    Particle element = thrusterU.particles.get(i);
    float size = min(element.lifeSpan * 2, 30);

    if (size > 10) {
      fill(element.fillR, element.fillG, element.fillB, 50);
      ellipse(element.pos.x, element.pos.y, size, size);
    }
  }

  // Down Thruster:
  for (int i = 0; i < thrusterD.particles.size(); i++) {
    Particle element = thrusterD.particles.get(i);
    float size = min(element.lifeSpan * 2, 30);

    if (size > 10) {
      fill(element.fillR, element.fillG, element.fillB, 50);

      ellipse(element.pos.x, element.pos.y, size, size);
    }
  }

  thrusterL.Update();
  thrusterR.Update();
  thrusterU.Update();
  thrusterD.Update();
}

void DrawPlanets() {
  pushMatrix();
  translate(-myPlayer.pos.x + width / 2, -myPlayer.pos.y + height / 2);

  for (int i = 0; i < planets.size(); i++) {
    Planet planet = planets.get(i);

    // Draw Planet
    image(planetImages[planet.type], planet.pos.x, planet.pos.y, 500, 500);

    // Draw Elements
    if (planet.type != 4) { // If the planet is not Earth
    
      // Draw and update all the elements which have not yet been collected
      for (int j = 0; j < planet.elements.length; j++) {
        Element element = planet.elements[j]; 

        if (element.collected == false) {
          image(elementImages[element.type], element.pos.x, element.pos.y, 75, 75); 
          element.Update();
        }
      }
    }
  }

  popMatrix();
}

void DrawBlackHoles() {
  pushMatrix();
  translate(-myPlayer.pos.x + width / 2, -myPlayer.pos.y + height / 2);

  for (int n = 0; n < blackHoles.size(); n++) {
    BlackHole element = blackHoles.get(n);
    element.Update();

    if (element.warning) {
      // Display a warning circle:
      noFill();
      strokeWeight(10);
      stroke(100, 100, 100, sin(float(frameCount) / 20) * 50);
      ellipse(element.pos.x, element.pos.y, element.size * 10, element.size * 10);
    }

    // Draw the bezier curve black hole:
    
    float oX = element.pos.x;
    float oY = element.pos.y;
    float s = element.size;
    float t = frameCount * 2;

    // Radii of bezier control points 
    float r1 = s * 0 + sin(t / 20) * 5;
    float r2 = s * 0.25 + s + cos(t / 100) * 5;
    float r3 = s * 0.75 + s + sin(t / 100) * 5;
    float r4 = s * 0.50 + s + cos(t / 100) * 5;

    // Positions of bezier control points 
    float x1 = r1 * cos(radians(90 + t));
    float y1 = r1 * sin(radians(90 + t));
    float x2 = r2 * cos(radians(-90 + t));
    float y2 = r2 * sin(radians(-90 + t));
    float x3 = r3 * cos(radians(-200 + t));
    float y3 = r3 * sin(radians(-200 + t));
    float x4 = r4 * cos(radians(90 + t));
    float y4 = r4 * sin(radians(90 + t));

    noFill();
    strokeWeight(7);
    stroke(100 - sin(t / 100) * 50, 100 - sin(t / 100) * 50, 100 - sin(t / 100) * 50); // Uses sine function to animate stroke colour

    // Draws the spiral curves
    pushMatrix();
    for (int i = 0; i <= 360; i += 45) {
      translate(oX, oY);
      rotate(radians(i));
      translate(-oX, -oY);
      bezier(oX + x1, oY + y1, oX + x2, oY + y2, oX + x3, oY + y3, oX + x4, oY + y4);
    }
    popMatrix();

    // Draws the black hole centre
    noStroke();
    fill(0);
    ellipse(oX, oY, s, s);
  }

  popMatrix();
}

void DrawAsteroids() {
  for (int i = 0; i < asteroids.size(); i++) {
    Asteroid element = asteroids.get(i);
    element.Update();

    pushMatrix();
    // Rotates the asteroid about its centre
    translate(element.pos.x - myPlayer.pos.x + width / 2, element.pos.y - myPlayer.pos.y + height / 2);
    rotate(element.rotateAngle);

    // Draw asteroid image
    image(asteroidImage, 0, 0, 100, 100);

    popMatrix();

    if (element.isCollided) { // If asteroid has collided with the player
    
      // Draw impact collision animation
      int imageWidth = (int) (collisionSpriteSheet.width / collisionSpriteCount);
      int imageXOffset = (int) (element.animationFrame * imageWidth);

      if (imageXOffset < collisionSpriteSheet.width) {
        image(collisionSpriteSheet.get(imageXOffset, 0, imageWidth, imageWidth), element.impactPos.x, element.impactPos.y);

        element.animationFrame++;
      }
    }
  }
}

void DrawPlayer() {
  image(robot, width / 2, height / 2, 200, 200);
  
  if (!myPlayer.hasWon && !myPlayer.isDead) {
    myPlayer.Update();
  }
}

// Function used for generating the space nebula background using Perlin Noise
void GenerateSpaceBackground(int mapX, int mapY, int index) {
  PImage image = spaceImages[index];

  float scale = 0.005;
  float maskScale = 0.004;
  float xOffset = mapX * image.width * scale;
  float yOffset = mapY * image.height * scale;

  for (int x = 0; x < image.width; x++) {
    for (int y = 0; y < image.height; y++) {
      float valueR = noise(xOffset + x * scale, yOffset + y * scale);
      float valueG = noise(xOffset + (x + 100) * scale, yOffset + (y + 100) * scale);
      float valueB = noise(xOffset + (x + 200) * scale, yOffset + (y + 200) * scale) * 0.5;
      float mask = pow(noise((mapX * image.width + x) * maskScale, (mapY * image.height + y) * maskScale), 3) * 1.25;

      valueR *= mask;
      valueG *= mask;
      valueB *= mask;

      image.pixels[x+y*image.width] = color(valueR * 255, valueG * 255, valueB * 255);
    }
  }

  spaceImages[index] = image.get();
}

void DrawNearbyIcons() {
  int size = 400;
  
  // Create translucent ring
  noFill();
  strokeWeight(2);
  stroke(255, 255, 255, 50);
  ellipse(width / 2, height / 2, size, size);

  // Loop through all asteroids
  for (int i = 0; i < asteroids.size(); i++) {
    Asteroid element = asteroids.get(i);

    float dx = element.pos.x - myPlayer.pos.x;
    float dy = element.pos.y - myPlayer.pos.y;

    float distance = myPlayer.pos.dist(element.pos);

    float angle = atan2(dx, dy);

    float iconX = size / 2 * sin(angle);
    float iconY = size / 2 * cos(angle);

    // Draw asteroid icons on the ring
    image(asteroidImage, iconX + width / 2, iconY + height / 2, 50, 50);
  }

   // Loop through all black holes
  for (int i = 0; i < blackHoles.size(); i++) {
    BlackHole element = blackHoles.get(i);

    float dx = element.pos.x - myPlayer.pos.x;
    float dy = element.pos.y - myPlayer.pos.y;

    float distance = myPlayer.pos.dist(element.pos);

    if (distance > width / 2 && distance < width) {
      float angle = atan2(dx, dy);

      float iconX = size / 2 * sin(angle);
      float iconY = size / 2 * cos(angle);

      // Draw black holes icons on the ring
      image(blackHoleIcon, iconX + width / 2, iconY + height / 2, 40, 40);
    }
  }

  // Loop through all planets
  for (int i = 0; i < planets.size(); i++) {
    Planet element = planets.get(i);
    int type = element.type;

    float dx = element.pos.x - myPlayer.pos.x;
    float dy = element.pos.y - myPlayer.pos.y;

    float distance = myPlayer.pos.dist(element.pos);

    if (distance > width / 2) {
      float angle = atan2(dx, dy);

      float iconX = size / 2 * sin(angle) + width / 2;
      float iconY = size / 2 * cos(angle) + height / 2;

      // Draw planet icons on the ring
      image(planetImages[type], iconX, iconY, 40, 40);

      // Draw distance to planet on the ring:

      float scale = 10;
      String distanceAsText = str(round(distance / 1000 * 10) / scale).concat(" AU");

      textAlign(CENTER, CENTER);
      fill(255);
      textSize(12);
      text(distanceAsText, iconX - sin(-angle) * 50, iconY + cos(-angle) * 50 - cos(angle) * 15);
    }
  }
}

void DrawHUDInfo() {
  textAlign(LEFT, CENTER);
  strokeWeight(3);
  
  float clockRadius = 40;
  float clockOffsetX = clockRadius + 10, clockOffsetY = clockRadius + 10;
  
  // Draws the clock face
  fill(255);
  ellipse(clockOffsetX, clockOffsetY, clockRadius*2, clockRadius*2);

  float clockAngle = map(remainingTime, 60, 0, 0, 2 * PI) - PI/2; // The angle of the clock hand in radians

  if (remainingTime <= 20) {
    // Draw red sector on clock
    
    fill(255, 0, 0, 100);
    arc(clockOffsetX, clockOffsetY, clockRadius*2, clockRadius*2, clockAngle, 3*PI/2);
  }

  // Draws the 5 second interval marks on the clock
  stroke(100);
  pushMatrix();
  translate(clockOffsetX, clockOffsetY);
  rotate(PI/2);
  for (int i = 0; i < 12; i++) {
    float theta = (2 * PI / 12);
    line(clockRadius - 15, 0, clockRadius - 5, 0);
    rotate(theta);
  }
  popMatrix();

  // Draws clock hand
  fill(0);
  stroke(0);
  pushMatrix();
  translate(clockOffsetX, clockOffsetY);
  rotate(clockAngle + PI/2);
  strokeJoin(ROUND);
  triangle(clockRadius*0.10, 0, -clockRadius*0.1, 0, 0, -clockRadius + clockRadius*0.3);
  popMatrix();

  // Draws inner white circle on clock
  fill(255);
  ellipse(clockOffsetX, clockOffsetY, clockRadius*0.25, clockRadius*0.25);

  // Displays the time remaning
  if (ceil(remainingTime) > 0) {
    textSize(16);
    text("Time Remaining", clockOffsetX + clockRadius + 20, clockOffsetY - 25);

    textSize(22);
    text(ceil(remainingTime) + "s", clockOffsetX + clockRadius + 20, clockOffsetY);
  } else if (!myPlayer.isDead && !myPlayer.hasWon) {
    textSize(22);
    text("Times up!", clockOffsetX + clockRadius + 20, clockOffsetY);
    
    myPlayer.terminalVelocity *= 0.97;
  }
  
  // Display the player's current task:
  
  int goldCount = 0;
  int lithiumCount = 0;
  int cobaltCount = 0;

  // Calculate the total elements left to be collected by each element type
  for (int i = 0; i < planets.size(); i++) {
    Element[] elements = planets.get(i).elements;

    if (planets.get(i).type == 4) continue;

    for (int j = 0; j < elements.length; j++) {
      if (elements[j].collected) continue;

      if (elements[j].type == 0) {
        goldCount++;
      } else if (elements[j].type == 1) {
        lithiumCount++;
      } else if (elements[j].type == 2) {
        cobaltCount++;
      } else if (elements[j].type == 3) {
        cobaltCount++;
      } else if (elements[j].type == 4) {
        cobaltCount++;
      }
    }
  }  

  Boolean collectedAllGold = goldCount == 0;
  Boolean collectedAllLithium = lithiumCount == 0;
  Boolean collectedAllCobalt = cobaltCount == 0;
  
  myPlayer.hasCollectedAllElements = collectedAllGold && collectedAllLithium && collectedAllCobalt;

  textAlign(LEFT, CENTER);
  textFont(createFont("Arial Bold", 24));
  text("Your Task", 10, 120);

  textFont(createFont("Arial", 20));
  if (myPlayer.hasCollectedAllElements) {
    text("Return to Earth", 10, 150);
  } else {
    text("Find these elements:", 10, 150);
  }  

  textFont(createFont("Arial", 18));

  // Displays the types and amounts of elements the player must collect:

  int lineSpace = 35;

  if (!collectedAllGold) {
    text(str(goldCount).concat(" x Gold"), 60, 190);
    image(elementImages[0], 30, 190, 30, 30);
  }

  if (!collectedAllLithium) {
    text(str(lithiumCount).concat(" x Lithium"), 60, 190 + lineSpace - int(collectedAllGold) * lineSpace);
    image(elementImages[1], 30, 190 + lineSpace - int(collectedAllGold) * lineSpace, 30, 30);
  }  

  if (!collectedAllCobalt) {
    text(str(cobaltCount).concat(" x Cobalt"), 60, 190 + 2 * lineSpace - int(collectedAllGold) * lineSpace - int(collectedAllLithium) * lineSpace);
    image(elementImages[2], 30, 190 + 2 * lineSpace - int(collectedAllGold) * lineSpace - int(collectedAllLithium) * lineSpace, 30, 30);
  }
  
  
  // Displays a warning message when an asteroid is approaching the player
  if (asteroids.size() > 0 && !asteroids.get(0).isCollided) {
    textFont(createFont("Arial", 24));
    textAlign(CENTER, CENTER);
    text("WARNING: Asteroid Incoming!", width / 2, 20);
  }
}

void DrawCredits() {
  background(0);
  fill(255);
  textAlign(CENTER, CENTER);
  
  float creditsOffset = height - (frameCount - finalFrameCount) * 2;

  // Draw scrolling credits
  for (int i = 0; i < credits.length; i++) {
    String line = credits[i];
    
    if (line.length() >= 2 && line.substring(0, 2).equals("**")) {
        textFont(createFont("Arial Bold", 24));
        line = new String(line.substring(2, line.length()));
    }
    else {
        textFont(createFont("Arial", 24));
    }
    
    
    text(line, width / 2, creditsOffset + i * 40);
  }
}
