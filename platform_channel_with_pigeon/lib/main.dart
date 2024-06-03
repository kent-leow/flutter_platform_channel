import 'package:flutter/material.dart';
import 'package:platform_channel_with_pigeon/pigeons/message_api.g.dart';

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

class _MyHomePageState extends State<MyHomePage> implements ReverseMessageApi {
  String _callbackFromNative = 'No callback from native';
  String _messageFromNative = 'No message from native';

  Future<void> _sendMessageToNative() async {
    final String callback =
        await MessageApi().getMessageFromNative("I am message from Flutter");
    setState(() {
      _callbackFromNative = callback;
    });
  }

  @override
  void initState() {
    ReverseMessageApi.setUp(this);
    super.initState();
  }

  @override
  Future<String> getMessageFromFlutter(String message) async {
    setState(() {
      _messageFromNative = message;
    });
    return 'I am callback from Flutter';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: const Text('Method Channel with Pigeon Example'),
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
        tooltip: 'Trigger',
        child: const Icon(Icons.call_to_action),
      ),
    );
  }
}
