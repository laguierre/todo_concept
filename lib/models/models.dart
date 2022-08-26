import 'package:flutter/material.dart';

class TODOTypes {
  Color leftBottomColor;
  Color rightTopColor;
  IconData iconTask;
  String taskType;
  int taskQyt;
  double percentCompleted;
  List<ItemTask> itemTask;

  TODOTypes(
    this.leftBottomColor,
    this.rightTopColor,
    this.iconTask,
    this.taskQyt,
    this.taskType,
    this.percentCompleted,
    this.itemTask,
  );
}

class ItemTask {
  String date;
  String nameTask;
  bool critical;

  ItemTask(
    this.nameTask,
    this.critical,
    this.date,
  );
}
