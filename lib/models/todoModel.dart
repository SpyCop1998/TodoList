import 'package:cloud_firestore/cloud_firestore.dart';

class TodoModel {
  String? id;
  String? title;
  String? desc;
  Timestamp? dateAndTime;
  String? category;
  bool? isFinished;

  TodoModel(
      {this.id,
      this.title,
      this.desc,
      this.dateAndTime,
      this.category,
      this.isFinished});

  TodoModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    title = json['title'];
    desc = json['desc'];
    dateAndTime = json['dateAndTime'];
    category = json['category'];
    isFinished = json['isFinished'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['title'] = this.title;
    data['desc'] = this.desc;
    data['dateAndTime'] = this.dateAndTime;
    data['category'] = this.category;
    data['isFinished'] = this.isFinished;
    return data;
  }
}
