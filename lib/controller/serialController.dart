import 'dart:async';
import 'dart:typed_data';

import 'package:get/get.dart';
import 'package:usb_serial/transaction.dart';
import 'package:usb_serial/usb_serial.dart';

class SerialController extends GetxController {
  UsbPort _port;
  StreamSubscription<String> _subscription;
  Transaction<String> _transaction;
  int _deviceId;
  String logMessage = "";
  final hardwareKeyConnected = false.obs;
  final serialData = "".obs;

  Future<bool> _connectTo(device) async {
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
      return true;
    }

    _port = await device.create();
    if (!await _port.open()) {
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
      serialData.value = line;
    });

    return true;
  }

  void _getPorts() async {
    List<UsbDevice> devices = await UsbSerial.listDevices();

    bool targetDeviceFound = false;
    devices.forEach((device) {
      targetDeviceFound = true;

      if (!hardwareKeyConnected.value) {
        _connectTo(device).then((res) {
          hardwareKeyConnected.value = res;
        });
      }
    });

    if (!targetDeviceFound) {
      hardwareKeyConnected.value = false;
    }
    // _connectTo(device).then((res) {
    //   hardwareKeyConnected.value = res;
    // setState(() {
    //   if (_ports.length > 0) {
    //     color = Colors.green;
    //   } else {
    //     color = Colors.red;
    //   }
    // });
  }

  void sendString(String text) async {
    if (_port == null) return;
    await _port.write(Uint8List.fromList(text.codeUnits));
  }

  @override
  void onInit() {
    super.onInit();
    UsbSerial.usbEventStream.listen((UsbEvent event) {
      _getPorts();
    });
    _getPorts();
  }

  @override
  void onClose() {
    _connectTo(null);
    super.onClose();
  }
}
