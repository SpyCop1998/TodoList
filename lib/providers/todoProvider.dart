import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:todo_app/providers/taskInfoProvider.dart';
import '../models/Todo.dart';

class TodoProvider extends ChangeNotifier {
  final FirebaseFirestore firestore = FirebaseFirestore.instance;
  final CollectionReference collection =
      FirebaseFirestore.instance.collection('todos');

  List<TodoModel> _todoList = [];

  List<TodoModel> get todoList => _todoList;


  String? _completed;

  String? get completed => _completed;

  String? _notCompleted;

  String? get notCompleted => _notCompleted;

  String? _stringPer;

  String? get stringPer => _stringPer;

  double? _perComp;

  double? get perComp => _perComp;

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
    if(res1==0){
      retv.add((100).toString());
    }else {
      retv.add(((res * 100) / res1).toString());
    }
    return retv;
  }

  double getPercentageComplete(List<TodoModel> list) {
    int res = 0;
    int res1 = 0;
    for (int i = 0; i < list.length; i++) {
      if (list[i].isFinished == true) {
        res++;
      } else {
        res1++;
      }
    }if(list.isEmpty){
      return 1;
    }else {
      return (res/list.length);
    }
  }


  Future<void> getTodos(String userId) async {
    if (userId != null) {
      try {
        CollectionReference userRef = firestore.collection("User");
        var todos = userRef.doc(userId).collection("todos");
        var response = await todos.get();
        _todoList = response.docs
            .map(
              (e) => TodoModel.fromJson(e.data()),
            )
            .toList();
        _todoList.sort((a, b) {
          if (a.dateAndTime != null && b.dateAndTime != null) {
            return b.dateAndTime!.compareTo(a.dateAndTime!);
          } else {
            return b.dateAndTime!.compareTo(a.dateAndTime ?? Timestamp.now());
          }
        });
        _completed=getNos(_todoList)[0];
        _notCompleted=getNos(_todoList)[1];
        _perComp=getPercentageComplete(_todoList);
        _stringPer=(getPercentageComplete(_todoList)*100).toString();
      } catch (error) {
        print(error);
        _todoList = [];
        _completed="";
        _notCompleted="";
        _perComp=0.0;
        _stringPer="";
      }
      notifyListeners();
    }
  }

  Future<int> addTodo(
      {required Map<String, dynamic> obj, required String userId}) async {
    if (userId != null) {
      try {
        CollectionReference userRef = firestore.collection("User");
        var todos = userRef.doc(userId).collection("todos").doc(obj["id"]);
        await todos.set(obj);
        await getTodos(userId);
        // uiGlobals.showSnackBar(
        //   content: AppLocalizations.of(context)!.addTodoSuccess,
        //   context: context,
        // );
        // Navigator.pop(context);
        return 200;
      } catch (e) {
        print("hey");
        // uiGlobals.showSnackBar(
        //   content: e.toString(),
        //   context: context,
        // );
        return 400;
      }
    }
    return 500;
  }

  Future<int> updateTodo(
      {required String todoId,
      required Map<String, dynamic> obj,
      required String userId}) async {
    // String? userId = await Token.readToken("user");
    if (userId != null) {
      try {
        CollectionReference userRef = firestore.collection("User");
        var todo = userRef.doc(userId).collection("todos").doc(todoId);
        await todo.update(obj);
        await getTodos(userId);
        // uiGlobals.showSnackBar(
        //   content: AppLocalizations.of(context)!.updateTodoSuccess,
        //   context: context,
        // );
        // Navigator.pop(context);
        return 200;
      } catch (e) {
        // uiGlobals.showSnackBar(
        //   content: e.toString(),
        //   context: context,
        // );
        return 400;
      }
    }
    return 500;
  }

  Future<int> deleteTodo(
      {required String todoId, required String userId}) async {
    // String? userId = await Token.readToken("user");
    if (userId != null) {
      try {
        CollectionReference userRef = firestore.collection("User");
        var todo = userRef.doc(userId).collection("todos").doc(todoId);
        await todo.delete();
        await getTodos(userId);
        return 200;
        // Navigator.pop(context);
        // uiGlobals.showSnackBar(
        //   content: AppLocalizations.of(context)!.deleteTodoSuccess,
        //   context: context,
        // );
      } catch (e) {
        return 400;
        // uiGlobals.showSnackBar(
        //   content: e.toString(),
        //   context: context,
        // );
      }
    }
    return 500;
  }
}
