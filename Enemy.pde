class Enemy extends Blob {



  public Enemy(int posX, int posY, int size, color myColor) {
    super(posX, posY, size, myColor);
  }

  void display() {
    stroke(0);
    fill(myColor);
    circle(posX, posY, size);
  }
  
  void eatPellet() {
    for (int i = pellets.size() - 1; i >= 0; i--) {
      int pelletX = pellets.get(i).posX;
      int pelletY = pellets.get(i).posY;

      float distance = dist(this.posX, this.posY, pelletX, pelletY);
      int blobRadius = this.size / 2;
      int pelletRadius = 10;

      if (distance <= blobRadius - pelletRadius) {
        pellets.remove(i);
        this.size += 5; 
      }
    }
  }

void checkBoundary() {
  if (posX < -size/2) {
    posX = width + size/2;
  } else if (posX > width + size/2) {
    posX = -size/2;
  }

  if (posY < -size/2) {
    posY = height + size/2;
  } else if (posY > height + size/2) {
    posY = -size/2;
  }
}

void moveEnemy(Blob target) {
  float targetX = target.posX;
  float targetY = target.posY;
  float easing = 0.03; 

  float dx = targetX - posX;
  float dy = targetY - posY;

  float distance = sqrt(dx * dx + dy * dy);

  if (distance != 0) {
    dx /= distance;
    dy /= distance;
  }

  if (size >= target.size) {
    posX += dx * easing * size;
    posY += dy * easing * size;
  } else {
    posX -= dx * easing * size;
    posY -= dy * easing * size;
  }
}

  
  
  
  
}
