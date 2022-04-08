import 'package:date_picker_timeline/date_picker_timeline.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:flutter_to_do/controller/task_controller.dart';
import 'package:flutter_to_do/models/task.dart';
import 'package:flutter_to_do/services/notification_services.dart';
import 'package:flutter_to_do/services/theme_services.dart';
import 'package:flutter_to_do/ui/_add_task_bar.dart';
import 'package:flutter_to_do/ui/theme.dart';
import 'package:flutter_to_do/ui/widgets/button.dart';
import 'package:get/get.dart';
import 'package:get/get_navigation/src/extension_navigation.dart';
import 'package:get/utils.dart';
import 'package:intl/intl.dart';
import 'package:flutter_clean_calendar/flutter_clean_calendar.dart';
import '../task_tile.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  List<bool> _selections = List.generate(3, (_) => false);
  DateTime _selectionDate = DateTime.now();
  DateTime now = DateTime.now();
  int _selectedIndex = 0;
  final _taskController = Get.put(TaskController());

  var notifyHelper;
  final Map<DateTime, List<CleanCalendarEvent>> events = {
    DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day): [],
  };

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
     notifyHelper=NotifyHelper();
    notifyHelper.initializeNotification();
    notifyHelper.requestIOSPermissions();
  }

  @override
  Widget build(BuildContext context) {

    String formattedDate = DateFormat('yyyy-MM-dd – kk:mm').format(now);
    return Scaffold(
      appBar: _appBar(),
      body: Container(
  child: Column(
    children: [
      _addTaskBar(),
      _addDateBar(),


          SizedBox(height: 10,),
          _showtabs(),

        //  _showtabs1(),
          //SizedBox(height: 10,),
          _showTasks(),


    ],

  ),



      ),

    );
  }

  _showTasks() {
    return Expanded(
      child: Obx(() {
        return ListView.builder(
            itemCount: _taskController.taskList.length,
            itemBuilder: (_, index) {
              //   print(_taskController.taskList.length);
              Task task = _taskController.taskList[index];
              print(task.toJson());
              if (task.repeat == 'Daily') {
                return AnimationConfiguration.staggeredList(
                    position: index,
                    child: SlideAnimation(
                      child: FadeInAnimation(
                        child: Row(
                          children: [
                            GestureDetector(
                              onTap: () {
                                _showBottomSheet(context, task);
                              },
                              child: TaskTile(task),
                            )
                          ],
                        ),
                      ),
                    ));
              }
              if (task.date == DateFormat.yMd().format(_selectionDate)) {
                return AnimationConfiguration.staggeredList(
                    position: index,
                    child: SlideAnimation(
                      child: FadeInAnimation(
                        child: Row(
                          children: [
                            GestureDetector(
                              onTap: () {
                                _showBottomSheet(context, task);
                              },
                              child: TaskTile(task),
                            )
                          ],
                        ),
                      ),
                    ));
              } else {
                return Container();
              }
            });
      }),
    );
  }

  _showBottomSheet(BuildContext context, Task task) {
    Get.bottomSheet(
      Container(
        padding: const EdgeInsets.only(top: 4),
        height: task.isCompleted == 1
            ? MediaQuery.of(context).size.height * 0.24
            : MediaQuery.of(context).size.height * 0.32,
        color: Get.isDarkMode ? darkGreyClr : Colors.white,
        child: Column(
          children: [
            Container(
              height: 6,
              width: 120,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: Get.isDarkMode ? Colors.grey[600] : Colors.grey[300]),
            ),
            Spacer(),
            task.isCompleted == 1
                ? Container()
                : _bottomSheetButton(
                    label: "Task Completed",
                    onTap: () {
                      _taskController.markTaskCompleted(task.id!);
                      Get.back();
                    },
                    clr: primaryClr,
                    context: context),
            SizedBox(height: 20),
            _bottomSheetButton(
                label: "Delete Task",
                onTap: () {
                  _taskController.delete(task);
                  //  _taskController.getTasks();
                  Get.back();
                },
                clr: Colors.red[300]!,
                context: context),
            SizedBox(
              height: 5,
            ),
            _bottomSheetButton(
                label: "Close",
                onTap: () {
                  Get.back();
                },
                clr: Colors.black,
                isClose: true,
                context: context),
            SizedBox(
              height: 5,
            )
          ],
        ),
      ),
    );
  }

  _bottomSheetButton({
    required String label,
    required Function()? onTap,
    required Color clr,
    bool isClose = false,
    required BuildContext context,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: EdgeInsets.symmetric(vertical: 4),
        height: 55,
        width: MediaQuery.of(context).size.width * 0.9,
        decoration: BoxDecoration(
          border: Border.all(
              width: 2,
              color: isClose == true
                  ? Get.isDarkMode
                      ? Colors.grey[600]!
                      : Colors.grey[300]!
                  : clr),
          borderRadius: BorderRadius.circular(20),
          color: isClose == true ? Colors.black : clr,
        ),
        child: Center(
          child: Text(
            label,
            style: TextStyle(color: Colors.white),
          ),
        ),
      ),
    );
  }

  _addDateBar() {
    return Container(
      margin: EdgeInsets.only(bottom: 10, left: 240),
      child: IconButton(
        icon: Icon(
          Icons.calendar_today_outlined,
          size: 50,
          color: Colors.red,
        ),
        onPressed: () {
          print("Hi there");
          _getDateFromUser();
        },
      ),
    );
  }

  _addTaskBar() {
    return Container(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Container(
            padding: EdgeInsets.only(top: 20),
            margin: EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  DateFormat.yMMMMd().format(DateTime.now()),
                  //    style: subHeadingStyle,
                ),
                Text(
                  "Today",
                  style: TextStyle(fontSize: 27, fontWeight: FontWeight.bold),
                ),
              ],
            ),
          ),
          RaisedButton(
              child: Text("+Add Task"),
              onPressed: () async {
                await Get.to(() => AddTaskpage());
                _taskController.getTasks();
              })
        ],
      ),
    );
  }

  _appBar() {
    return AppBar(
      elevation: 0,
      leading: GestureDetector(
        onTap: () {
          ThemeService().switchTheme();

              var notifyHelper;
          notifyHelper.displayNotification(
              title: "Theme Changed",
              body: Get.isDarkMode?"Activated Light Theme":"Activated Dark Theme"
          );
          notifyHelper.scheduledNotification();
        },
        child: Icon(
          Get.isDarkMode ? Icons.wb_sunny_outlined : Icons.nightlight_round,
          size: 20,
          color: Get.isDarkMode ? Colors.white : Colors.black,
        ),
      ),
      actions: [
        CircleAvatar(
          backgroundImage: AssetImage("images/profile.png"),
        ),
        SizedBox(
          width: 20,
        )
      ],
    );
  }

  _showtabs() {
    return Expanded(
      flex: 0,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment
            .start,
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          ToggleButtons(

            children: <Widget>[
              Card(
                margin: const EdgeInsets.symmetric(
                    horizontal: 10.0, vertical: 5),
                child: Container(
                  margin: EdgeInsets.only(right: 30),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(50.0),
                        boxShadow: [
                          BoxShadow(
                              color: Colors.black26,
                              blurRadius: 4.0,

                          )
                        ]
                    ),

                    width: 80,
                    height: 50,
                    child: Center(child: Text("Daily",style: TextStyle(fontSize: 20,fontWeight: FontWeight.bold ),))),
              ),
              Card(
                  child: Container(
                  margin: EdgeInsets.only(right: 25),
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(50.0),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black26,
                              blurRadius: 4.0,

                            )
                          ]
                      ),
                      width: 90,
                      height: 50,
                      child: Center(child: Text("Weekly",style: TextStyle(fontSize: 20,fontWeight: FontWeight.bold),)))),
              Card(
                elevation: 90,
                shadowColor: Colors.black,
                child: Container(

                    margin: EdgeInsets.only(right: 2),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(50.0),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black26,
                            blurRadius: 4.0,

                          )
                        ]
                    ),
                    width: 90,
                    height: 50,

                    child: Center(child: Text("Monthly",style: TextStyle(fontSize: 20,fontWeight: FontWeight.bold),))),
              )
            ],

            onPressed: (int index) {
              setState(() =>
              _selectedIndex = index);
              if (_selectedIndex == 0) {
                _taskController.taskList.clear();
                _taskController.getDailyTasks();
              }
              if (_selectedIndex == 1) {
                _taskController.taskList.clear();
                _taskController.getWeeklyTasks();
              }
              if (_selectedIndex == 2) {
                _taskController.taskList.clear();
                _taskController.getMonthlyTasks();
              }

            }, isSelected: _selections,
          ),
        ],
        //margin: EdgeInsets.only(right: 250),

      ),
    );
  }

  _getDateFromUser() async {
    DateTime? _pickerDate = await showDatePicker(
        context: context,
        initialDate: DateTime.now(),
        firstDate: DateTime(2015),
        lastDate: DateTime(2121));
    if (_pickerDate != null) {
      setState(() {
        _selectionDate = _pickerDate;
        print(_selectionDate);
      });
    } else {
      print("It's null is something is wrong");
    }
  }

/*  _showtabs1() {
    return Container(
      margin: EdgeInsets.only(left: 30),
      child: Transform(
        transform: new Matrix4.identity()..scale(0.8),
        child: ActionChip(
          elevation: 8.0,
          //Weekly  u can  do sa same the daily ok ?
          label: Container(
              alignment: Alignment.center,
              color: Colors.green,
              width: 80,
              height: 40,
              child: Text(
                'Weekly',
                style: TextStyle(fontSize: 25),
              )),
          onPressed: () {
            setState(() {
              _taskController.taskList.clear();
              _taskController.getWeeklyTasks();
            });
          },
          backgroundColor: Colors.grey[200],
          shape: StadiumBorder(
              side: BorderSide(
            width: 5,
            color: Colors.redAccent,
          )),
        ),
      ),
    );
  }*/
}
