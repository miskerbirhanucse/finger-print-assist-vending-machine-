import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:get/get.dart';
import 'package:messayproject/controller/serialController.dart';
import '../controller/userController.dart';

class MainPage extends StatefulWidget {
  @override
  _MainPageState createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  final value = Get.arguments;
  final serial = Get.find<SerialController>();

  final userController = Get.put(UserController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: SingleChildScrollView(
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Text(
                      value.name,
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    Text(
                      "Your Amount is ",
                      style: TextStyle(fontSize: 16),
                    ),
                    Text(
                      "${value.amount} ETB",
                      style:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    )
                  ],
                ),
                SizedBox(
                  height: 30,
                ),
                Text(
                  "What Do you Want ?",
                  style: TextStyle(fontSize: 23),
                ),
                SizedBox(
                  height: 20,
                ),
                buildRow('assets/images/sunchips.png', "15 ETB", 15, "1"),
                buildRow('assets/images/Moya.png', "10 ETB", 10, "2"),
                buildRow('assets/images/colo.png', "8 ETB", 8, "3"),
                buildRow('assets/images/Capuchuno.png', "5 ETB", 5, "4"),
                Obx(() {
                  final serialData =
                      Get.find<SerialController>().serialData.value.toString();
                  if (serialData == "F") {
                    return NextPage();
                  }
                  return CircularProgressIndicator();
                })
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget NextPage() {
    SchedulerBinding.instance.addPostFrameCallback((_) {
      Get.toNamed(
        '/firstPage',
      );
    });
  }

  Widget buildRow(String name, String amount, int price, String value1) {
    return InkWell(
      child: Row(
        children: [
          Image.asset(
            name,
            width: 150,
            height: 150,
            fit: BoxFit.contain,
          ),
          SizedBox(
            width: 80,
          ),
          Text(
            amount,
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
          ),
        ],
      ),
      onTap: () async {
        int newAmount = value.amount - price;
        setState(() {
          value.amount = newAmount;
        });
        var result = await userController.updateUser(value);
        serial.sendString(value1);
      },
    );
  }
}
