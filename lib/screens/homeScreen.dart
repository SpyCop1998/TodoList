import 'dart:ffi';
import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import 'package:provider/provider.dart';
import 'package:todo_app/screens/addTask.dart';
import '../models/todoModel.dart';
import '../providers/splashProvider.dart';
import '../providers/todoProvider.dart';
import '../widgets/utils.dart';

class HomeSceen extends StatelessWidget {
  HomeSceen({Key? key}) : super(key: key);
  final GlobalKey<ScaffoldMessengerState> _scaffoldMessengerKey =
      GlobalKey<ScaffoldMessengerState>();

  @override
  Widget build(BuildContext context) {
    final tp = Provider.of<TodoProvider>(context, listen: false);
    final authProvider = Provider.of<SplashProvider>(context, listen: false);

    return Scaffold(
      key: _scaffoldMessengerKey,
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.of(context).push(MaterialPageRoute(
              builder: (context) => AddTask(
                    jsonObj: {},
                  )));
        },
        child: Icon(Icons.add),
      ),
      body: FutureBuilder(
        future: tp.getTodos(authProvider.token.toString()),
        builder: (_, snapshot) {
          switch (snapshot.connectionState) {
            case ConnectionState.waiting:
              //add shimmer here
              return Center(child: CircularPercentIndicator(radius: 20));
            default:
              return Column(
                children: [
                  Container(
                      decoration: BoxDecoration(
                        // color: Colors.green,
                        image: DecorationImage(
                            image: AssetImage(
                              "assets/bg.jpg",
                            ),
                            fit: BoxFit.cover,
                            opacity: 0.8),
                      ),
                      height: MediaQuery.of(context).size.width / 1.6,
                      width: MediaQuery.of(context).size.width,
                      child: headerIsDone()),
                  _connectionStateIsDone(authProvider),
                ],
              );
          }
        },
      ),
    );
  }

  Consumer<TodoProvider> _connectionStateIsDone(SplashProvider sp) {
    return Consumer<TodoProvider>(
      builder: (context, pv, _) {
        bool shrinkWrap = true;
        Widget body = pv.todoList.isEmpty
            ? Container(
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height -
                    MediaQuery.of(context).size.width / 1.6,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      "No Task Found",
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 20,
                          color: Colors.red),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Icon(
                      Icons.error,
                      size: 50,
                      color: Colors.red,
                    )
                  ],
                ))
            : _body(context, shrinkWrap, pv, sp);
        return FadeInLeft(
          child: body,
        );
      },
    );
  }

  ListView _body(BuildContext context, bool shrinkWrap, TodoProvider pv,
      SplashProvider sp) {
    return ListView(
      padding: EdgeInsets.all(0),
      shrinkWrap: shrinkWrap,
      children: [_todos(context, pv, sp)],
    );
  }

  Widget _todos(BuildContext context, TodoProvider pv, SplashProvider sp) {
    bool shrinkWrap = true;
    int todoLength = pv.todoList.length;
    int sep = -1;
    for (int i = 0; i < pv.todoList.length; i++) {
      if (pv.todoList[i].isFinished == false) {
        sep++;
      }
    }
    return ListView.separated(
      shrinkWrap: shrinkWrap,
      itemBuilder: (context, index) {
        TodoModel todo = pv.todoList[index];
        return _todo(context, todo, pv, sp, index, sep);
      },
      separatorBuilder: (_, __) => SizedBox(
        height: 10,
      ),
      itemCount: todoLength,
    );
  }

  Consumer<TodoProvider> headerIsDone() {
    return Consumer<TodoProvider>(
      builder: (context, pv, _) {
        return header(pv);
      },
    );
  }

  Widget header(TodoProvider pv) {
    final currentDate = DateTime.now();
    final formattedDate = DateFormat('MMM dd, yyyy').format(currentDate);
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // Spacer(),
              Text("Your\nThings",
                  style: TextStyle(fontSize: 30.0, color: Colors.white70)),
              Spacer(),
              Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    pv.completed.toString(),
                    style: TextStyle(fontSize: 25.0, color: Colors.white),
                  ),
                  Text(
                    "Completed",
                    style: TextStyle(fontSize: 10.0, color: Colors.white70),
                  )
                ],
              ),
              SizedBox(
                width: 10,
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    pv.notCompleted.toString(),
                    style: TextStyle(fontSize: 25.0, color: Colors.white),
                  ),
                  Text(
                    "Not Completed",
                    style: TextStyle(fontSize: 10.0, color: Colors.white70),
                  )
                ],
              ),
            ],
          ),
          SizedBox(
            height: 40,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // Spacer(),
              Text(formattedDate,
                  style: TextStyle(fontSize: 13.0, color: Colors.white70)),
              Spacer(),
              Row(
                children: [
                  CircularPercentIndicator(
                    radius: 10.0,
                    lineWidth: 3.0,
                    percent: pv.perComp!.toDouble(),
                    // center: new Text("60%"),
                    progressColor: Colors.lightBlueAccent,
                  ),
                  SizedBox(
                    width: 7,
                  ),
                  Text(
                      (pv.perComp!.toDouble() * 100).toStringAsFixed(1) +
                          "% done",
                      style: TextStyle(fontSize: 13.0, color: Colors.white70)),
                ],
              )
            ],
          )
        ],
      ),
    );
  }

  Widget _todo(BuildContext context, TodoModel todo, TodoProvider pv,
      SplashProvider sp, int index, int sep) {
    String title = "${todo.title}";
    String subtitle = "${todo.desc}";
    String category = "${todo.category}";
    String id = "${todo.id}";
    final formattedDate =
        DateFormat('MMM dd, yyyy').format(todo.dateAndTime!.toDate());
    String date = formattedDate;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        index == 0 && sep != -1
            ? Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text("Not Completed"),
              )
            : SizedBox(),
        index == sep + 1
            ? Row(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text("Completed"),
                  ),
                  Container(
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(100),
                        color: Colors.black45),
                    width: 20,
                    height: 20,
                    child: Center(
                      child: Text(
                        (pv.todoList.length - sep - 1 < 99
                                ? pv.todoList.length - sep - 1
                                : 99)
                            .toString(),
                        style: TextStyle(fontSize: 12),
                      ),
                    ),
                  )
                ],
              )
            : SizedBox(),
        Slidable(
          startActionPane: ActionPane(
            motion: const StretchMotion(),
            children: [
              SlidableAction(
                onPressed: (context) async {
                  Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => AddTask(
                            jsonObj: todo.toJson(),
                          )));
                },
                backgroundColor: Colors.blueAccent,
                foregroundColor: Colors.white,
                icon: Icons.edit,
              ),
              SlidableAction(
                onPressed: (context) async {
                  int status = await pv.deleteTodo(
                      todoId: id, userId: sp.token.toString());
                  if (status == 200) {
                    showToast(true);
                  } else {
                    showToast(false);
                  }
                },
                // onPressed: (context) => _deleteTodo(context, pv, todo),
                backgroundColor: Colors.redAccent,
                foregroundColor: Colors.white,
                icon: Icons.delete,
              ),
              SlidableAction(
                onPressed: (context) async {
                  todo.isFinished = true;
                  int status = await pv.updateTodo(
                      todoId: id,
                      obj: todo.toJson(),
                      userId: sp.token.toString());
                  if (status == 200) {
                    showToast(true);
                  } else {
                    showToast(false);
                  }
                },
                // onPressed: (context) => _doneTodo(context, pv, todo),
                backgroundColor: Colors.greenAccent,
                foregroundColor: Colors.white,
                icon: Icons.done,
              ),
            ],
          ),
          child: Container(
            child: ListTile(
              leading: _todoLeading(context, category),
              title: _todoTitle(context, title),
              subtitle: _todoSubtitle(context, subtitle),
              trailing: _todoTrailing(context, date),
            ),
          ),
        ),
      ],
    );
  }

  SizedBox _todoLeading(BuildContext context, String category) {
    return SizedBox(
      height: 62,
      width: 62,
      child: CircleAvatar(
        backgroundColor: Colors.white,
        child: Container(
          width: 60,
          height: 60,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(
              color: Colors.black38,
              width: 1.0,
            ),
          ),
          child: getLeadingIcon(category),
        ),
      ),
    );
  }

  Icon getLeadingIcon(String cat) {
    if (cat == "Personal") {
      return Icon(Icons.person_sharp, size: 32);
    } else if (cat == "Business") {
      return Icon(Icons.business_center, size: 32);
    }
    return Icon(Icons.work, size: 32);
  }

  Text _todoTrailing(BuildContext context, String date) {
    return Text(
      date,
      style: TextStyle(color: Colors.black45),
    );
  }

  Text _todoTitle(BuildContext context, String title) {
    return Text(
      title,
    );
  }

  Text _todoSubtitle(BuildContext context, String subtitle) {
    return Text(
      subtitle,
    );
  }
}
