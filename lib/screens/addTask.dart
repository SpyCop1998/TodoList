import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:todo_app/providers/todoProvider.dart';
import 'package:uuid/uuid.dart';
import '../providers/splashProvider.dart';
import '../widgets/Buttons.dart';

class AddTask extends StatefulWidget {
  const AddTask({Key? key, required this.jsonObj}) : super(key: key);
  final Map<String, dynamic> jsonObj;

  @override
  State<AddTask> createState() => _AddTaskState();
}

class _AddTaskState extends State<AddTask> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _descController = TextEditingController();

  late String _selectedOption;

  bool isFinished = false;
  var uuid = const Uuid();
  String id = "";
  List<String> _options = ['Personal', 'Business', 'Work'];
  late DateTime _selectedDate;

  @override
  void initState() {
    super.initState();
    if (widget.jsonObj.isEmpty) {
      _selectedDate = DateTime.now();
      _selectedOption = _options[0];
    } else {
      setState(() {
        final formattedDate = DateFormat('MMM dd, yyyy')
            .format(widget.jsonObj["dateAndTime"]!.toDate());
        String date = formattedDate;
        id = widget.jsonObj["id"];
        _selectedDate = widget.jsonObj["dateAndTime"]!.toDate();
        _dateController.text = date.toString();
        _titleController.text = widget.jsonObj["title"];
        _descController.text = widget.jsonObj["desc"];
        _selectedOption = widget.jsonObj["category"];
        isFinished = widget.jsonObj["isFinished"];
      });
    }
  }

  TextEditingController _dateController = TextEditingController();

  // DateTime _selectedDate = DateTime.now();

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );
    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
        final formattedDate = DateFormat('MMM dd, yyyy').format(picked);
        _dateController.text =
            formattedDate.toString(); // set the text of the TextFormField
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<SplashProvider>(context);
    final tv = Provider.of<TodoProvider>(context);
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.blueAccent,
        // backgroundColor: Color(0x46539e),
        body: SingleChildScrollView(
          child: Column(
            // mainAxisAlignment: MainAxisAlignment.center,
            // crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(height: MediaQuery.of(context).size.width/4,),
              CircleAvatar(
                backgroundColor: Colors.white,
                child: Container(
                  width: 60,
                  height: 60,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: Colors.white,
                      width: 1.0,
                    ),
                  ),
                  child: Icon(Icons.add_task, size: 32),
                ),
              ),
              SizedBox(height: MediaQuery.of(context).size.width/12,),
              Center(child: Text("Add New Task")),
              Padding(
                padding: EdgeInsets.all(16.0),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(

                        child: DropdownButtonFormField<String>(
                          decoration: InputDecoration(
                            hintText: "Category",
                            filled: true,
                            fillColor: Colors.blueAccent,
                            border: InputBorder.none,
                          ),
                          // isExpanded: true,

                          value: _selectedOption,
                          onChanged: (newString) {
                            setState(() {
                              _selectedOption = newString!;
                            });
                          },
                          items: _options
                              .map<DropdownMenuItem<String>>((String value) {
                            return DropdownMenuItem<String>(
                              value: value,
                              child: Text(value),
                            );
                          }).toList(),
                        ),
                        width: MediaQuery.of(context).size.width,
                      ),
                      TextFormField(
                        controller: _titleController,
                        decoration: InputDecoration(
                          //hintStyle: TextStyle(color: Colors.white70),
                          enabledBorder: UnderlineInputBorder(
                            borderSide: BorderSide(color: Colors.white70),
                          ),
                          focusedBorder: UnderlineInputBorder(
                            borderSide: BorderSide(color: Colors.white70),
                          ),
                          hintText: 'Title',
                        ),
                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'Please title';
                          }
                          return null;
                        },
                      ),
                      SizedBox(height: 16.0),
                      TextFormField(
                        controller: _descController,
                        decoration: InputDecoration(
                          //hintStyle: TextStyle(color: Colors.white70),
                          enabledBorder: UnderlineInputBorder(
                            borderSide: BorderSide(color: Colors.white70),
                          ),
                          focusedBorder: UnderlineInputBorder(
                            borderSide: BorderSide(color: Colors.white70),
                          ),
                          hintText: 'Description',
                        ),
                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'Please enter description';
                          }
                          return null;
                        },
                      ),
                      SizedBox(height: 16.0),
                      TextFormField(
                        onTap: () => _selectDate(context),
                        readOnly: true,
                        // prevent keyboard from showing up
                        // readOnly:true,
                        // enabled: ,
                        controller: _dateController,
                        decoration: InputDecoration(
                          // //hintStyle: TextStyle(color: Colors.white70),
                          //hintStyle: TextStyle(color: Colors.white70),
                          enabledBorder: UnderlineInputBorder(
                            borderSide: BorderSide(color: Colors.white70),
                          ),
                          focusedBorder: UnderlineInputBorder(
                            borderSide: BorderSide(color: Colors.white70),
                          ),
                          hintText: 'Date',
                        ),

                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'Please enter description';
                          }
                          return null;
                        },
                      ),
                      SizedBox(height: 25.0),
                      Center(
                        child: RoundedButton(
                          onPressed: () async {
                            if (_formKey.currentState!.validate()) {
                              if (id == "") {
                                id = uuid.v1();
                              }
                              Map<String, dynamic> obj = {
                                "id": id,
                                "title": _titleController.text.trim(),
                                "desc": _descController.text.trim(),
                                "dateAndTime": _selectedDate,
                                "category": _selectedOption,
                                "isFinished": isFinished
                              };
                              int statusCode = await tv.addTodo(
                                  obj: obj,
                                  userId: authProvider.token.toString());
                              if (statusCode == 200) {
                                tv.getTodos(authProvider.token.toString());
                                Navigator.pop(context);
                              }
                            } else {
                              print("object");
                            }
                          },
                          buttonText:
                              widget.jsonObj.isEmpty ? 'Add Task' : "Update Task",
                          // child: Text('Add Task'),
                        ),
                      ),
                    ],
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
