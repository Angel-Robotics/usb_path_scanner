import 'dart:io';

import 'package:flutter/material.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:quick_usb/quick_usb.dart';

class QuickUsbTestPage extends StatefulWidget {
  @override
  _QuickUsbTestPageState createState() => _QuickUsbTestPageState();
}

class _QuickUsbTestPageState extends State<QuickUsbTestPage> {
  List<UsbDevice>? deviceList;

  UsbDevice? _selectedDevice;

  Future initQuickUsb() async {
    await QuickUsb.init();
    deviceList = await QuickUsb.getDeviceList();
    print(">>> $deviceList");

    setState(() {});
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    initQuickUsb();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    QuickUsb.exit();
    super.dispose();
  }

  List<String> logList = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("퀵 USB"),
      ),
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            MaterialButton(
              onPressed: () async {
                await QuickUsb.exit();
              },
              child: Text("종료"),
            ),
            Container(
              height: 360,
              decoration: BoxDecoration(color: Colors.blue),
              child: ListView.builder(
                  itemCount: deviceList?.length,
                  itemBuilder: (context, index) {
                    return ListTile(
                      onTap: () {
                        setState(() {
                          _selectedDevice = deviceList?[index];
                        });
                      },
                      title: Text("${deviceList?[index].vendorId} / ${deviceList?[index].productId} / ${deviceList?[index].identifier}"),
                    );
                  }),
            ),
            Divider(),
            ListTile(
              title: Text("${_selectedDevice?.vendorId} / ${_selectedDevice?.productId}"),
            ),
            Divider(),
            ListTile(
              onTap: () async {
                if (_selectedDevice != null) {
                  var hasPermission = await QuickUsb.hasPermission(_selectedDevice!);
                  print('hasPermission $hasPermission');
                  await QuickUsb.requestPermission(_selectedDevice!);
                }
              },
              title: Text("권한 얻기"),
            ),
            ListTile(
              title: Text("파일경로 얻기? "),
              onTap: () {
                try {
                  File _file = File(_selectedDevice!.identifier);
                  print(_file);
                  logList.add(_file.path);

                } catch (e) {
                  setState(() {
                    logList.add(e.toString());
                  });
                }
              },
            ),
            ListTile(
              title: Text("디렉토리 얻기?"),
              onTap: () async {
                try {
                  File _file = File(_selectedDevice!.identifier);
                  print(_file);
                  Directory d = Directory(_file.path);
                  var dItems = d.listSync();
                  dItems.forEach((element) {
                    logList.add(element.path.toString());
                  });

                  setState(() {});
                } catch (e) {
                  setState(() {
                    logList.add(e.toString());
                  });
                }
              },
            ),
            ListTile(
              title: Text("복사하기"),
              onTap: () async {
                var exd = await getExternalStorageDirectory();
                print(exd?.parent);
                print(exd?.parent.parent);
                print(exd?.parent.parent.parent);
                print(exd?.parent.parent.parent.parent);
                print(exd?.parent.parent.parent.parent.path);
                String dPath = exd!.parent.parent.parent.parent.path;
                File _dfile = File(join(dPath, "Download/ma_trend_2021-05-21 13:38:46.192592.pdf"));
                print(_dfile);
                var b = await _dfile.readAsBytes();
                print(b);

                try {

                  File _file = File(_selectedDevice!.identifier);
                  print(_file);
                  await _dfile.copy(_file.path);

                  setState(() {
                    logList.add("Copyed? ");
                  });
                } catch (e) {
                  setState(() {
                    logList.add(e.toString());
                  });
                }
              },
            ),
            Spacer(),
            Container(
              height: 200,
              decoration: BoxDecoration(color: Colors.red),
              child: ListView.builder(
                  itemCount: logList.length,
                  itemBuilder: (context, index) {
                    return Text(logList[index]);
                  }),
            )
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.refresh),
        onPressed: () {
          setState(() {});
        },
      ),
    );
  }
}
