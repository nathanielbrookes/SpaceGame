import processing.sound.*;

/*
 CSC-10026 - Keele Interaction Animation
 By Student ID No. 21011025 
 ---------------------------------------
 About Sketch:
 -------------
 - This sketch is a 2D game set in space where the player must find materials from different planets,
 and return them to Earth within the time limit. The player may encounter several obstacles.
 
 - The player must press and hold the mouse button to power the thrusters and move the cursor in the
 direction they want to travel.
 
 File Structure:
 ---------------
 This is the main file in the sketch which includes:
 - Global variables (e.g. PImage, ArrayList)
 - setup() and draw() functions
 
 Other files in the sketch:
 - InputControls
 - Functions
 - Asteroid
 - BlackHole
 - Planet
 - Player
 - ThrusterParticleSystem
 */

// Global Variables:

int FPS = 30;
int systemState = 0;
float remainingTime = 120; // Time left in seconds
float elapsedTime = 0; // Time elapsed in seconds

int finalFrameCount = 0;

String[] credits;

SoundFile thrusterSound;
float thrusterSoundVolume = 0;
float maxThrusterSoundVolume = 1;

SoundFile collisionSound;
SoundFile collectSound;

PImage[] spaceImages = new PImage[4];
PImage[] planetImages = new PImage[5];
PImage[] elementImages = new PImage[3];
PImage keeleLogo;
PImage bcsLogo;
PImage robot;
PImage blackHoleIcon;
PImage clockIcon;
PImage asteroidImage;
PImage collisionSpriteSheet;
int collisionSpriteCount = 10;

float[][] stars = new float[50][3];

ArrayList<Planet> planets = new ArrayList<Planet>();
ArrayList<BlackHole> blackHoles = new ArrayList<BlackHole>();
ArrayList<Asteroid> asteroids = new ArrayList<Asteroid>();

// Thruster Particle Systems
ThrusterParticleSystem thrusterL;
ThrusterParticleSystem thrusterR;
ThrusterParticleSystem thrusterU;
ThrusterParticleSystem thrusterD;

Player myPlayer;

// Starting position of player
int originX = 50000;
int originY = 50000;

// Relative speed of backgrounds to create parallax effect
float spaceSpeed = 0.5;
float starSpeed = 0.15;

// Variables used to procedurally generate the infinite space background
int previousSpaceMapX1 = -1;
int previousSpaceMapX2 = -1;
int previousSpaceMapY1 = -1;
int previousSpaceMapY2 = -1;

void setup() {
  size(1000, 600);
  frameRate(FPS);

  // Load credits
  credits = loadStrings("credits.txt");

  // Load sound files:
  thrusterSound = new SoundFile(this, "thruster.wav");
  collisionSound = new SoundFile(this, "collision.wav");
  collectSound = new SoundFile(this, "collect.wav");

  // Load images:
  keeleLogo = loadImage("keele-logo.png");
  bcsLogo = loadImage("bcs-logo.png");
  robot = loadImage("robot.png");
  blackHoleIcon = loadImage("black-hole.png");
  clockIcon = loadImage("clock.png");
  asteroidImage = loadImage("asteroid.png");
  collisionSpriteSheet = loadImage("collision.png");

  for (int i = 0; i < 4; i++) { 
    spaceImages[i] = createImage(width / 3, height / 3, RGB);
  }

  for (int i = 0; i < planetImages.length; i++) {
    planetImages[i] = loadImage("Planets/".concat(str(i)).concat(".png"));
  }  

  for (int i = 0; i < elementImages.length; i++) {
    elementImages[i] = loadImage("Elements/".concat(str(i)).concat(".png"));
  }

  // Create instance class for Player
  myPlayer = new Player(originX, originY);

  // Generate stars
  for (int i = 0; i < stars.length; i++) {
    float[] element = stars[i];

    element[0] = floor(random(0, width)); // Star X position
    element[1] = floor(random(0, height)); // Star Y position
    element[2] = floor(random(3, 10)); // Star radius
  }

  // Generates planets and black holes
  int planetCount = planetImages.length;
  float startRadius = width;
  float radialPadding = 0.2;
  int interval = width;
  float deviation = 100;

  for (int n = 0; n < planetCount; n++) {
    // Generate black holes in between planets

    float blackHoleCount = ceil(4 * PI * n);
    for (int i = 0; i < blackHoleCount; i++) {
      float blackHoleRadius = startRadius + 2 * n * interval + random(-deviation, deviation);
      float angle = random(2 * PI / (blackHoleCount + 1) * i + radialPadding, 2 * PI / (blackHoleCount + 1) * (i + 1) - radialPadding);

      float rX = myPlayer.pos.x + sin(angle) * blackHoleRadius;
      float rY = myPlayer.pos.y + cos(angle) * blackHoleRadius;

      new BlackHole(rX, rY);
    }

    // Generate planets
    float planetRadius = startRadius + (2 * n + 1) * interval;
    float angle = random(2 * PI / (planetCount + 1) * n + radialPadding, 2 * PI / (planetCount + 1) * (n + 1) - radialPadding);

    float rX = myPlayer.pos.x + sin(angle) * planetRadius;
    float rY = myPlayer.pos.y + cos(angle) * planetRadius;

    new Planet(rX, rY, n);
  }

  // Create thrusters
  thrusterL = new ThrusterParticleSystem(100 + width / 2, height / 2, 20, 0);
  thrusterR = new ThrusterParticleSystem(-100 + width / 2, height / 2, 20, 1);
  thrusterD = new ThrusterParticleSystem(width / 2, -100 + height / 2, 20, 2);
  thrusterU = new ThrusterParticleSystem(width / 2, 100 + height / 2, 20, 3);
}

void draw() {
  background(0); // Creates a black background
  fill(255);
  imageMode(CENTER);
  textAlign(CENTER, CENTER);

  if (systemState == 0) { // Scene 1: Introduction
    DrawIntroText(0);
  } else if (systemState == 1) { // Scene 1: Introduction
    DrawIntroText(1);
  } else if (systemState == 2) { // Scene 2: Space Game
    // Draw graphics
    DrawSpaceNebula();
    DrawStars();
    DrawPlanets();
    DrawBlackHoles();
    DrawThrusters();
    DrawPlayer();
    DrawAsteroids();
    DrawNearbyIcons();
    DrawHUDInfo();

    // Generate asteroid every 25 seconds
    if ((floor(remainingTime - 1) % 25) == 0 && asteroids.size() == 0) {
      new Asteroid();
    }

    // Fades in/out volume of thruster sound
    if (mousePressed) {
      thrusterSoundVolume /= 0.8;
      thrusterSoundVolume = min(maxThrusterSoundVolume, thrusterSoundVolume);
    } else if (!mousePressed) {
      thrusterSoundVolume *= 0.8;
      thrusterSoundVolume = max(0.001, thrusterSoundVolume);
    }

    // Play thruster sound effect
    thrusterSound.amp(thrusterSoundVolume);
    if (!thrusterSound.isPlaying()) {
      thrusterSound.play();
    }

    // Check if player has completed the task
    if (myPlayer.hasCollectedAllElements && myPlayer.pos.dist(planets.get(4).pos) < 250) {
      myPlayer.hasWon = true;
      remainingTime = 0;

      // Fades to black after 2 seconds
      if (elapsedTime >= 2) {
        fill(0, (elapsedTime - 2) * 300);
        rect(0, 0, width, height);
      } 

      // Displays success message after 3 seconds
      if (elapsedTime >= 3) {
        background(0);
        fill(255);
        textSize(30);
        textAlign(CENTER, CENTER);
        text("Hoooray, you managed to get the elements back to Earth in time\nfor the BCS Human-Computer Interaction \nconference at Keele University!", width / 2, height / 2);
      }

      // Rolls credits after 11 seconds
      if (elapsedTime >= 11) {
        finalFrameCount = frameCount;
        systemState = 3;
      }
    } else if (!myPlayer.hasWon && (myPlayer.isDead || remainingTime <= 0)) { // Failiure Message
      remainingTime = 0;

      // Fades to black after 2 seconds
      if (elapsedTime >= 2) {
        fill(0, (elapsedTime - 2) * 300);
        rect(0, 0, width, height);
      } 

      // Displays game-over message after 3 seconds
      if (elapsedTime >= 3) {
        background(0);
        fill(255);
        textSize(30);
        textAlign(CENTER, CENTER);
        text("GAME OVER", width / 2, height / 2);
      }

      // Rolls credits after 5 seconds
      if (elapsedTime >= 5) {
        finalFrameCount = frameCount;
        systemState = 3;
      }
    }
  } else if (systemState == 3) { // Scene 3: Scrolling Credits
    DrawCredits();
  }

  if (systemState > 1) {
    // Decrease the remaining time
    if (remainingTime > 1 / frameRate && !myPlayer.isDead) {
      remainingTime -= 1 / frameRate;
    } else {
      remainingTime = 0;
      elapsedTime += 1 / frameRate;
    }
  }
}
