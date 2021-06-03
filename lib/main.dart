import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:messayproject/controller/serialController.dart';
import './pages/firstScreen.dart';
import './pages/mainPage.dart';

void main() {
  LazyBindings().dependencies();
  runApp(GetMaterialApp(
      home: FirstScreen(),
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primaryColor: Colors.teal,
      ),
      getPages: [
        GetPage(
          name: '/mainPage',
          page: () => MainPage(),
          transition: Transition.fadeIn,
        ),
        GetPage(
          name: '/firstPage',
          page: () => FirstScreen(),
          transition: Transition.fadeIn,
        ),
      ]));
}

class LazyBindings extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<SerialController>(() => SerialController());
  }
}
