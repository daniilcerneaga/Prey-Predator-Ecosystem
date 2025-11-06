Animal[] animals = new Animal[100];

void setup() {
  size(1000, 1000);
  for (int i = 0; i < animals.length; i++) {
    animals[i] = new Animal(random(width), random(height), 10);
  }
}

void draw() {
  background(30, 40, 50);

  // обновляем животных
  for (Animal a : animals) {
    a.update();
  }

  // проверяем коллизии
  for (int i = 0; i < animals.length; i++) {
    for (int j = i+1; j < animals.length; j++) {
      if (animals[i].isColliding(animals[j])) {
        animals[i].resolveCollision(animals[j]);
      }
    }
  }

  // рисуем
  for (Animal a : animals) {
    a.display();
  }
}
