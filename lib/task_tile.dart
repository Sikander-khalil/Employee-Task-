import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_to_do/models/task.dart';
import 'package:flutter_to_do/ui/theme.dart';

class TaskTile extends StatelessWidget {
  final Task? task;
  TaskTile(this.task);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 30),
      width: MediaQuery.of(context).size.width,
      margin: EdgeInsets.only(bottom: 12),
      child: Container(
        padding: EdgeInsets.all(16),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          color: _getBGClr(task?.color??0),
        ),
        child: Row(
          children: [
            Expanded(child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(task?.title??"", style: TextStyle(fontSize: 16,
                fontWeight: FontWeight.bold,
                  color: Colors.white),
                ),
                SizedBox(height: 12,),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Icon(Icons.access_time_rounded,
                    color: Colors.grey[200],
                      size: 18,
                    ),
                    SizedBox(width: 4,),
                    Text("${task!.startTime} - ${task!.endTime}",
                    style: TextStyle(
                      fontSize: 13, color: Colors.grey[100],
                    ),
                    )
                  ],
                ),
                SizedBox(height: 12,),
                Text(
                  task?.note??"",
                  style: TextStyle(
                    fontSize: 15, color: Colors.grey[100],
                  ),
                  
                ),
                SizedBox(height: 12,),
                Text(task?.repeat??"",style: TextStyle(fontSize: 20,color: Colors.white,fontWeight: FontWeight.bold),)
              ],
            ),
            ),
            Container(
              margin: EdgeInsets.symmetric(horizontal: 10),
              height: 90,
                width: 7,
              color: Colors.black
            ),
            RotatedBox(quarterTurns: 3,
            child: Text(
              task!.isCompleted==1 ? "Completed" : "Schedule",
              style: TextStyle(
                fontSize: 10,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),

            ),
            )
          ],
        ),
      ),
    );
  }
  _getBGClr(int no){
    switch(no) {
      case 0:
        return bluishClr;
      case 1:
        return pinkClr;
      case 2:
        return yellowClr;
      default:
        return bluishClr;
    }
  }
}
