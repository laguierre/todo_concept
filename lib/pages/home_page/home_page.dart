import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:page_transition/page_transition.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';
import 'package:provider/provider.dart';
import 'package:todo_concept/data/dataTask.dart';
import 'package:todo_concept/models/provider_models.dart';
import 'dart:math' as math;
import '../../constants.dart';
import '../../models/models.dart';
import '../tasks_page/tasks_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int currentPage = 0;
  double pageValue = 0;
  late PageController pageController;
  bool isPageChanged = false;
  bool isTrigger = false;
  List<TODOTypes> items = List.of(allTODOTask);

  @override
  void initState() {
    pageController = PageController(initialPage: currentPage)
      ..addListener(() {
        setState(() {
          for (pageValue = pageController.page!; pageValue > 1;) {
            (pageValue--);
          }
          currentPage = pageController.page!.truncate();
          debugPrint('Page: $currentPage - Value: $pageValue');
        });
      });
    super.initState();
  }

  @override
  void dispose() {
    pageController.dispose();
    pageController.removeListener(() {});
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    bool isTrigger = Provider.of<TriggerAnimations>(context).trigger;
    bool isAnimationFinish =
        Provider.of<TriggerAnimations>(context).isAnimationFinish;
    return Scaffold(
      body: AnimatedContainer(
        width: double.infinity,
        height: double.infinity,
        duration: const Duration(milliseconds: 200),
        decoration: BoxDecoration(
            gradient: LinearGradient(
                begin: Alignment.bottomLeft,
                end: Alignment.topRight,
                colors: [
              pageValue > 0.6
                  ? items[currentPage].leftBottomColor
                  : items[currentPage].leftBottomColor,
              pageValue > 0.6
                  ? items[currentPage].rightTopColor
                  : items[currentPage].rightTopColor,
            ])),
        child: Stack(
          alignment: Alignment.topLeft,
          children: [
            const Positioned(
                left: 0, right: 0, top: 100, child: PersonalData()),
            AnimatedPositioned(
                onEnd: () {
                  if (isTrigger) {
                    isAnimationFinish =
                        Provider.of<TriggerAnimations>(context, listen: false)
                            .isAnimationFinish = true;
                  }
                },
                duration: const Duration(milliseconds: kDurationUp),
                left: 0,
                right: 0,
                bottom: 0,
                top: !isTrigger ? size.height * 0.47 : 0,
                child: PageView.builder(
                    controller: pageController,
                    physics: isAnimationFinish
                        ? const NeverScrollableScrollPhysics()
                        : const BouncingScrollPhysics(),
                    itemCount: items.length,
                    itemBuilder: (context, index) {
                      return GestureDetector(
                          behavior: HitTestBehavior.translucent,
                          onVerticalDragUpdate: (details) {
                            int sensitivity = 8;
                            if (details.delta.dy < -sensitivity) {
                              isTrigger = Provider.of<TriggerAnimations>(
                                      context,
                                      listen: false)
                                  .trigger = true;
                            }
                          },
                          child: TaskCard(
                            i: index,
                            items: items,
                          ));
                    })),
            Positioned(
                top: 20,
                left: 0,
                right: 0,
                child: isAnimationFinish
                    ? const TopMenu(
                        text: 'TODO',
                        iconLeft: Icons.arrow_back,
                        iconRight: Icons.more_vert,
                        color: Colors.grey)
                    : const TopMenu(
                        text: 'TODO',
                        iconLeft: Icons.menu,
                        iconRight: Icons.search,
                        color: Colors.white)),
          ],
        ),
      ),
    );
  }
}

class TaskCard extends StatefulWidget {
  const TaskCard({
    Key? key,
    required this.i,
    required this.items,
  }) : super(key: key);
  final int i;
  final List<TODOTypes> items;

  @override
  State<TaskCard> createState() => _TaskCardState();
}

class _TaskCardState extends State<TaskCard> {
  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    bool isTrigger = Provider.of<TriggerAnimations>(context).trigger;
    bool isAnimationFinish =
        Provider.of<TriggerAnimations>(context).isAnimationFinish;

    List<ItemTask> itemToday = [];
    List<ItemTask> itemTomorrow = [];
    splitTask(widget.items, itemToday, itemTomorrow, widget.i);

    return AnimatedContainer(
      duration: const Duration(milliseconds: kDurationUp),
      margin: !isTrigger
          ? const EdgeInsets.fromLTRB(50, 20, 50, 50)
          : const EdgeInsets.all(0),
      decoration: BoxDecoration(
        borderRadius:
            !isTrigger ? BorderRadius.circular(15) : BorderRadius.circular(0),
        color: Colors.white,
        boxShadow: const [
          BoxShadow(
              offset: Offset(5, 10),
              blurRadius: 10,
              color: Colors.black38,
              spreadRadius: 5)
        ],
      ),
      child: Padding(
        padding: EdgeInsets.fromLTRB(30, 20, 30, isAnimationFinish ? 0 : 20),
        child: Stack(
          children: [
            if (isTrigger)
              AnimatedPositioned(
                  right: 0,
                  left: 0,
                  top: isAnimationFinish ? size.height * 0.33 : size.height,
                  bottom: 0,
                  duration: const Duration(milliseconds: kDurationUp),
                  child: AnimatedOpacity(
                    duration: const Duration(milliseconds: kDurationUp),
                    opacity: isAnimationFinish ? 1 : 0,
                    child: SingleChildScrollView(
                      physics: const BouncingScrollPhysics(),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text('Today',
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 20,
                                  color: Colors.black54)),
                          _createListTask(itemToday),
                          const SizedBox(height: 20),
                          const Text('Tomorrow',
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 20,
                                  color: Colors.black54)),
                          _createListTask(itemTomorrow),
                        ],
                      ),
                    ),
                  )),
            if (isTrigger)
              AddButtonTask(
                  widget: widget,
                  itemToday: itemToday,
                  itemTomorrow: itemTomorrow,
                  isAnimationFinish: isAnimationFinish),
            AnimatedAlign(
              duration: const Duration(milliseconds: kDurationUp),
              alignment: !isTrigger
                  ? const Alignment(0, -1)
                  : const Alignment(0, kOffsetAnimatedContainer),
              child: Row(
                children: [
                  Container(
                    height: 50,
                    width: 50,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      border:
                          Border.all(width: 1.5, color: Colors.grey),
                      shape: BoxShape.circle,
                    ),
                    child: Center(
                      child: Icon(widget.items[widget.i].iconTask,
                          color: widget.items[widget.i].leftBottomColor,
                          size: 28),
                    ),
                  ),
                  AnimatedOpacity(
                    duration: const Duration(milliseconds: kDurationUp),
                    opacity: !isTrigger ? 1 : 0,
                    child: IconButton(
                        onPressed: () {},
                        icon: const Icon(
                          Icons.more_vert,
                          color: Colors.grey,
                          size: 28,
                        )),
                  )
                ],
              ),
            ),
            AnimatedAlign(
              duration: const Duration(milliseconds: kDurationUp),
              alignment: !isTrigger
                  ? const Alignment(-1, 0.8)
                  : const Alignment(-1, kOffsetAnimatedContainer + 0.2),
              child: LabelTask(widget: widget),
            ),
            AnimatedAlign(
              duration: const Duration(milliseconds: kDurationUp),
              alignment: !isTrigger
                  ? const Alignment(0, 1)
                  : const Alignment(0, kOffsetAnimatedContainer + 0.35),
              child: ProgressPercent(widget: widget),
            )
          ],
        ),
      ),
    );
  }

  ListView _createListTask(List<ItemTask> items) {
    return ListView.builder(
      shrinkWrap: true,
      physics: const BouncingScrollPhysics(),
      itemCount: items.length,
      itemBuilder: (context, index) {
        final item = items[index];
        return Slidable(
          startActionPane: ActionPane(
            motion: const StretchMotion(),
            children: [
              SlidableAction(
                  icon: Icons.check_box_outlined,
                  onPressed: (context) {
                    setState(() {
                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                          backgroundColor: Colors.green,
                          behavior: SnackBarBehavior.floating,
                          shape: RoundedRectangleBorder(
                            side:
                                const BorderSide(color: Colors.green, width: 1),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          content: RichText(
                            text: TextSpan(
                              text: '"${item.nameTask}"',
                              style: const TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 16),
                              children: const <TextSpan>[
                                TextSpan(
                                    text: ' dismissed',
                                    style: TextStyle(
                                        fontWeight: FontWeight.normal,
                                        fontSize: 16)),
                              ],
                            ),
                          )));
                      _generateRandom(index);
                    });
                  }),
            ],
          ),
          endActionPane: ActionPane(
            motion: const StretchMotion(),
            children: [
              SlidableAction(
                  foregroundColor: Colors.red,
                  icon: Icons.delete_forever,
                  onPressed: (context) {
                    setState(() {
                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                          backgroundColor: Colors.redAccent,
                          behavior: SnackBarBehavior.floating,
                          shape: RoundedRectangleBorder(
                            side: const BorderSide(
                                color: Colors.redAccent, width: 1),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          content: RichText(
                            text: TextSpan(
                              text: '"${item.nameTask}"',
                              style: const TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 16),
                              children: const <TextSpan>[
                                TextSpan(
                                    text: ' dismissed',
                                    style: TextStyle(
                                        fontWeight: FontWeight.normal,
                                        fontSize: 16)),
                              ],
                            ),
                          )));
                      _generateRandom(index);
                    });
                  }),
            ],
          ),
          child: Column(
            children: [
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Text(
                    item.nameTask,
                    style: const TextStyle(color: Colors.black54, fontSize: 20),
                  ),
                  const Spacer(),
                  item.critical
                      ? const Icon(Icons.timer_sharp, color: Colors.black54)
                      : Container()
                ],
              ),
              const SizedBox(height: 5),
              Container(
                height: 1,
                color: Colors.black12,
              ),
            ],
          ),
        );
      },
    );
  }

  void _generateRandom(int index) {
    widget.items[widget.i].taskQyt--;
    widget.items[widget.i].itemTask.removeAt(index);
    widget.items[widget.i].percentCompleted += (math.Random().nextInt(20) + 2);
    if (widget.items[widget.i].taskQyt == 0) {
      widget.items[widget.i].percentCompleted = 100;
    }
  }
}

class LabelTask extends StatelessWidget {
  const LabelTask({
    Key? key,
    required this.widget,
  }) : super(key: key);

  final TaskCard widget;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        RichText(
            text: TextSpan(
          text: '${widget.items[widget.i].taskQyt}',
          style: const TextStyle(
              color: Colors.black38, fontSize: 22, fontWeight: FontWeight.bold),
          children: const <TextSpan>[
            TextSpan(
              text: ' Task',
              style: TextStyle(
                  color: Colors.black38,
                  fontSize: 22,
                  fontWeight: FontWeight.normal),
            )
          ],
        )),
        Text(widget.items[widget.i].taskType,
            style: const TextStyle(
                color: Colors.black38,
                fontSize: 32,
                fontWeight: FontWeight.w700)),
      ],
    );
  }
}

class ProgressPercent extends StatelessWidget {
  const ProgressPercent({
    Key? key,
    required this.widget,
  }) : super(key: key);

  final TaskCard widget;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
            child: LinearPercentIndicator(
          padding: const EdgeInsets.all(0),
          animationDuration: 500,
          animation: true,
          progressColor: widget.items[widget.i].leftBottomColor,
          backgroundColor: Colors.grey.shade300,
          percent: (widget.items[widget.i].percentCompleted / 100).clamp(0, 1),
        )),
        const SizedBox(width: 20),
        Text(
          '${widget.items[widget.i].percentCompleted.round()}%',
          style: const TextStyle(
              color: Colors.grey, fontWeight: FontWeight.bold, fontSize: 18),
        ),
      ],
    );
  }
}

class AddButtonTask extends StatelessWidget {
  const AddButtonTask({
    Key? key,
    required this.widget,
    required this.itemToday,
    required this.itemTomorrow,
    required this.isAnimationFinish,
  }) : super(key: key);

  final TaskCard widget;
  final List<ItemTask> itemToday;
  final List<ItemTask> itemTomorrow;
  final bool isAnimationFinish;

  @override
  Widget build(BuildContext context) {
    return Positioned(
      bottom: 30+10,
        right: 20,
        child: GestureDetector(
          onTap: () {
            Provider.of<TriggerAnimations>(context, listen: false).isTransition = true;
            Future.delayed(const Duration(milliseconds: 5000));
            Navigator.push(
              context,
              PageTransition(
                  type: PageTransitionType.fade,
                  child: TasksPage(
                    items: widget.items,
                    itemToday: itemToday,
                    itemTomorrow: itemTomorrow,
                    i: widget.i,
                  ),
                  inheritTheme: true,
                  ctx: context),
            );
          },
          child: AnimatedOpacity(
            duration: const Duration(milliseconds: kDurationUp),
            opacity: isAnimationFinish ? 1 : 0,
            child: Container(
              height: 58,
              width: 58,
              decoration: BoxDecoration(
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
                    offset: const Offset(0, 3), // changes position of shadow
                  ),
                ],
                shape: BoxShape.circle,
              ),
              child: const Center(
                child: Icon(Icons.add, color: Colors.white, size: 40),
              ),
            ),
          ),
        ));
  }
}

class TopMenu extends StatelessWidget {
  const TopMenu({
    Key? key,
    required this.text,
    required this.iconLeft,
    required this.iconRight,
    required this.color,
  }) : super(key: key);
  final String text;
  final IconData iconLeft, iconRight;
  final Color color;

  @override
  Widget build(BuildContext context) {
    double size = 25;
    bool isAnimationFinish =
        Provider.of<TriggerAnimations>(context).isAnimationFinish;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          IconButton(
              onPressed: () {
                if (isAnimationFinish) {
                  Provider.of<TriggerAnimations>(context, listen: false)
                      .trigger = false;
                  Provider.of<TriggerAnimations>(context, listen: false)
                      .isAnimationFinish = false;
                }
              },
              icon: Icon(iconLeft, color: color, size: size)),
          Text(text,
              style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                  fontSize: size)),
          IconButton(
              onPressed: () {},
              icon: Icon(iconRight, color: color, size: size)),
        ],
      ),
    );
  }
}

class PersonalData extends StatelessWidget {
  const PersonalData({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 50),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            decoration: const BoxDecoration(
              color: Colors.white,
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                    offset: Offset(5, 10),
                    blurRadius: 10,
                    color: Colors.black54,
                    spreadRadius: 5)
              ],
            ),
            child: const CircleAvatar(
              radius: 40,
              backgroundImage: AssetImage('lib/assets/images/alex.jpg'),
            ),
          ),
          const SizedBox(height: 40),
          RichText(
            text: const TextSpan(
              text: 'Hi, ',
              style: TextStyle(
                  color: Colors.white,
                  fontSize: 30,
                  fontWeight: FontWeight.w300),
              children: <TextSpan>[
                TextSpan(
                    text: 'Alex',
                    style:
                        TextStyle(fontWeight: FontWeight.bold, fontSize: 30)),
              ],
            ),
          ),
          const SizedBox(height: 20),
          const Text(
            'Looks like feel good.\nYou have 3 to do today.',
            style: TextStyle(
                color: Colors.white70,
                fontSize: 18,
                fontWeight: FontWeight.normal),
          ),
          const SizedBox(height: 50),
          const Text(
            'TODAY | SEPTEMBER 12, 2007',
            style: TextStyle(
                color: Colors.white, fontSize: 14, fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }
}

Future<void> splitTask(List<TODOTypes> items, List<ItemTask> itemToday,
    List<ItemTask> itemTomorrow, int i) async {
  for (var element in items[i].itemTask) {
    if (element.date == 'today') {
      itemToday.add(element);
    } else if (element.date == 'tomorrow') {
      itemTomorrow.add(element);
    }
  }
}
