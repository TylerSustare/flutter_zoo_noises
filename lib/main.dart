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
        resetAnimals: () => setState(() => _animals = Animals.getAnimals()),
        mixUpAnimals: () => setState(
          () => _animals = Animals.getRandomAnimals(),
        ),
        setColor: () => setState(() => _color = getColor(_color)),
        title: _title,
        setSecretCount: () => setState(() {
          _secretCount = _secretCount + 1;
          if (_secretCount >= 10) {
            _secretMode = true;
          }
        }),
        secretMode: _secretMode,
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
          return Center(
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
                      height: orientation == Orientation.portrait ? 220 : 300,
                      width: double.infinity,
                      child: Ink(
                        decoration: BoxDecoration(
                          image: DecorationImage(
                            image: AssetImage('assets/images/$animalName.jpeg'),
                          ),
                        ),
                        child: InkWell(
                          splashColor: getColor(),
                          splashFactory: InkSplash.splashFactory,
                          onTap: () => Audio.play(animalName: animalName),
                          onDoubleTap: secretMode
                              ? () => Audio.play(animalName: animalName)
                              : null,
                        ),
                      ),
                    )
                  ],
                );
              },
            ),
          );
        },
      ),
    );
  }
}
