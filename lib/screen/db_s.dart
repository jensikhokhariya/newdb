import 'dart:io';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';
import 'package:sqflite/sqlite_api.dart';

class DBHelper {
  Database? database;

  Future<Database> checkDB() async {
    if (database != null) {
      return database!;
    } else {
      return await initDB();
    }
  }

  Future<Database> initDB() async {
    Directory dir = await getApplicationDocumentsDirectory();
    String path = join(dir.path, "rnw.db");

    return openDatabase(path, version: 1, onCreate: (db, version) {
      String query =
          "CREATE TABLE student (id INTEGER PRIMARY KEY AUTOINCREMENT ,name TEXT ,no TEXT ,std TEXT ,parentname TEXT)";
      db.execute(query);
    });
  }

  Future<int> insert(
      String name, String no, String std, String parentname) async {
    database = await checkDB();
    return await database!.insert("student",
        {"name": name, "no": no, "std": std, "parentname": parentname});
  }

  Future<List<Map<String, dynamic>>> readData() async {
    database = await checkDB();
    String query = "SELECT * FROM student";
    var res = database!.rawQuery(query);
    return res;
  }

  void delete(int id) async {
    database = await checkDB();
    database!.delete("student", where: "id=?", whereArgs: [id]);
  }

  void update(
      int id, String name, String no, String std, String parentname) async {
    database = await checkDB();
    database!.update("student",
        {"name": name, "no": no, "std": std, "parentname": parentname},
        where: "id=?", whereArgs: [id]);
  }
}
