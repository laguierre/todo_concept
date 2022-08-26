import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

import '../../constants.dart';
import '../../models/models.dart';
import '../../models/provider_models.dart';

class TasksPage extends StatefulWidget {
  const TasksPage({
    Key? key,
    required this.items,
    required this.itemToday,
    required this.itemTomorrow,
    required this.i,
  }) : super(key: key);
  final List<TODOTypes> items;
  final List<ItemTask> itemToday;
  final List<ItemTask> itemTomorrow;
  final int i;

  @override
  State<TasksPage> createState() => _TasksPageState();
}

class _TasksPageState extends State<TasksPage> {
  final myController = TextEditingController();
  late FocusNode focusNode;
  bool todayCheck = true, tomorrowCheck = false;

  @override
  void initState() {
    super.initState();
    Provider.of<TriggerAnimations>(context, listen: false).isTransition = false;

    Future.delayed(const Duration(milliseconds: 50), (){
Provider.of<TriggerAnimations>(context, listen: false).isTransition = true;

});
  }

  @override
  void dispose() {
    myController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    bool trigger = Provider.of<TriggerAnimations>(context).isTransition;
    return Scaffold(
      appBar: topMenuTask(),
      body: Stack(
        children: [
          AnimatedPositioned(
            curve: Curves.easeOutCirc,
              duration: const Duration(milliseconds: kDurationTaskAddTask),
              bottom: trigger ? 0 : 30 + 10,
              right: trigger ? 0 : 30 + 20,
              child: GestureDetector(
                onTap: () {
                  trigger = Provider.of<TriggerAnimations>(context, listen: false)
                      .isTransition = false;
                  if (myController.text.isNotEmpty) {
                    if (todayCheck) {
                      widget.items[widget.i].itemTask
                          .add(ItemTask(myController.text, false, 'today'));
                    }
                    if (tomorrowCheck) {
                      widget.items[widget.i].itemTask
                          .add(ItemTask(myController.text, false, 'tomorrow'));
                    }
                  }
                  backPage();
                },
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: kDurationTaskAddTask),
                  height: 58,
                  width: trigger ? MediaQuery.of(context).size.width : 58,
                  decoration: BoxDecoration(
                    borderRadius: !trigger? BorderRadius.circular(58/2) : BorderRadius.circular(0),
                    gradient: LinearGradient(
                        begin: Alignment.bottomLeft,
                        end: Alignment.topRight,
                        colors: [
                          widget.items[widget.i].leftBottomColor,
                          widget.items[widget.i].rightTopColor,
                        ]),
                    color: Colors.blueAccent,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.5),
                        spreadRadius: 5,
                        blurRadius: 5,
                        offset:
                            const Offset(0, 3), // changes position of shadow
                      ),
                    ],
                  ),
                  child: const Center(
                    child: Icon(Icons.add, color: Colors.white, size: 40),
                  ),
                ),
              )),
          newTaskEntry(),
        ],
      ),
    );
  }

  Widget newTaskEntry(){
    return Align(
      alignment: const Alignment(-1, 0.9),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(30, 20, 30, 0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "What tasks are you planning to perform?",
              style: TextStyle(color: Colors.black54, fontSize: 18),
            ),
            const SizedBox(
              height: 20,
            ),
            TextField(
              style: const TextStyle(fontSize: 24, color: Colors.black),
              controller: myController,
              autofocus: true,
              focusNode: FocusNode(),
              decoration: const InputDecoration(
                hintStyle: TextStyle(fontSize: 24, color: Colors.black12),
                hintText: 'New Task',
                border: InputBorder.none,
              ),
            ),
            CheckboxListTile(
                contentPadding: EdgeInsets.zero,
                title: const Text(
                  "Today",
                  style: TextStyle(color: Colors.black54, fontSize: 20),
                ),
                controlAffinity: ListTileControlAffinity.leading,
                value: todayCheck,
                activeColor: widget.items[widget.i].leftBottomColor,
                onChanged: (value) {
                  setState(() {
                    todayCheck = value!;
                  });
                }),
            CheckboxListTile(
                contentPadding: EdgeInsets.zero,
                title: const Text(
                  "Tomorrow",
                  style: TextStyle(color: Colors.black54, fontSize: 20),
                ),
                controlAffinity: ListTileControlAffinity.leading,
                value: tomorrowCheck,
                activeColor: widget.items[widget.i].leftBottomColor,
                onChanged: (value) {
                  setState(() {
                    tomorrowCheck = value!;
                  });
                })
          ],
        ),
      ),
    );
  }
  PreferredSizeWidget topMenuTask() {
    return AppBar(
      centerTitle: true,
      backgroundColor: Colors.transparent,
      elevation: 0,
      title: const Text(
        "New Task",
        style: TextStyle(color: Colors.black, fontSize: 24),
      ),
      leading: IconButton(
        icon: const Icon(
          Icons.close,
          color: Colors.black,
        ),
        onPressed: () {
          backPage();
        },
      ),
    );
  }

  void backPage() {
    Provider.of<TriggerAnimations>(context, listen: false).isTransition = false;
    setState(() {
      SystemChannels.textInput.invokeMethod('TextInput.hide');
    });
    // Provider.of<TriggerAnimations>(context, listen: false).isTransition = true;
    Future.delayed(const Duration(milliseconds: kDurationTaskAddTask), () {
      Navigator.pop(context);
    });
  }
}
