import 'package:flutter/material.dart';
import 'package:todo_concept/models/models.dart';

final allTODOTask = [
  TODOTypes(const Color(0xFFF75674), const Color(0xFFF6AB58), Icons.person, itemsTaskPersonal.length,
      'Personal', 27, itemsTaskPersonal),
  TODOTypes(const Color(0xFF5366DD), const Color(0xFF60ABE3),
      Icons.wallet_travel_rounded, itemsTaskWord.length, 'Work', 39, itemsTaskWord),
  TODOTypes(const Color(0xFF39A80F), const Color(0xFF12E30C), Icons.person, itemsTaskShoppingList.length,
      'Shopping List', 12, itemsTaskShoppingList),
];

List<ItemTask>  itemsTaskWord = [
  ItemTask('Meet Clients', false, 'today'),
  ItemTask('Design String', false, 'today'),
  ItemTask('HTML/CSS Study', true, 'today'),
  ItemTask('Icon Set Design for Mobile App', false, 'today'),
  ItemTask('Design Meeting', true, 'today'),
  ItemTask('Quick Prototyping', false, 'today'),
  ItemTask('Ux Conference', true, 'tomorrow'),
  ItemTask('Weekly Report', false, 'tomorrow'),
  ItemTask('Talk with the Team Leader', true, 'tomorrow'),
  ItemTask('Flutter Study', false, 'tomorrow'),
];

List<ItemTask> itemsTaskPersonal = [
  ItemTask('Mom birthday', false, 'today'),
  ItemTask('Buy a gift', true, 'today'),
  ItemTask('Meeting with Friends!!!', false, 'today'),
  ItemTask('Mom Party at Home!!!', false, 'tomorrow'),
];

List<ItemTask> itemsTaskShoppingList = [
  ItemTask('Eggs', false, 'today'),
  ItemTask('Coke', true, 'today'),
  ItemTask('Meet', false, 'today'),
  ItemTask('Wine', false, 'today'),
  ItemTask('Flowers', false, 'tomorrow'),
];