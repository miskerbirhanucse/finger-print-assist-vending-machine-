import 'package:get/get.dart';
import '../repository/repository.dart';

import '../model/user.dart';

class UserController extends GetxController {
  //List<User> Users = List<User>().obs;
  List<User> users = [];
  Repository _repository;
  UserController() {
    _repository = Repository();
  }

  readUser() async {
    return await _repository.readData('users');
  }

  readUserById(fingerPrint) async {
    return await _repository.readDataByFingerPrint('users', fingerPrint);
  }

  updateUser(User user) async {
    return await _repository.updateUser('users', user.userUpdateMap());
  }
}
