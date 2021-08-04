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
      Animal(name: 'iguana'),
      Animal(name: 'lion'),
      Animal(name: 'moose'),
      Animal(name: 'tiger'),
      Animal(name: 'turkey'),
      Animal(name: 'wolf'),
      Animal(name: 'zebra'),
    ];
  }

  static List<Animal> getRandomAnimals() {
    var animals = getAnimals();
    animals.shuffle();
    return animals;
  }
}
