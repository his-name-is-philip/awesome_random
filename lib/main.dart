import 'package:awesome_random/logics.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

void main() {
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
        // This is the theme of your application.
        //
        // TRY THIS: Try running your application with "flutter run". You'll see
        // the application has a purple toolbar. Then, without quitting the app,
        // try changing the seedColor in the colorScheme below to Colors.green
        // and then invoke "hot reload" (save your changes or press the "hot
        // reload" button in a Flutter-supported IDE, or press "r" if you used
        // the command line to start the app).
        //
        // Notice that the counter didn't reset back to zero; the application
        // state is not lost during the reload. To reset the state, use hot
        // restart instead.
        //
        // This works for code too, not just values: Most code changes can be
        // tested with just a hot reload.
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'Homeless Page'),
    );
  }
}

// enum NameType {
//   firstName('first name'),
//   surname('surname'),
//   fullName('full name');
//
//   const NameType(this.value);
//
//   final String value;
// }

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  Map<int, Widget> segmentHeaders = const <int, Widget>{
    0: Padding(
        padding: EdgeInsets.symmetric(horizontal: 20),
        child: Text('\u{00A0}first name\u{00A0}')),
    1: Padding(
        padding: EdgeInsets.symmetric(horizontal: 20),
        child: Text('\u{00A0}surname\u{00A0}')),
    2: Padding(
        padding: EdgeInsets.symmetric(horizontal: 20),
        child: Text('\u{00A0}full name\u{00A0}'))
  };

  int selectedSegment = 0;
  var iAmLoading = false;

  String loadedFirst = '', loadedSurname = '', loadedFull = '';
  GlobalKey textKey = GlobalKey(debugLabel: "text");

  set generatedName(String s) {
    switch (selectedSegment) {
      case 0: loadedFirst = s;
      case 1: loadedSurname = s;
      case 2: loadedFull = s;
    }
  } 

  String get generatedName {
    return switch (selectedSegment) {
      0 => loadedFirst,
      1 => loadedSurname,
      2 => loadedFull
    }
  }

  @override
  Widget build(BuildContext context) {
    final loadedText = Text(
      generatedName,
      key: textKey,
      style: Theme.of(context).textTheme.headlineMedium,
    );
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: Align(
        // alignment: Alignment.topCenter,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            CupertinoSegmentedControl<int>(
              children: segmentHeaders,
              onValueChanged: (int i) {
                setState((){selectedSegment = i;});
              },
              groupValue: selectedSegment,
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
            ),
            const Text('Generated name:'),
            Expanded(
                child:
                    iAmLoading ? const LinearProgressIndicator() : loadedText),
            ElevatedButton(
                onPressed: () async {
                  iAmLoading = true;
                  setState((){
                    iAmLoading = true;});
                  generatedName =
                      await getSomeName(NameType.values[selectedSegment]);
                  setState((){
iAmLoading = false});
                },
                child: const Text('gen'))
          ],
        ),
      ),
    );
  }
}
