import 'dart:io';
import 'package:path/path.dart';
import 'dart:async';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';
import 'package:task/model/FolderDetails.dart';

class DatabaseHelper {
  static final DatabaseHelper _instance = new DatabaseHelper.internal();
  factory DatabaseHelper() => _instance;

  final String tableName = "demo";
  final String columnId = "id";
  final String folderName = "folderName";
  final String type = "type";
  final String folderId = "folderId";

  static Database _db;

  Future<Database> get db async {
    if (_db != null) {
      return _db;
    }
    _db = await initDb();
    return _db;
  }

  DatabaseHelper.internal();

  initDb() async {
    Directory documentDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentDirectory.path, "task_demo.db");
    var ourDb = await openDatabase(path, version: 1, onCreate: _onCreate);
    return ourDb;
  }

  void _onCreate(Database db, int version) async {
    await db.execute(
        "CREATE TABLE $tableName($columnId INTEGER PRIMARY KEY, $folderName TEXT, $type TEXT, $folderId INTEGER)");
    print("Table is created");
  }

//insertion
  Future<int> saveItem(FolderDetails folderDetails) async {
    var dbClient = await db;
    int res = await dbClient.insert("$tableName", folderDetails.toMap());
    print(res.toString());
    return res;
  }

  //Get
  Future<List> getItems(int id) async {
    var dbClient = await db;
    var result = await dbClient.rawQuery("SELECT * FROM $tableName WHERE $folderId = $id"); //ASC
    return result.toList();

  }

  Future<FolderDetails> getItem(int id) async {
    var dbClient = await db;
    var result = await dbClient.rawQuery("SELECT * FROM $tableName WHERE id = $id");
    if (result.length == 0) return null;
    return new FolderDetails.fromMap(result.first);
  }

  Future<int> getCount() async {
    var dbClient = await db;
    return Sqflite.firstIntValue(await dbClient.rawQuery(
        "SELECT COUNT(*) FROM $tableName"
    ));
  }

  Future close() async {
    var dbClient = await db;
    return dbClient.close();
  }
}