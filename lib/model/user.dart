class User {
  int id;
  String fingerPrint;
  String name;
  int amount;
  userMap() {
    var mapping = Map<String, dynamic>();
    mapping['fingerPrint'] = fingerPrint;
    mapping['name'] = name;
    mapping['amount'] = amount;
    return mapping;
  }

  userUpdateMap() {
    var mapping = Map<String, dynamic>();
    mapping['id'] = id;
    mapping['fingerPrint'] = fingerPrint;
    mapping['name'] = name;
    mapping['amount'] = amount;
    return mapping;
  }
}
