// import 'package:flutter/cupertino.dart';
// import 'package:shared_preferences/shared_preferences.dart';
//
// import '../models/Todo.dart';
//
// class TaskInfoProvider extends ChangeNotifier {
//   String? _completed;
//
//   String? get completed => _completed;
//
//   String? _notCompleted;
//
//   String? get notCompleted => _notCompleted;
//
//   String? _stringPer;
//
//   String? get stringPer => _stringPer;
//
//   double? _perComp;
//
//   double? get perComp => _perComp;
//
//   List<String> getNos(List<TodoModel> list) {
//     int res = 0;
//     int res1 = 0;
//     for (int i = 0; i < list.length; i++) {
//       if (list[i].isFinished == true) {
//         res++;
//       } else {
//         res1++;
//       }
//     }
//     List<String> retv = <String>[];
//     retv.add(res.toString());
//     retv.add(res1.toString());
//     retv.add(((res * 100) / res1).toString());
//     return retv;
//   }
//
//   double getPercentageComplete(List<TodoModel> list) {
//     String retv;
//     int res = 0;
//     int res1 = 0;
//     for (int i = 0; i < list.length; i++) {
//       if (list[i].isFinished == true) {
//         res++;
//       } else {
//         res1++;
//       }
//     }
//     return ((res * 100) / res1) / 100;
//   }
//
//   void getTaskInfo(List<TodoModel> list) {
//     _completed=getNos(list)[0];
//     _notCompleted=getNos(list)[1];
//     _perComp=getPercentageComplete(list);
//     _stringPer=(getPercentageComplete(list)*100).toString();
//     notifyListeners();
//   }
// }
