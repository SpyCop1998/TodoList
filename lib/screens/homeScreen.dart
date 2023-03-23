import 'dart:ffi';
import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:intl/intl.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import 'package:provider/provider.dart';
import 'package:todo_app/providers/taskInfoProvider.dart';
import 'package:todo_app/screens/addTask.dart';
import '../models/Todo.dart';
import '../providers/splashProvider.dart';
import '../providers/todoProvider.dart';

class HomeSceen extends StatelessWidget {
  HomeSceen({Key? key}) : super(key: key);
  final GlobalKey<ScaffoldMessengerState> _scaffoldMessengerKey = GlobalKey<ScaffoldMessengerState>();


  List<String> getNos(List<TodoModel> list) {
    int res = 0;
    int res1 = 0;
    for (int i = 0; i < list.length; i++) {
      if (list[i].isFinished == true) {
        res++;
      } else {
        res1++;
      }
    }
    List<String> retv = <String>[];
    retv.add(res.toString());
    retv.add(res1.toString());
    retv.add(((res * 100) / res1).toString());
    return retv;
  }

  double getPercentageComplete(List<TodoModel> list) {
    String retv;
    int res = 0;
    int res1 = 0;
    for (int i = 0; i < list.length; i++) {
      if (list[i].isFinished == true) {
        res++;
      } else {
        res1++;
      }
    }
    return ((res * 100) / res1) / 100;
  }

  @override
  Widget build(BuildContext context) {
    final tp = Provider.of<TodoProvider>(context, listen: false);
    final authProvider = Provider.of<SplashProvider>(context, listen: false);

    return Scaffold(
      key: _scaffoldMessengerKey,
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.of(context).push(MaterialPageRoute(
              builder: (context) =>
                  AddTask(
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
              return Placeholder();
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
                            opacity: 0.6),
                      ),
                      height: MediaQuery
                          .of(context)
                          .size
                          .width / 1.6,
                      width: MediaQuery
                          .of(context)
                          .size
                          .width,
                      child: header(context, tp)),
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
            ? Text("no task found")
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
      // padding: context.padding2x,
      padding: EdgeInsets.all(0),
      shrinkWrap: shrinkWrap,
      children: [
        // _searchField(context, pv),
        // context.emptySizedHeightBox3x,
        _todos(context, pv, sp)
      ],
    );
  }

  Widget _todos(BuildContext context, TodoProvider pv, SplashProvider sp) {
    bool shrinkWrap = true;
    int todoLength = pv.todoList.length;
    // if (_todoController.text.isNotEmpty) {
    //   todoLength = pv.searchList.length;
    // }
    return ListView.separated(
      shrinkWrap: shrinkWrap,
      // physics: context.neverScroll,
      itemBuilder: (context, index) {
        TodoModel todo = pv.todoList[index];
        // if (_todoController.text.isNotEmpty) {
        //   todo = pv.searchList[index];
        // }
        return _todo(context, todo, pv, sp);
      },
      separatorBuilder: (_, __) =>
          SizedBox(
            height: 10,
          ),
      itemCount: todoLength,
    );
  }

  Widget header(BuildContext context, TodoProvider pv) {
    // final taskInfoProvider = Provider.of<TaskInfoProvider>(context);
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
                  Text((pv.perComp!.toDouble()*100).toStringAsFixed(1) + "% done",
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
      SplashProvider sp) {
    String title = "${todo.title}";
    String subtitle = "${todo.desc}";
    String category = "${todo.category}";
    String id = "${todo.id}";
    final formattedDate =
    DateFormat('MMM dd, yyyy').format(todo.dateAndTime!.toDate());
    String date = formattedDate;
    return Slidable(
      startActionPane: ActionPane(
        motion: const StretchMotion(),
        children: [
          SlidableAction(
            onPressed: (context) async {
              Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) =>
                      AddTask(
                        jsonObj: todo.toJson(),
                      )));
              // pv.updateTodo(todoId: , userId: userId, obj: {})
            },
            // onPressed: (context) => _goToEditTodoPage(context, todo),
            backgroundColor: Colors.blueAccent,
            foregroundColor: Colors.white,
            icon: Icons.edit,
          ),
          SlidableAction(
            onPressed: (context) async {
              int status=await pv.deleteTodo(todoId: id, userId: sp.token.toString());
              if (status == 200) {
                _showSnackBar(true,context);
              }else{
                _showSnackBar(false,context);

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
              int status=await pv.updateTodo(
                  todoId: id, obj: todo.toJson(), userId: sp.token.toString());
              if (status == 200) {
                _showSnackBar(true,context);
              }else{
                _showSnackBar(false,context);
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
    );
  }

  void _showSnackBar(bool isSuccess,BuildContext context) {
    // final snackBar = SnackBar(
    //   content: Text(
    //     isSuccess ? 'Success!' : 'Failure!',
    //     style: TextStyle(color: Colors.white),
    //   ),
    //   backgroundColor: isSuccess ? Colors.green : Colors.red,
    // );
    // // _scaffoldMessengerKey.currentState?.showSnackBar(snackBar);
    // ScaffoldMessenger.of(context).showSnackBar(
    //   snackBar
    // );
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
}}
