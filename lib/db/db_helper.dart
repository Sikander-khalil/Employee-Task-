import 'package:flutter_to_do/models/task.dart';
import 'package:sqflite/sqflite.dart';

class DBHelper{
  static Database? _db;
  static final int _version = 1;
  static final String _tableName="tasks";
  static Future<void> initDb() async{
    if(_db !=null){
      return;

    }
    try {
String _path=await getDatabasesPath() + 'tasks.db';
_db =await openDatabase(

    _path,
    version:  _version,
  ///how is the table of daily task or  how is the identify the task is daily or weekly
  onCreate: (db,version){
      print("Creating a new one");
      return db.execute(
        "CREATE TABLE $_tableName(""id INTEGER PRIMARY KEY AUTOINCREMENT, "
            "title STRING, note TEXT, date STRING,"
            "startTime STRING, endTime STRING,"
            "remind INTEGER, repeat STRING,"
            "color INTEGER,"
            "isCompleted INTEGER)",
      );
  },



);
    } catch(e) {
      print(e);
    }
  }
  static Future<int> insert(Task? task) async{
    print("insert function called");

    return await _db?.insert(_tableName, task!.toJson())??1;
  }
  static Future<List<Map<String,dynamic>>> query() async{
    print("query function called");
    return await _db!.query(_tableName);
  }

  // Future<List<Map<String,dynamic>>> query() async{
  //   print("query function called");
  //   return await _db!.query(_tableName);
  // }


 static Future<List<Map<String, dynamic>>>  queryDailyTasks() async {

    // get a reference to the database
    // Database db = await _db;

    // raw query
    List<Map<String,dynamic>> result = await _db!.rawQuery('SELECT * FROM tasks WHERE repeat=?', ['Daily']);

    // print the results
    result.forEach((row) => print(row));
    // {_id: 2, name: Mary, age: 32}
    return result;
  }
  static Future<List<Map<String, dynamic>>>  queryWeeklyTasks() async {

    // get a reference to the database
    // Database db = await _db;

    // raw query
    List<Map<String,dynamic>> result = await _db!.rawQuery('SELECT * FROM tasks WHERE repeat=?', ['Weekly']);

    // print the results
    result.forEach((row) => print(row));
    // {_id: 2, name: Mary, age: 32}
    return result;
  }

  static Future<List<Map<String, dynamic>>>  queryMonthlyTasks() async {

    // get a reference to the database
    // Database db = await _db;

    // raw query
    List<Map<String,dynamic>> result = await _db!.rawQuery('SELECT * FROM tasks WHERE repeat=?', ['Monthly']);

    // print the results
    result.forEach((row) => print(row));
    // {_id: 2, name: Mary, age: 32}
    return result;
  }



  static delete(Task task) async{
return await _db!.delete(_tableName,where: 'id=?', whereArgs: [task.id]);
  }

  static update(int id) async{

    return await _db!.rawUpdate('''
    UPDATE tasks
    SET isCompleted = ?
    WHERE id= ?
    ''', [1,id]);

  }

}