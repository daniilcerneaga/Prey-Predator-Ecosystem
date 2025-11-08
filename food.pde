class Food {
  int saturation = 5;
  PVector position = new PVector(0, 0);
  float radius = 5; // радиус еды
  
  Food(int xPos, int yPos) {
    position.x = xPos;
    position.y = yPos;
  }
  
  void display() {
    pushMatrix();
    translate(position.x, position.y);
    fill(237, 233, 12);
    circle(0, 0, radius * 2);
    popMatrix();
  }
}
