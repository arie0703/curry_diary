import 'package:flutter/material.dart';
import 'package:curry_app/components/inquiry/CreateMessage.dart';
import 'package:curry_app/components/inquiry/Messages.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'dart:io';

class Inquiry extends StatefulWidget {
  @override
  _InquiryState createState() => _InquiryState();
}

class _InquiryState extends State<Inquiry> {
  String deviceId = "";

  void getDeviceUniqueId() async {
    var deviceIdentifier = 'unknown';
    var deviceInfo = DeviceInfoPlugin();

    if (Platform.isAndroid) {
      var androidInfo = await deviceInfo.androidInfo;
      deviceIdentifier = androidInfo.androidId!;
    } else if (Platform.isIOS) {
      var iosInfo = await deviceInfo.iosInfo;
      deviceIdentifier = iosInfo.identifierForVendor!;
    }

    setState(() {
      deviceId = deviceIdentifier;
    });

    debugPrint(deviceId);
  }

  @override
  void initState() {
    super.initState();
    getDeviceUniqueId();
  }

  Widget build(BuildContext context) {
    return Scaffold(
        body: Container(
            margin: EdgeInsets.all(20),
            child: Center(
              child: Column(
                children: [
                  Text("不具合等ございましたらご連絡ください。"),
                  const SizedBox(height: 10),
                  SizedBox(
                    width: 200,
                    height: 40,
                    child: ElevatedButton(
                      child: Text("お問い合わせをする"),
                      onPressed: () {
                        BuildContext mainContext = context;
                        showModalBottomSheet(
                            backgroundColor: Colors.transparent,
                            context: context,
                            isScrollControlled: true,
                            builder: (BuildContext context) {
                              return CreateMessage(deviceId: deviceId);
                            });
                      },
                    ),
                  ),
                  const SizedBox(height: 10),
                  Padding(
                    padding: EdgeInsets.all(10),
                    child: Text("問い合わせ履歴"),
                  ),
                  Messages(deviceId: deviceId),
                ],
              ),
            )));
  }
}
