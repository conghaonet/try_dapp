import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:try_dapp/ethereum_utils.dart';

Future<void> main() async {
  await dotenv.load(fileName: ".env");
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  BigInt _counter = BigInt.zero;
  String _txHashSend = '';
  String _txHashWithDraw = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              _counter.toString(),
              style: Theme.of(context).textTheme.headlineMedium,
            ),
            ElevatedButton(
              onPressed: () async {
                _counter = await EthereumUtils().getBalance();
                setState(() {

                });
              },
              child: const Text('getBalance'),
            ),

            Text(
              _txHashSend.toString(),
            ),
            ElevatedButton(
              onPressed: () async {
                _txHashSend = await EthereumUtils().sendBalance(1);
                setState(() {
                });
              },
              child: const Text('sendBalance +1'),
            ),

            Text(
              _txHashWithDraw.toString(),
            ),
            ElevatedButton(
              onPressed: () async {
                _txHashWithDraw = await EthereumUtils().withDrawBalance(1);
                setState(() {
                });
              },
              child: const Text('withDrawBalance -1'),
            ),
          ],
        ),
      ),
    );
  }
}
