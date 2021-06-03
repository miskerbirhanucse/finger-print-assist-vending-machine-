import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:get/get.dart';
import '../controller/serialController.dart';
import 'package:usb_serial/usb_serial.dart';
import 'package:usb_serial/transaction.dart';
import '../controller/userController.dart';
import '../model/user.dart';
import 'dart:typed_data';
import 'dart:async';

import 'mainPage.dart';

class FirstScreen extends StatefulWidget {
  @override
  _FirstScreenState createState() => _FirstScreenState();
}

class _FirstScreenState extends State<FirstScreen> {
  final _userController = UserController();

  List<User> _usersList = [];

  UsbPort _port;
  String _status = "Idle";
  Color color = Colors.red;
  List<Widget> _ports = [];
  String _serialData;
  StreamSubscription<String> _subscription;
  Transaction<String> _transaction;
  int _deviceId;
  TextEditingController _textController = TextEditingController();

  getAllUsers() async {
    var users = await _userController.readUser();
    users.forEach((user) {
      setState(() {
        var userModel = User();
        userModel.id = user['id'];
        userModel.fingerPrint = user['fingerPrint'];
        userModel.name = user['name'];
        userModel.amount = user['amount'];
        _usersList.add(userModel);
      });
    });
  }

  Future<bool> _connectTo(device) async {
    _serialData = "";

    if (_subscription != null) {
      _subscription.cancel();
      _subscription = null;
    }

    if (_transaction != null) {
      _transaction.dispose();
      _transaction = null;
    }

    if (_port != null) {
      _port.close();
      _port = null;
    }

    if (device == null) {
      _deviceId = null;
      setState(() {
        _status = "Disconnected";
      });
      return true;
    }

    _port = await device.create();
    if (!await _port.open()) {
      setState(() {
        _status = "Failed to open port";
      });
      return false;
    }

    _deviceId = device.deviceId;
    await _port.setDTR(true);
    await _port.setRTS(true);
    await _port.setPortParameters(
        115200, UsbPort.DATABITS_8, UsbPort.STOPBITS_1, UsbPort.PARITY_NONE);

    _transaction = Transaction.stringTerminated(
        _port.inputStream, Uint8List.fromList([13, 10]));

    _subscription = _transaction.stream.listen((String line) {
      setState(() {
        print(line);
        _serialData = line;
        // if (_serialData.length > 20) {
        //   _serialData.removeAt(0);
        // }
      });
    });
    // List<Widget> a = _serialData.reversed.toList();
    // print(a);
    setState(() {
      _status = "Connected";
    });

    return true;
  }

  void _getPorts() async {
    _ports = [];
    List<UsbDevice> devices = await UsbSerial.listDevices();
    print(devices);
    devices.forEach((device) {
      _ports.add(ListTile(
          leading: Icon(Icons.usb),
          title: Text(device.productName),
          subtitle: Text(device.manufacturerName),
          trailing: RaisedButton(
            child:
                Text(_deviceId == device.deviceId ? "Disconnect" : "Connect"),
            onPressed: () {
              _connectTo(_deviceId == device.deviceId ? null : device)
                  .then((res) {
                _getPorts();
              });
            },
          )));
    });
    setState(() {
      if (_ports.length > 0) {
        color = Colors.green;
      } else {
        color = Colors.red;
      }
    });
  }

  @override
  void initState() {
    super.initState();

    UsbSerial.usbEventStream.listen((UsbEvent event) {
      _getPorts();
    });

    _getPorts();
    getAllUsers();
  }

  @override
  void dispose() {
    super.dispose();
    _connectTo(null);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          Center(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  Image.asset(
                    'assets/images/finger.jpg',
                    width: 200,
                    height: 500,
                    fit: BoxFit.contain,
                  ),
                  Text(
                    'Put your Finger Print',
                    style: TextStyle(fontSize: 18, color: Colors.white),
                  ),
                  SizedBox(
                    height: 24,
                  ),
                  Center(
                    child: Obx(() {
                      final connected = Get.find<SerialController>()
                          .hardwareKeyConnected
                          .value;
                      if (connected) {
                        final serialData = Get.find<SerialController>()
                            .serialData
                            .value
                            .toString();
                        if (serialData == "E") {
                          return Text("Finger Print is not Found",
                              style:
                                  TextStyle(fontSize: 18, color: Colors.red));
                        }
                        switch (serialData) {
                          case "A":
                            {
                              SchedulerBinding.instance
                                  .addPostFrameCallback((_) {
                                // add your code here.
                                Get.toNamed('/mainPage',
                                    arguments: _usersList[0]);
                              });
                              break;
                            }
                          case "B":
                            {
                              SchedulerBinding.instance
                                  .addPostFrameCallback((_) {
                                // add your code here.

                                Get.toNamed('/mainPage',
                                    arguments: _usersList[1]);
                              });
                              break;
                            }
                          case "C":
                            {
                              SchedulerBinding.instance
                                  .addPostFrameCallback((_) {
                                Get.toNamed('/mainPage',
                                    arguments: _usersList[2]);
                              });
                              break;
                            }
                          case "D":
                            {
                              SchedulerBinding.instance
                                  .addPostFrameCallback((_) {
                                Get.toNamed('/mainPage',
                                    arguments: _usersList[3]);
                              });
                              break;
                            }

                          default:
                            {
                              break;
                            }
                        }
                      }
                      return Text("no value");
                    }),
                  ),
                ],
              ),
            ),
          ),
          Positioned(
            top: 30,
            left: 250,
            right: 0,
            child: Center(
              child: Container(
                color: color,
                width: 20,
                height: 20,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
