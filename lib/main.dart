import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:home_indicator/home_indicator.dart';
import 'package:zoo_noises/animals.dart';
import 'package:zoo_noises/colors.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    HomeIndicator.deferScreenEdges([ScreenEdge.bottom]);
    return MaterialApp(
      title: 'Zoo Noises',
      theme: ThemeData(primarySwatch: getColor()),
      home: HomePage(title: 'Zoo Noises'),
    );
  }
}

class HomePage extends StatelessWidget {
  const HomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(title)),
      body: Center(
        child: ListView.builder(
          itemCount: Animals.spoon.length,
          itemBuilder: (BuildContext context, int index) {
            String animalName = Animals.spoon[index].name;
            return Column(
              children: [
                ListTile(
                  title: Text(animalName.toUpperCase()),
                  trailing: Text(animalName[0].toUpperCase()),
                ),
                InkWell(
                  child: Image(image: AssetImage('images/$animalName.jpeg')),
                  onTap: () async {
                    await AudioPlayer().play(
                      'audio/$animalName.mp3',
                      isLocal: true,
                    );
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
