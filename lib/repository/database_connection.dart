import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';

class DatabaseConnection {
  setDatabase() async {
    var directory = await getApplicationDocumentsDirectory();
    var path = join(directory.path, 'db_user');
    var database =
        await openDatabase(path, version: 1, onCreate: _onCreatingDatabase);
    return database;
  }

  _onCreatingDatabase(Database database, int version) async {
    await database.execute(
        "CREATE TABLE users(id INTEGER PRIMARY KEY AUTOINCREMENT,fingerPrint TEXT,name TEXT,amount INTEGER)");
    await database.execute(
        "INSERT INTO users ('id', 'fingerPrint', 'name', 'amount' ) values (?, ?, ?, ?)",
        [
          1,
          "A",
          "Mesay",
          5000,
        ]);
    await database.execute(
        "INSERT INTO users ('id', 'fingerPrint', 'name', 'amount' ) values (?, ?, ?, ?)",
        [
          2,
          "B",
          "Melese",
          5000,
        ]);
    await database.execute(
        "INSERT INTO users ('id', 'fingerPrint', 'name', 'amount' ) values (?, ?, ?, ?)",
        [
          3,
          "C",
          "Eliyas",
          5000,
        ]);
    await database.execute(
        "INSERT INTO users ('id', 'fingerPrint', 'name', 'amount' ) values (?, ?, ?, ?)",
        [
          4,
          "D",
          "Adugna",
          5000,
        ]);
  }
}
