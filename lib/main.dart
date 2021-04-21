import 'dart:io';

import 'package:flutter/material.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter External USB Path',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(title: 'Flutter External USB Path Scanner'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);
  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _counter = 0;

  void _incrementCounter() {
    setState(() {
      _counter++;
    });
  }

  List<String> pathItems = [];
  List<FileSystemEntity> storageItems = [];

  Future refreshPath() async {
    pathItems.clear();
    storageItems.clear();
    getExternalStorageDirectory().then((value) {
      print(">>> 0  $value");
      print(">>> 1 ${value.parent}");
      print(">>> 2 ${value.parent.parent}");
      print(">>> 3 ${value.parent.parent.parent}");
      print(">>> 4 ${value.parent.parent.parent.parent.toString()}");
      print(">>> 5 ${value.parent.parent.parent.parent.parent.toString()}");
      print(">>> 6 ${value.parent.parent.parent.parent.parent.parent.toString()}");

      List<FileSystemEntity> v = value.parent.parent.parent.parent.parent.parent.listSync();
      storageItems.addAll(v);
      print(v);

      pathItems.add(value.toString());
      pathItems.add(value.parent.toString());
      pathItems.add(value.parent.parent.toString());
      pathItems.add(value.parent.parent.parent.toString());
      pathItems.add("${value.parent.parent.parent.parent.toString()}");
      pathItems.add("${value.parent.parent.parent.parent.parent.toString()}");
      pathItems.add("${value.parent.parent.parent.parent.parent.parent.toString()}");
      pathItems.add("${value.parent.parent.parent.parent.parent.parent.parent.toString()}");
      pathItems.add("-----------------------------------------------------");
      pathItems.add("${v.toString()}");

      setState(() {});
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    Permission.storage.request();
    refreshPath();
  }

  @override
  Widget build(BuildContext context) {
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    return Scaffold(
      appBar: AppBar(
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: Text(widget.title),
      ),
      body: Center(
        // Center is a layout widget. It takes a single child and positions it
        // in the middle of the parent.
        child: Column(
          // Column is also a layout widget. It takes a list of children and
          // arranges them vertically. By default, it sizes itself to fit its
          // children horizontally, and tries to be as tall as its parent.
          //
          // Invoke "debug painting" (press "p" in the console, choose the
          // "Toggle Debug Paint" action from the Flutter Inspector in Android
          // Studio, or the "Toggle Debug Paint" command in Visual Studio Code)
          // to see the wireframe for each widget.
          //
          // Column has various properties to control how it sizes itself and
          // how it positions its children. Here we use mainAxisAlignment to
          // center the children vertically; the main axis here is the vertical
          // axis because Columns are vertical (the cross axis would be
          // horizontal).
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            IconButton(
                icon: Icon(Icons.refresh),
                onPressed: () {
                  refreshPath();
                }),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: IconButton(
                  icon: Icon(Icons.check_circle_outline),
                  onPressed: () async{
                    if (storageItems.length > 2) {
                      print(storageItems[0].path);
                      pathItems.add("----------------------");
                      pathItems.add("${storageItems[0]}");
                      pathItems.add("${storageItems[0].path}");
                      pathItems.add("${storageItems[0].absolute}");
                      pathItems.add("${storageItems[0].uri}");
                      Directory tempPath = Directory(join(storageItems[0].path, "/Angel Legs/Report/Hello_${DateTime.now()}.txt"));
                      File f = File(tempPath.path);
                      await f.writeAsString("Hello World");
                    }
                  }),
            ),
            Text(
              'You have pushed the button this many times:',
            ),
            Text(
              '$_counter',
              style: Theme.of(context).textTheme.headline4,
            ),
            Expanded(
              child: ListView.builder(
                  itemCount: pathItems.length,
                  itemBuilder: (context, index) {
                    return ListTile(
                      title: Text(pathItems[index]),
                    );
                  }),
            )
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _incrementCounter,
        tooltip: 'Increment',
        child: Icon(Icons.add),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
