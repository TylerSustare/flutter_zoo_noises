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
      Animal(name: 'camel'),
      Animal(name: 'cat'),
      Animal(name: 'cheetah'),
      Animal(name: 'cougar'),
      Animal(name: 'dog'),
      Animal(name: 'dolphin'),
      // Animal(name: 'dragon'),
      // Animal(name: 'dragon_2'),
      Animal(name: 'eagle'),
      Animal(name: 'elephant'),
      Animal(name: 'falcon'),
      Animal(name: 'frog'),
      Animal(name: 'gorilla'),
      Animal(name: 'hippo'),
      Animal(name: 'iguana'),
      Animal(name: 'jaguar'),
      Animal(name: 'lamb'),
      Animal(name: 'leopard'),
      Animal(name: 'lion'),
      Animal(name: 'moose'),
      Animal(name: 'orca'),
      Animal(name: 'otter'),
      Animal(name: 'penguin'),
      Animal(name: 'raccoon'),
      Animal(name: 'sea-lion'),
      Animal(name: 'seal'),
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
