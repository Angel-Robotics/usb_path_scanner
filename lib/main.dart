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
  MyHomePage({Key? key, this.title}) : super(key: key);
  final String? title;

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
  void refreshCounter() {
    setState(() {
      _counter = 0;
    });
  }

  List<String> pathItems = [];
  List<FileSystemEntity> storageItems = [];

  Future refreshPath() async {
    pathItems.clear();
    storageItems.clear();
    getExternalStorageDirectory().then((value) {
      print(">>> 0  $value");
      print(">>> 1 ${value!.parent}");
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
    refreshPath();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title!),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            ListTile(
              title: Text("저장소권한"),
              onTap: () async {
                var status = await Permission.storage.status;
                if (!status.isGranted) {
                  await Permission.storage.request();
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("${status}")));
                }
                // Permission.storage.request();
              },
              onLongPress: () async {
                ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("${await Permission.storage.status}")));
              },
            ),
            Divider(),
            ListTile(
              title: Text("manageExternalStorage"),
              onTap: () {
                Permission.manageExternalStorage.request();
              },
            ),
            Divider(),
            IconButton(
                icon: Icon(Icons.refresh),
                onPressed: () {
                  refreshPath();
                }),
            Divider(),

            Padding(
              padding: const EdgeInsets.all(16.0),
              child: IconButton(
                  icon: Icon(Icons.check_circle_outline),
                  onPressed: () async {
                    pathItems.clear();
                    // List<UsbDevice> devices = await UsbSerial.listDevices();
                    //
                    // print(devices);
                    int idx = 0;
                    if (storageItems.length > 2) {
                      print(storageItems[idx].path);
                      pathItems.add("----------------------");
                      // pathItems.add("${devices.toString()}");
                      pathItems.add("----------------------");
                      pathItems.add("${storageItems[idx]}");
                      pathItems.add("path: ${storageItems[idx].path}");
                      pathItems.add("absolute: ${storageItems[idx].absolute}");
                      pathItems.add("uri: ${storageItems[idx].uri}");

                      pathItems.add("${join(storageItems[idx].path, "AngelLegsTest/")}");
                      Directory topPath = Directory(join(storageItems[idx].path, "AngelLegsTest/"));
                      print("topPath: $topPath");
                      pathItems.add("----------------------");
                      pathItems.add("topPath: ${topPath.path}");
                      setState(() {});
                      try {
                        if (!await topPath.exists()) {
                          await topPath.create();

                          pathItems.add("topPath: Created");
                          ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Create!")));
                        } else {
                          pathItems.add("topPath: already exist");
                        }
                      } catch (e) {
                        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("${e.toString()}")));
                        pathItems.add("${e.toString()}");
                      }

                      Directory childPath = Directory(join(topPath.path, "Report/"));
                      print("childPath: $childPath");
                      pathItems.add("----------------------");
                      pathItems.add("child: ${childPath.path}");

                      try {
                        if (!await childPath.exists()) {
                          await childPath.create();
                          ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Create!")));
                          pathItems.add("childPath: Created");
                        } else {
                          pathItems.add("childPath: already exist");
                        }
                      } catch (e) {
                        pathItems.add("${e.toString()}");
                        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("${e.toString()}")));
                      }

                      Directory tempPath = Directory(join(childPath.path,
                          "Hello_${DateTime.now().year}${DateTime.now().month}${DateTime.now().day}_${DateTime.now().millisecond}.txt"));

                      try {
                        File f = File(tempPath.path);
                        await f.writeAsString("Hello World");
                        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Done!")));
                      } catch (e) {
                        pathItems.add("${e.toString()}");
                        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("${e.toString()}")));
                      }
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("발견된 외부 장치가 없습니다.")));
                    }
                    setState(() {});
                  }),
            ),
            ListTile(
              title: Text("폴더 읽기 "),
              trailing: Text("$_counter"),
              onTap: () async {
                pathItems.clear();
                if (storageItems.length > 2) {
                  print(storageItems[_counter].path);
                  pathItems.add("----------------------");
                  // pathItems.add("${devices.toString()}");
                  pathItems.add("----------------------");
                  pathItems.add("${storageItems[_counter]}");
                  pathItems.add("path: ${storageItems[_counter].path}");
                  pathItems.add("absolute: ${storageItems[_counter].absolute}");
                  pathItems.add("uri: ${storageItems[_counter].uri}");

                  try {
                    Directory tempPath = Directory(storageItems[_counter].path);
                     tempPath.listSync().forEach((element) {
                       pathItems.add(element.path);
                     });



                  } catch (e) {
                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("${e.toString()}")));
                    pathItems.add("${e.toString()}");
                  }
                  setState(() {});
                }
              },
            ),
            ListTile(
              title: Text("폴더만들기 1 "),
              trailing: Text("$_counter"),
              onTap: () async {
                pathItems.clear();
                if (storageItems.length > 2) {
                  print(storageItems[_counter].path);
                  pathItems.add("----------------------");
                  // pathItems.add("${devices.toString()}");
                  pathItems.add("----------------------");
                  pathItems.add("${storageItems[_counter]}");
                  pathItems.add("path: ${storageItems[_counter].path}");
                  pathItems.add("absolute: ${storageItems[_counter].absolute}");
                  pathItems.add("uri: ${storageItems[_counter].uri}");

                  pathItems.add("${join(storageItems[_counter].path, "AngelLegsTest/")}");
                  Directory topPath = Directory(join(storageItems[_counter].path, "AngelLegsTest/"));
                  print("topPath: $topPath");
                  pathItems.add("----------------------");
                  pathItems.add("topPath: ${topPath.path}");
                  try {
                    if (!await topPath.exists()) {
                      await topPath.create();

                      pathItems.add("topPath: Created");
                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Create!")));
                    } else {
                      pathItems.add("topPath: already exist");
                    }

                  } catch (e) {
                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("${e.toString()}")));
                    pathItems.add("${e.toString()}");
                  }
                  setState(() {});
                }
              },
            ),
            ListTile(
              title: Text("파일쓰기"),
              trailing: Text("$_counter"),
              onTap: () async {
                pathItems.clear();
                Directory? d =  await getExternalStorageDirectory() ;
                File df = File(join(d!.path, "hello.txt"));
                try {
                  await df.writeAsString("helldjfsl");
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("completed write ")));
                } catch (e) {
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("${e.toString()}")));
                  pathItems.add("${e.toString()}");
                }

                if (storageItems.length > 2) {
                  print(storageItems[_counter].path);
                  pathItems.add("----------------------");
                  pathItems.add("${storageItems[_counter]}");
                  pathItems.add("path: ${storageItems[_counter].path}");
                  pathItems.add("absolute: ${storageItems[_counter].absolute}");
                  pathItems.add("uri: ${storageItems[_counter].uri}");

                  pathItems.add("${join(storageItems[_counter].path, "AngelLegsTest/")}");
                  Directory topPath = Directory(join(storageItems[_counter].path, "AngelLegsTest/"));
                  print("topPath: $topPath");
                  pathItems.add("----------------------");
                  pathItems.add("topPath: ${topPath.path}");
                  try {
                    Directory tempPath = Directory(join(storageItems[_counter].path,
                        "Hello_${DateTime.now().year}${DateTime.now().month}${DateTime.now().day}_${DateTime.now().millisecond}.txt"));
                    File f = File(tempPath.path);
                    await f.writeAsString("Hello");
                  } catch (e) {
                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("${e.toString()}")));
                    pathItems.add("${e.toString()}");
                  }
                  setState(() {});
                }
              },
            ),
            ListTile(
              title: Text("파일 복사하기"),
              trailing: Text("$_counter"),
              onTap: () async {
                pathItems.clear();
                Directory? d =  await (getExternalStorageDirectory() );
                File df = File(join(d!.path, "hello.txt"));
                try {
                  await df.writeAsString("helldjfsl");
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("completed write")));
                } catch (e) {
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("${e.toString()}")));
                  pathItems.add("${e.toString()}");
                }

                if (storageItems.length > 2) {
                  print(storageItems[_counter].path);
                  try {
                    Directory tempPath = Directory(storageItems[_counter].path);
                    File f = File(tempPath.path);
                    df.copy(f.path);
                  } catch (e) {
                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("${e.toString()}")));
                    pathItems.add("${e.toString()}");
                  }
                  setState(() {});
                }
              },
            ),
            Divider(),
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
      floatingActionButton: Row(
        children: [
          FloatingActionButton(
            onPressed: _incrementCounter,
            tooltip: 'Increment',
            child: Icon(Icons.add),
          ),
          FloatingActionButton(
            heroTag: "2",
            onPressed: refreshCounter,
            tooltip: 'Increment',
            child: Icon(Icons.refresh),
          ),
        ],
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
