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
  late ConfettiController _confettiController;

  @override
  void initState() {
    super.initState();
    _confettiController = ConfettiController(
      duration: const Duration(milliseconds: 200),
    );
  }

  @override
  void dispose() {
    _confettiController.dispose();
    super.dispose();
  }

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
        confettiController: _confettiController,
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
    required this.confettiController,
  }) : super(key: key);

  final List<Animal> animals;
  final MaterialColor color;
  final void Function() resetAnimals;
  final void Function() mixUpAnimals;
  final void Function() setColor;
  final void Function() setSecretCount;
  final bool secretMode;
  final String title;
  final ConfettiController confettiController;

  /// A custom Path to paint stars.
  Path drawStar(Size size) {
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

  double _getHeight({
    required String animal,
    required Orientation orientation,
  }) {
    double height = orientation == Orientation.portrait ? 220 : 300;
    if (animal == 'dragon_2') {
      return height * 2;
    }
    return height;
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
              Container(
                alignment: Alignment.topCenter,
                child: ConfettiWidget(
                  confettiController: confettiController,
                  blastDirectionality:
                      BlastDirectionality.explosive, // blast randomly
                  colors: colors, // use our colors
                  createParticlePath: drawStar,
                  numberOfParticles: 100,
                  emissionFrequency: 0, // only blast once
                  gravity: 0.1,
                ),
              ),
              Center(
                child: ListView.builder(
                  itemCount: animals.length,
                  itemBuilder: (BuildContext context, int index) {
                    String animalName = animals[index].name;
                    return Column(
                      children: [
                        ListTile(
                          title: Text(animalName.toUpperCase()),
                          trailing: Text(
                            animalName[0].toUpperCase(),
                            style: TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        SizedBox(
                          key: Key(animalName),
                          height: _getHeight(
                            animal: animalName,
                            orientation: orientation,
                          ),
                          width: double.infinity,
                          child: Ink(
                            decoration: BoxDecoration(
                              image: DecorationImage(
                                image: AssetImage(
                                    'assets/images/$animalName.jpeg'),
                              ),
                            ),
                            child: InkWell(
                              splashColor: getColor(),
                              splashFactory: InkSplash.splashFactory,
                              onTap: () => Audio.play(animalName: animalName),
                              onLongPress: () {
                                confettiController.play();
                                Audio.play(animalName: animalName);
                              },
                              onDoubleTap: secretMode
                                  ? () => Audio.play(animalName: animalName)
                                  : null,
                            ),
                          ),
                        ),
                      ],
                    );
                  },
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
