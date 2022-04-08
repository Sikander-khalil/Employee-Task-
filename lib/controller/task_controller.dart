import 'package:flutter_to_do/db/db_helper.dart';
import 'package:flutter_to_do/models/task.dart';
import 'package:get/get.dart';
class TaskController extends GetxController{
  @override
  void onReady(){
    getTasks();
    super.onReady();
  }
var taskList= <Task>[].obs;

  Future<int> addTask({Task? task}) async{
    return await DBHelper.insert(task);
  }
  void getTasks() async{
    List<Map<String, dynamic>> tasks=await DBHelper.query();
    taskList.assignAll(tasks.map((data) => new Task.fromJson(data)).toList());
  }



  void getDailyTasks() async{
    List<Map<String, dynamic>> tasks=await DBHelper.queryDailyTasks();
    taskList.assignAll(tasks.map((data) => new Task.fromJson(data)).toList());
  }
  void getWeeklyTasks() async{
    List<Map<String, dynamic>> tasks=await DBHelper.queryWeeklyTasks();
    taskList.assignAll(tasks.map((data) => new Task.fromJson(data)).toList());
  }
  void getMonthlyTasks() async{
    List<Map<String, dynamic>> tasks=await DBHelper.queryMonthlyTasks();
    taskList.assignAll(tasks.map((data) => new Task.fromJson(data)).toList());
  }
  void delete(Task task){
    DBHelper.delete(task);
    getTasks();
  }
  void markTaskCompleted(int id) async{
    await DBHelper.update(id);
    getTasks();

  }
}