class Animal {
  String name;
  Animal({this.name: ''});
}

class Animals {
  static List<Animal> getAnimals() {
    return [
      Animal(name: 'anteater'),
      Animal(name: 'antelope'),
      Animal(name: 'bear'),
      Animal(name: 'lion'),
      Animal(name: 'tiger'),
    ];
  }

  static List<Animal> getRandomAnimals() {
    var animals = getAnimals();
    animals.shuffle();
    return animals;
  }
}
