class Predator extends Animal {

  Predator(float x, float y, float animalSize) {
    super(x, y, animalSize);
    
    speed = 1;
    reproductionDemand = 30;
    hungerSpeed = 0.015 * simulationSpeed;
  }

  @Override
  void update() {
    satiety -= hungerSpeed;

    // 🔍 Ищем ближайшую жертву
    Prey nearestPrey = findNearestPrey();

    if (nearestPrey != null) {
      // Угол к жертве
      float targetAngle = atan2(nearestPrey.pivot.y - pivot.y,
                                nearestPrey.pivot.x - pivot.x);

      // Плавно поворачиваемся к ней
      float diff = ((targetAngle - angle + PI) % TWO_PI) - PI;
      angle += diff * rotationSpeed * deltaTime;

      // Чем точнее направление — тем быстрее движемся
      float alignment = cos(diff);
      float adjustedSpeed = speed * max(0, alignment);

      // Двигаемся вперёд
      PVector dir = PVector.fromAngle(angle);
      dir.mult(adjustedSpeed);
      pivot.add(dir.mult(deltaTime));

      // 🦴 Проверяем столкновение с жертвой
      if (checkPreyCollision(nearestPrey)) {
        satiety += nearestPrey.satiety / 2; // хищник получает энергию
        animalsToRemove.add(nearestPrey); // удаляем жертву
      }
    }

    // 🧬 Размножение, если накопил сытость
    if (satiety >= reproductionDemand) {
      reproduce();
    }
  }

  // Поиск ближайшей жертвы (Prey)
  Prey findNearestPrey() {
    Prey nearest = null;
    float minDist = Float.MAX_VALUE;

    for (Animal a : animals) {
      if (a instanceof Prey) { // ищем только жертв
        float d = PVector.dist(pivot, a.pivot);
        if (d < minDist) {
          minDist = d;
          nearest = (Prey)a;
        }
      }
    }

    return nearest;
  }

  // Проверяем столкновение с жертвой
  boolean checkPreyCollision(Prey prey) {
    float d = PVector.dist(pivot, prey.pivot);
    return d < (this.radius + prey.radius);
  }

  @Override
  void display() {
    pushMatrix();
    fill(255, 0, 0); // 🔴 красный — хищник
    translate(pivot.x, pivot.y);
    rotate(angle);
    drawTriangle(0, -size, 0, size, size * 2, 0);
    popMatrix();
  }

  void reproduce() {
    satiety /= 2;
    Predator child = new Predator(pivot.x + random(-20, 20), pivot.y + random(-20, 20), size);
    child.satiety = this.satiety;
    animalsToAdd.add(child);
  }
}
