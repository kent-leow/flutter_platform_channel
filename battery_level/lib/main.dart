import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:rive/rive.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  static const EventChannel channel = EventChannel('flutter_native_channel');
  SMINumber? _bump;
  int _batteryLevel = 0;

  @override
  void initState() {
    channel.receiveBroadcastStream().listen((event) {
      setState(() {
        _batteryLevel = event as int;
        _hitBump(_batteryLevel.toDouble());
      });
    });
    super.initState();
  }

  void _onRiveInit(Artboard artboard) {
    final controller =
        StateMachineController.fromArtboard(artboard, 'State Machine');
    artboard.addController(controller!);
    _bump = controller.findInput<double>('Load Percentage') as SMINumber;
    _hitBump(_batteryLevel.toDouble());
  }

  void _hitBump(double value) {
    _bump?.change(value);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: const Text('Battery Level'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              'Battery level from native:',
              style: Theme.of(context).textTheme.headlineMedium,
            ),
            Text(
              _batteryLevel.toString(),
              style: Theme.of(context).textTheme.headlineMedium,
            ),
            SizedBox.fromSize(
              size: Size(MediaQuery.of(context).size.width,
                  MediaQuery.of(context).size.width),
              child: RiveAnimation.asset(
                'assets/battery.riv',
                onInit: _onRiveInit,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
