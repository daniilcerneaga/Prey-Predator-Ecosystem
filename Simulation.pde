float deltaTime;  // в секундах
float lastTime;
float simulationSpeed = 10;

ArrayList<Animal> animals = new ArrayList<Animal>();
ArrayList<Animal> animalsToAdd = new ArrayList<Animal>();
ArrayList<Animal> animalsToRemove = new ArrayList<Animal>();
ArrayList<Food> foods = new ArrayList<Food>();
int spawnInterval = 100 / (int) simulationSpeed;
int lastSpawnTime = 0;

void setup() {
  size(800, 800);
  lastTime = millis() / 1000.0;
  
  int preyCount = 20;
  int predatorCount = 5;
  for(int i = 0; i < preyCount;i++)
  {
    animals.add(new Prey(random(width), random(height), 10));
  }
  // Хищники
  for (int i = 0; i < predatorCount; i++) {
    animals.add(new Predator(random(width), random(height), 10));
  }
  animals.add(new Animal(random(width), random(height), 10));
}

void draw() {
  background(30, 40, 50);
  float currentTime = millis() / 1000.0;
  deltaTime = (currentTime - lastTime) * 60 * simulationSpeed;
  lastTime = currentTime;
  
  // спавн еды
  if (millis() - lastSpawnTime > spawnInterval) {
    spawnFood();
    lastSpawnTime = millis();
  }
  
  // проверяем коллизии с едой
  for (int i = foods.size() - 1; i >= 0; i--) {
    Food f = foods.get(i);
    boolean eaten = false;
    
    for (Animal a : animals) {
      if (a.checkFoodCollision(f)) {
        a.satiety += f.saturation;
        eaten = true;
        break;
      }
    }
    
    if (eaten) foods.remove(i);
    else f.display();
  }

  // проверяем столкновения животных
  for (int i = 0; i < animals.size(); i++) {
    for (int j = i + 1; j < animals.size(); j++) {
      if (animals.get(i).isColliding(animals.get(j))) {
        animals.get(i).resolveCollision(animals.get(j));
      }
    }
  }
  
  // Удаляем животных с отрицательной сытостью
  for (int i = animals.size() - 1; i >= 0; i--) {
    if (animals.get(i).satiety < 0) {
      animals.remove(i);
    }
  }

  // обновляем и рисуем животных
  for (Animal a : animals) {
    a.update();
    a.display();
  }
  
   if (!animalsToAdd.isEmpty()) {
    animals.addAll(animalsToAdd);
    animalsToAdd.clear();
   }
    
    if (!animalsToRemove.isEmpty()) {
    animals.removeAll(animalsToRemove);
    animalsToAdd.clear();
  }
}

void spawnFood() {
  foods.add(new Food(int(random(50, width - 50)), int(random(50, height - 50))));
}
