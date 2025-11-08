class Prey extends Animal {

  Prey(float x, float y, float animalSize) {
    super(x, y, animalSize);
  }

  @Override
  void update() {
    satiety -= hungerSpeed;

    // 🔍 Ищем ближайшую еду
    Food nearestFood = findNearestFood(foods);

    if (nearestFood != null) {
      // Угол к еде
      float targetAngle = atan2(nearestFood.position.y - pivot.y,
                                nearestFood.position.x - pivot.x);

      // Плавно поворачиваемся
      float diff = ((targetAngle - angle + PI) % TWO_PI) - PI;
      angle += diff * rotationSpeed * deltaTime;
      
      // если угол слишком большой — двигайся медленнее
      float alignment = cos(diff);
      float adjustedSpeed = speed * max(0, alignment);

      // Движение к еде
      PVector dir = PVector.fromAngle(angle);
      dir.mult(adjustedSpeed);
      pivot.add(dir.mult(deltaTime));
    }
    
    // Поверяем размножение
    if (satiety >= reproductionDemand) {
      reproduce();
    }
  }

  // 🔎 Функция поиска ближайшей еды
  Food findNearestFood(ArrayList<Food> foods) {
    if (foods.isEmpty()) return null;

    Food nearest = null;
    float minDist = Float.MAX_VALUE;

    for (Food f : foods) {
      float d = PVector.dist(pivot, f.position);
      if (d < minDist) {
        minDist = d;
        nearest = f;
      }
    }

    return nearest;
  }

  @Override
  void display() {
    pushMatrix();
    fill(0, 255, 0);
    translate(pivot.x, pivot.y);
    rotate(angle);
    drawTriangle(0, -size, 0, size, size * 2, 0);
    popMatrix();
  }
  
  void reproduce() {
    satiety /= 2; // 🟡 энергия делится пополам
    Prey child = new Prey(pivot.x + random(-20, 20), pivot.y + random(-20, 20), size);
    child.satiety = this.satiety; // у потомка такая же половина
    animalsToAdd.add(child); // ⚠️ не добавляем сразу, чтобы не ломать итерацию
  }
}
