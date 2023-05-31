int w;
int h;
float R;
float G;
float B;
ArrayList<Blob> myBlobs;
ArrayList<Pellet> pellets;
ArrayList<Enemy> enemies;
boolean gameOver = false;

boolean spacebarPressed;
//boolean enterPressed;
int lastEnemyTime;
int lastPelletTime;
int lastRecombineTime;
int score;
void setup() {
  score = 0;
  size(1600, 900);
  w = width / 2;
  h = height / 2;
  R = random(255);
  G = random(255);
  B = random(255);
  myBlobs = new ArrayList<Blob>();
  enemies = new ArrayList<Enemy>();
  myBlobs.add(new Blob(w, h, 50, color(R, G, B)));
  lastPelletTime = millis();
  lastRecombineTime = millis();  
  lastEnemyTime = millis();
  pellets = new ArrayList<Pellet>();
}

void draw() {
  background(255);
  
  if (!gameOver) {

  handleKeyPress();
  
  for (int i = myBlobs.size() - 1; i >= 0; i--) {
    Blob blob = myBlobs.get(i);
    //blob.update();
    blob.display();
    blob.followMouse();
    blob.checkCollision();
    blob.eatPellet();
    blob.eatEnemy();
  }
  
  if (millis() - lastRecombineTime >= 3000) {
    recombineBlobs();
    lastRecombineTime = millis();  // Update the lastRecombineTime variable
  }
  
  
  if (millis() - lastEnemyTime >= 5000) {
    Enemy newEnemy = new Enemy( int(random(width)), int(random(height)), int(random((myBlobs.get(0)).size +25)),  color(int(random(255)), int(random(255)), int(random(255))));
    enemies.add(newEnemy);
    lastEnemyTime = millis();  // Update the lastEnemyTime variable
  }
  generateNewMap();
  generatePellets();
  drawEnemies();
  
  
  textAlign(RIGHT);
  fill(0);
  if (myBlobs.size() > 0) {
  text("Coordinates: (" + myBlobs.get(0).posX + ", " + myBlobs.get(0).posY + ")", width - 20, 30);
  }
  text("Score: " + score, width - 20, 60);
  
  
  }
  else {
    noLoop();
    textSize(40);
    textAlign(CENTER);
    fill(255, 0, 0);
    text("Game Over", width/2, height/2);
    text("Score: " + score, width/2, height/2 + 50);
    
  }
  
  
}

void handleKeyPress() {
  if (spacebarPressed) {
    spacebarPressed = false;
    splitBlobs();
  } 
}

void keyPressed() {
  if (key == ' ') {
    spacebarPressed = true;
  } 
}

void splitBlobs() {
  ArrayList<Blob> newBlobs = new ArrayList<Blob>();

  for (Blob blob : myBlobs) {
    if (blob.size >= 20) {
      int newSize = blob.size / 2;
      newBlobs.add(new Blob(blob.posX + blob.size, blob.posY, newSize, blob.myColor));
      blob.size = newSize; // Reduce the size of the current blob
    }
  }

  myBlobs.addAll(newBlobs);
}


void recombineBlobs() {
  boolean toRecombine = true;
  Blob mainBlob = myBlobs.get(0);
  if (myBlobs.size() > 1) {
    int totalSize = 0;
    for (Blob blob : myBlobs) {
      if (dist(mainBlob.posX, mainBlob.posY,blob.posX,blob.posY) <= (2 * mainBlob.size) + 5) totalSize += blob.size;
      else {
        toRecombine = false;
        break;
      }
    }

    if (toRecombine) {
    mainBlob.size = totalSize; // Set the size of the main blob to the sum of all blob sizes

    // Remove all blobs except the main blob
    for (int i = myBlobs.size() - 1; i > 0; i--) {
      myBlobs.remove(i);
    }
    }
  }
}

void generateNewMap() {
  if (!gameOver) {
  Blob mainBlob = myBlobs.get(0);
  int posX = mainBlob.posX;
  int posY = mainBlob.posY;
  int size = mainBlob.size;
  
  int boundaryThreshold = size / 2; // Distance threshold from the edge
  
  if (posX - boundaryThreshold < 0) {
    resetMap();
    for (Blob blob : myBlobs) {
      blob.posX = width - size;
    }
    
    
    
  } 
  else if (posX + size > width) {
    resetMap();
    for (Blob blob : myBlobs) {
      blob.posX = size;
    }

  }

  if (posY - boundaryThreshold < 0) {
    resetMap();
    for (Blob blob : myBlobs) {
      blob.posY = height - size;
    }
  } 
  else if (posY + size > height) {
    resetMap();
    for (Blob blob : myBlobs) {
      blob.posY = size;
    }
  }
  }
}

void resetMap() {
  pellets.clear();
  enemies.clear();
  lastPelletTime = millis();
  background(255);
}



void generatePellets() {
  if (millis() - lastPelletTime >= 1000) {
    Pellet newPellet = new Pellet();
    pellets.add(newPellet);
    lastPelletTime = millis();
  }

  for (Pellet pellet : pellets) {
    pellet.drawPellet();
  }
}


void drawEnemies() {
  if (!gameOver) {
    for (Enemy enemy : enemies) {
    enemy.checkBoundary();
    enemy.display();
    enemy.moveEnemy(myBlobs.get(0));
    enemy.eatPellet();
  }
    
  }
  
  
}
