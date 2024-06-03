import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

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
  BasicMessageChannel<String> channel = const BasicMessageChannel<String>(
    'flutter_native_channel',
    StringCodec(),
  );

  String _callbackFromNative = 'No callback from native';
  String _messageFromNative = 'No message from native';

  Future<void> _sendMessageToNative() async {
    final String? callback = await channel.send('I am message from Flutter');
    setState(() {
      _callbackFromNative = callback ?? '';
    });
  }

  @override
  void initState() {
    channel.setMessageHandler((message) async {
      setState(() {
        _messageFromNative = message ?? '';
      });
      return 'I am callback from Flutter';
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: const Text('Simple Message Channel Example'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Text(
              'Callback from native:',
            ),
            Text(
              _callbackFromNative,
              style: Theme.of(context).textTheme.headlineMedium,
            ),
            const Text(
              'Message from native:',
            ),
            Text(
              _messageFromNative,
              style: Theme.of(context).textTheme.headlineMedium,
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _sendMessageToNative,
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ),
    );
  }
}
