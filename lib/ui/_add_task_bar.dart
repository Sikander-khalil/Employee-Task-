import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_to_do/controller/task_controller.dart';
import 'package:flutter_to_do/models/task.dart';
import 'package:flutter_to_do/services/notification_services.dart';
import 'package:flutter_to_do/ui/theme.dart';
import 'package:flutter_to_do/ui/widgets/button.dart';
import 'package:flutter_to_do/ui/widgets/input_field.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
class AddTaskpage extends StatefulWidget {
  const AddTaskpage ({Key? key}) : super(key: key);

  @override
  State<AddTaskpage> createState() => _AddTaskpageState();
}

class _AddTaskpageState extends State<AddTaskpage> {
  var notifyHelper;
  final TaskController _taskController= Get.put(TaskController());
  final TextEditingController _titleController= TextEditingController();
  final TextEditingController _noteController= TextEditingController();
  DateTime _selectedDate=DateTime.now();
  String _endTime="9.30 PM" ;
  String _startTime=DateFormat("hh:mm a").format(DateTime.now()).toString();
  int _selectedRemind = 5;
  List<int> remindList=[
    5,
    10,
    15,
    20
  ];

  String _selectedRepeat = "None";
  List<String> repeatList=[
    "None",
    "Daily",
    "Weekly",
    "Monthly",
  ];
  int _selectedColor=0;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _appBar(),
      body: Container(
        margin: EdgeInsets.only(left: 23),
        padding: const EdgeInsets.only(top: 1),
        child: SingleChildScrollView(
          child: Column(

            children:  [
              Container(
                  margin: EdgeInsets.only(top: 5),
                  child: Text("Add Task",style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20)
              )
              ),

              MyInputfield(title:"Title", hint: "Enter your title", controller: _titleController,),
              MyInputfield(title:"Note", hint: "Enter your Note",controller: _noteController,),
              MyInputfield(title:"Date", hint: DateFormat.yMd().format(_selectedDate),
              widget: IconButton(
                  icon: Icon(Icons.calendar_today_outlined),
                  onPressed: (){
           print("Hi there");
           _getDateFromUser();
          },

              ),
              ),
              Row(
                children: [
                  Expanded(child: MyInputfield(
                    title: "Start Date",
                    hint: _startTime,
                    widget: IconButton(
                      onPressed: (){
                        _getTimeFromUser(isStartTime: true);
                      },
                        icon:  Icon(
                          Icons.access_time_rounded,
                          color: Colors.grey,
                        ),
                    ),
                  )),
                  SizedBox(width: 5),
                  Expanded(child: MyInputfield(
                    title: "End Date",
                    hint: _endTime,
                    widget: IconButton(
                      onPressed: (){
                _getTimeFromUser(isStartTime: false);
                      },
                      icon:  Icon(
                        Icons.access_time_rounded,
                        color: Colors.grey,
                      ),
                    ),
                  )),
                ],
              ),
              MyInputfield(title:"Remind", hint: "$_selectedRemind minutes early",
              widget: DropdownButton(
                icon: Icon(Icons.keyboard_arrow_down,
                color: Colors.grey,
                ),
                iconSize: 32,
                elevation: 4,
                underline: Container(height: 0,),
                onChanged: (String? newValue){
                  setState(() {
                    _selectedRemind=int.parse(newValue!);
                  });
                },
                items : remindList.map<DropdownMenuItem<String>>((int value){

                  return DropdownMenuItem<String>(
                    value: value.toString(),
                   child: Text(value.toString()),
                  );
                }
                ).toList(),
              ),

              ),
              MyInputfield(title:"Repeat", hint: "$_selectedRepeat",
                widget: DropdownButton(
                  icon: Icon(Icons.keyboard_arrow_down,
                    color: Colors.grey,
                  ),
                  iconSize: 32,
                  elevation: 19,
                  underline: Container(
                   // margin: EdgeInsets.only(top: 10),
                    height: 0,),
                  onChanged: (String? newValue){
                    setState(() {
                      _selectedRepeat=newValue!;
                    });
                  },
                  items : repeatList.map<DropdownMenuItem<String>>((String? value){

                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value!,style: TextStyle(color: Colors.grey),),
                    );
                  }
                  ).toList(),
                ),

              ),
              Row(
                children: [
                  _colorPalette(),
                  Container(
                      margin: EdgeInsets.only(left: 50),
                      padding: EdgeInsets.only(top: 5),
                      child: FlatButton(child: Text ("Create Task",style: TextStyle(color: Colors.white)), onPressed: () => _validateDate(),  color: Colors.black,  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                  )
                  )

                ],
              )
            ],
          ),
        ),
      ),

    );
  }
  _validateDate(){
    if(_titleController.text.isNotEmpty&& _noteController.text.isNotEmpty){
      _addTaskToDb();

      Get.back();
    } else if(_titleController.text.isEmpty || _noteController.text.isEmpty){
      Get.snackbar("Required", "All fields are required !",
      snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.white,
        colorText: pinkClr,
        icon: Icon(Icons.warning_amber_rounded)

      );
    }
  }
  _addTaskToDb() async {
  int value= await  _taskController.addTask(
        task: Task(
          note: _noteController.text,
          title:  _titleController.text,
          date: DateFormat.yMd().format(_selectedDate),
          startTime: _startTime,
          endTime: _endTime,
          remind: _selectedRemind,
          repeat: _selectedRepeat,
          color: _selectedColor,
          isCompleted: 0,

        )
    );
  print("My id is "+"$value");

  }
_colorPalette(){
    return Container(
      margin: EdgeInsets.only(top: 6),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Text("Color",style: TextStyle(fontSize: 12,fontWeight: FontWeight.bold),
          ),
          Wrap(
            children: List<Widget>.generate(
                3,
                    (int index){
                  return GestureDetector(
                    onTap: (){
                      setState(() {
                        _selectedColor=index;
                        print("$index");
                      });

                    },
                    child: Padding(
                      padding: const EdgeInsets.all(9.0),
                      child: CircleAvatar(
                          radius:  14,
                          backgroundColor: index==0?primaryClr:  index==1?pinkClr:yellowClr,
                          child: _selectedColor==index?Icon(Icons.done,
                            color: Colors.white,
                            size: 16,


                          ): Container(

                          )
                      ),

                    ),
                  );
                }


            ),
          )

        ],
      ),
    );
}
  _appBar() {


    return AppBar(
      elevation: 0,

      leading: GestureDetector(
        onTap: (){

          Get.back();

         /* ThemeService().switchTheme();

          var notifyHelper;
          notifyHelper.displayNotification(
              title: "Theme Changed",
              body: Get.isDarkMode?"Activated Light Theme":"Activated Dark Theme"
          );
          notifyHelper.scheduledNotification();*/
        },
        child: Icon(Icons.arrow_back_ios,
          size: 20,
          color: Get.isDarkMode ? Colors.white: Colors.black,
        ),

      ),
      actions: [
        CircleAvatar(
          backgroundImage: AssetImage(
              "images/profile.png"
          ),
        ),
        SizedBox(width: 20,)
      ],
    );
  }
  _getDateFromUser() async{
    DateTime? _pickerDate= await showDatePicker(context: context, initialDate:
     DateTime.now(),
        firstDate: DateTime(2015) ,
        lastDate: DateTime(2121)
    );
if(_pickerDate!=null){
  setState(() {
    _selectedDate = _pickerDate;
    print(_selectedDate);
  });
}
else{
  print("It's null is something is wrong");
}
  }
  _getTimeFromUser({required bool isStartTime}) async {

  var pickedTime= await _showTimePicker(context: context);
  String formateTime= pickedTime.format(context);
  if(pickedTime==null){
    print("Time cancelled");
  } else if(isStartTime==true){
    setState(() {
      _startTime =formateTime;
    });

  } else if(isStartTime==false) {
    setState(() {
      _endTime=formateTime;
    });

  }

  }
   _showTimePicker({required BuildContext context, initialTime}){
    return showTimePicker(
      initialEntryMode: TimePickerEntryMode.input,
      context: context,
      initialTime: TimeOfDay(
          hour: int.parse(_startTime.split(":")[0]),
          
          minute: int.parse(_startTime.split(":")[1].split("")[0]),
      ),
    );
  }
}
