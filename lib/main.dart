import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:home_indicator/home_indicator.dart';
import 'package:zoo_noises/animals.dart';
import 'package:zoo_noises/colors.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  String _title = 'Zoo Noises';
  MaterialColor _color = getColor();
  List<Animal> _animals = Animals.getAnimals();

  @override
  Widget build(BuildContext context) {
    HomeIndicator.deferScreenEdges([ScreenEdge.bottom]);
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: _title,
      theme: ThemeData(primarySwatch: _color),
      home: HomePage(
        animals: _animals,
        color: _color,
        resetAnimals: () => setState(() => _animals = Animals.getAnimals()),
        setAnimals: () => setState(() => _animals = Animals.getRandomAnimals()),
        setColor: () => setState(() => _color = getColor(_color)),
        title: _title,
      ),
    );
  }
}

class HomePage extends StatelessWidget {
  const HomePage({
    Key? key,
    required this.animals,
    required this.color,
    required this.resetAnimals,
    required this.setAnimals,
    required this.setColor,
    required this.title,
  }) : super(key: key);

  final List<Animal> animals;
  final MaterialColor color;
  final void Function() resetAnimals;
  final void Function() setAnimals;
  final void Function() setColor;
  final String title;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
            icon: Icon(Icons.sort_by_alpha),
            onPressed: resetAnimals,
          ),
          IconButton(
            icon: Icon(Icons.shuffle),
            onPressed: setAnimals,
          ),
        ],
        leading: IconButton(
          icon: Icon(Icons.color_lens),
          onPressed: setColor,
        ),
        title: GestureDetector(
          child: Text(title),
          onTap: () {},
        ),
        centerTitle: true,
      ),
      body: Center(
        child: ListView.builder(
          itemCount: animals.length,
          itemBuilder: (BuildContext context, int index) {
            String animalName = animals[index].name;
            return Column(
              children: [
                ListTile(
                  title: Text(animalName.toUpperCase()),
                  trailing: Text(animalName[0].toUpperCase()),
                ),
                InkWell(
                  child: Image(image: AssetImage('images/$animalName.jpeg')),
                  onTap: () {
                    AudioPlayer().play('audio/$animalName.mp3', isLocal: true);
                  },
                  onDoubleTap: () {
                    AudioPlayer().play('audio/$animalName.mp3', isLocal: true);
                  },
                )
              ],
            );
          },
        ),
      ),
    );
  }
}