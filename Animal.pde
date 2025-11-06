class Animal {
  PVector pivot = new PVector(0,0);
  float angle = 0;
  float size;
  float speed = 5;
  float rotationSpeed = 0.05; // плавность поворота
  
  float radius; // для коллизии

  Animal(float x, float y, float animalSize) {
    pivot.x = x;
    pivot.y = y;
    size = animalSize;
    
    radius = size;
  }

  void update() {
    float targetAngle = atan2(mouseY - pivot.y, mouseX - pivot.x);

    // корректная разница углов
    float diff = ((targetAngle - angle + PI) % TWO_PI) - PI;
    angle += diff * rotationSpeed;

    // двигаем в направлении угла
    PVector dir = PVector.fromAngle(angle);
    dir.mult(speed);
    pivot.add(dir);
  }

  void display() {
    pushMatrix();
    translate(pivot.x, pivot.y);
    rotate(angle);
    drawTriangle(0, -size, 0, size, size*2, 0);
    popMatrix();
  }
  
  boolean isColliding(Animal other) {
    float d = PVector.dist(this.pivot, other.pivot);
    return d < (this.radius + other.radius);
  }
  
  void resolveCollision(Animal other) {
    PVector diff = PVector.sub(this.pivot, other.pivot);
    float d = diff.mag();
    float overlap = (this.radius + other.radius) - d;
    if (overlap > 0) {
      diff.normalize();
      diff.mult(overlap / 2);
      this.pivot.add(diff);
      other.pivot.sub(diff);
    }
  }


}


// Функция для рисования треугольника с центром в (0,0)
void drawTriangle(float x1, float y1, float x2, float y2, float x3, float y3) {
  // Вычисляем центр
  float centerX = (x1 + x2 + x3) / 3.0;
  float centerY = (y1 + y2 + y3) / 3.0;

  // Рисуем треугольник, сдвинув вершины
  triangle(x1 - centerX, y1 - centerY,
           x2 - centerX, y2 - centerY,
           x3 - centerX, y3 - centerY);
}
