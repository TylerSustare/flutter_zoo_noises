import 'dart:math';

import 'package:confetti/confetti.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:home_indicator/home_indicator.dart';
import 'animals.dart';
import 'colors.dart';
import 'audio.dart';

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
  int _secretCount = 0;
  bool _secretMode = false;

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
        title: _title,
        secretMode: _secretMode,
        resetAnimals: () => setState(() {
          _animals = Animals.getAnimals(secretMode: _secretMode);
        }),
        mixUpAnimals: () => setState(() {
          _animals = Animals.getRandomAnimals(secretMode: _secretMode);
        }),
        setSecretCount: () => setState(() {
          _secretCount = _secretCount + 1;
          if (_secretCount >= 10) {
            _secretMode = true;
          }
        }),
        setColor: () => setState(() => _color = getColor(_color)),
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
    required this.mixUpAnimals,
    required this.setColor,
    required this.title,
    required this.secretMode,
    required this.setSecretCount,
  }) : super(key: key);

  final List<Animal> animals;
  final MaterialColor color;
  final void Function() resetAnimals;
  final void Function() mixUpAnimals;
  final void Function() setColor;
  final void Function() setSecretCount;
  final bool secretMode;
  final String title;

  void _enableSecretMode(FToast fToast) {
    if (secretMode) {
      _showToast(fToast);
    }
  }

  void _showToast(FToast fToast) {
    Widget toast = Container(
      padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 12.0),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(25.0),
        color: Colors.greenAccent,
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.check),
          SizedBox(
            width: 12.0,
          ),
          Text("You have enabled super secret mode"),
        ],
      ),
    );

    fToast.showToast(
      child: toast,
      gravity: ToastGravity.BOTTOM,
      toastDuration: Duration(seconds: 2),
    );
  }

  @override
  Widget build(BuildContext context) {
    final fToast = FToast();
    fToast.init(context);

    return Scaffold(
      appBar: AppBar(
        actions: [
          // IconButton(
          //   icon: Icon(Icons.sort_by_alpha),
          //   onPressed: resetAnimals,
          // ),
          IconButton(
            icon: Icon(Icons.shuffle),
            onPressed: mixUpAnimals,
          ),
        ],
        leading: IconButton(
          icon: Icon(Icons.color_lens),
          onPressed: setColor,
        ),
        title: GestureDetector(
          child: Text(title),
          onDoubleTap: () {
            setSecretCount();
            _enableSecretMode(fToast);
          },
        ),
        centerTitle: true,
      ),
      body: OrientationBuilder(
        builder: (context, orientation) {
          return Stack(
            children: [
              AnimalList(
                animals: animals,
                secretMode: secretMode,
                orientation: orientation,
              ),
            ],
          );
        },
      ),
    );
  }
}

class AnimalList extends StatelessWidget {
  const AnimalList({
    Key? key,
    required this.animals,
    required this.secretMode,
    required this.orientation,
  }) : super(key: key);

  final List<Animal> animals;
  final bool secretMode;
  final Orientation orientation;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: ListView.builder(
        itemCount: animals.length,
        itemBuilder: (BuildContext context, int index) {
          String animalName = animals[index].name;
          return AnimalCard(
            animalName: animalName,
            secretMode: secretMode,
            orientation: orientation,
          );
        },
      ),
    );
  }
}

class AnimalCard extends StatefulWidget {
  const AnimalCard({
    Key? key,
    required this.animalName,
    required this.secretMode,
    required this.orientation,
  }) : super(key: key);

  final String animalName;
  final bool secretMode;
  final Orientation orientation;

  @override
  _AnimalCardState createState() => _AnimalCardState();
}

class _AnimalCardState extends State<AnimalCard> {
  late ConfettiController confettiController;

  @override
  void initState() {
    super.initState();
    confettiController = ConfettiController(
      duration: const Duration(milliseconds: 200),
    );
  }

  @override
  void dispose() {
    confettiController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          alignment: Alignment.center,
          child: ConfettiWidget(
            confettiController: confettiController,
            blastDirectionality:
                BlastDirectionality.explosive, // blast randomly
            colors: colors,
            createParticlePath: drawStar,
            numberOfParticles: 100,
            emissionFrequency: 0, // only blast once
            gravity: 0.2,
            minBlastForce: 7,
          ),
        ),
        ListTile(
          title: Text(
            widget.animalName.toUpperCase(),
            style: TextStyle(
              fontSize: MediaQuery.of(context).size.width / 22,
            ),
          ),
          trailing: Text(
            widget.animalName[0].toUpperCase(),
            style: TextStyle(
              fontSize: MediaQuery.of(context).size.width / 22,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        SizedBox(
          key: Key(widget.animalName),
          height: _getHeight(
            animal: widget.animalName,
            orientation: widget.orientation,
            context: context,
          ),
          width: double.infinity,
          child: Ink(
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/images/${widget.animalName}.jpeg'),
              ),
            ),
            child: InkWell(
              splashColor: getColor(),
              splashFactory: InkSplash.splashFactory,
              onTap: () => Audio.play(animalName: widget.animalName),
              onLongPress: () {
                confettiController.play();
                Audio.play(animalName: widget.animalName);
              },
              onDoubleTap: widget.secretMode
                  ? () => Audio.play(animalName: widget.animalName)
                  : null,
            ),
          ),
        ),
      ],
    );
  }
}

double _getHeight({
  required String animal,
  required Orientation orientation,
  required BuildContext context,
}) {
  double height = orientation == Orientation.portrait
      ? MediaQuery.of(context).size.height / 3.8
      : MediaQuery.of(context).size.height / 1.2;
  if (animal == 'dragon_2') {
    return height * 2;
  }
  return height;
}

/// A custom Path to paint stars.
Path drawStar(Size _size) {
  Size size = _size * 2;
  // convert degree to radians
  double degToRad(double deg) => deg * (pi / 180.0);

  const numberOfPoints = 5;
  final halfWidth = size.width / 2;
  final externalRadius = halfWidth;
  final internalRadius = halfWidth / 2.5;
  final degreesPerStep = degToRad(360 / numberOfPoints);
  final halfDegreesPerStep = degreesPerStep / 2;
  final path = Path();
  final fullAngle = degToRad(360);
  path.moveTo(size.width, halfWidth);

  for (double step = 0; step < fullAngle; step += degreesPerStep) {
    path.lineTo(
      halfWidth + externalRadius * cos(step),
      halfWidth + externalRadius * sin(step),
    );
    path.lineTo(
      halfWidth + internalRadius * cos(step + halfDegreesPerStep),
      halfWidth + internalRadius * sin(step + halfDegreesPerStep),
    );
  }
  path.close();
  return path;
}
