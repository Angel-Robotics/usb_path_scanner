import 'package:flutter/material.dart';
import 'package:quick_usb/quick_usb.dart';

class QuickUsbTestPage extends StatefulWidget {
  @override
  _QuickUsbTestPageState createState() => _QuickUsbTestPageState();
}

class _QuickUsbTestPageState extends State<QuickUsbTestPage> {
  List<UsbDevice>? deviceList;
  Future initQuickUsb() async {
    await QuickUsb.init();
    deviceList = await QuickUsb.getDeviceList();
    print(">>> $deviceList");

    setState(() {

    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    initQuickUsb();
  }

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
            MaterialButton(onPressed: ()async{
              await QuickUsb.exit();
              }, child: Text("종료"),),
            Container(
              height: 360,
              decoration: BoxDecoration(
                color: Colors.blue
              ),
              child: ListView.builder(itemBuilder: (context, index){
                return ListTile(
                  title: Text("${deviceList?[index].vendorId} / ${deviceList?[index].productId} / ${deviceList?[index].identifier}"),
                );
              }),
            )
          ],
        ),
      ),
    );
  }
}
