import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:todo_app/providers/todoProvider.dart';
import 'package:uuid/uuid.dart';
import '../providers/splashProvider.dart';
import '../widgets/buttons.dart';
import '../widgets/textFormField.dart';
import '../widgets/utils.dart';

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
  final GlobalKey<ScaffoldMessengerState> _scaffoldMessengerKey =
      GlobalKey<ScaffoldMessengerState>();

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
      key: _scaffoldMessengerKey,
      child: Scaffold(
        backgroundColor: HexColor("#46539e"),
        // backgroundColor: Color(0x46539e),
        body: SingleChildScrollView(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    BackButtonB(onPressed: () => {Navigator.pop(context)}),
                    Padding(
                      padding: const EdgeInsets.only(left: 35, right: 35),
                      child: Text(
                        "Add New Task",
                        style: TextStyle(fontSize: 20, color: Colors.white),
                      ),
                    ),
                    HamButtonB(
                      onPressed: () => {},
                    )
                  ],
                ),
              ),
              SizedBox(
                height: MediaQuery.of(context).size.width / 10,
              ),
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
              SizedBox(
                height: MediaQuery.of(context).size.width / 12,
              ),
              Padding(
                padding: EdgeInsets.all(16.0),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      DropdownButtonFormField<String>(
                        decoration: InputDecoration(
                          contentPadding: EdgeInsets.all(0),
                          hintText: "Category",
                          filled: true,
                          fillColor: HexColor("#46539e"),
                          enabledBorder: UnderlineInputBorder(
                            borderSide: BorderSide(color: Colors.white70),
                          ),
                          focusedBorder: UnderlineInputBorder(
                            borderSide: BorderSide(color: Colors.white70),
                          ),
                        ),
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
                      SizedBox(height: 16.0),
                      TextFormFieldWithTrailingIcon(
                        readOnly: false,
                        controller: _titleController,
                        hitText: "Title",
                        onPressedClear: () {
                          setState(() {
                            _titleController.text = '';
                          });
                        },
                        onTap: () => {},
                      ),
                      SizedBox(height: 16.0),
                      TextFormFieldWithTrailingIcon(
                        readOnly: false,
                        controller: _descController,
                        hitText: "Description",
                        onPressedClear: () {
                          setState(() {
                            _descController.text = '';
                          });
                        },
                        onTap: () {},
                      ),
                      SizedBox(height: 16.0),
                      TextFormFieldWithTrailingIcon(
                        readOnly: true,
                        controller: _dateController,
                        hitText: "Date",
                        onPressedClear: () {
                          setState(() {
                            _dateController.text = '';
                          });
                        },
                        onTap: () => _selectDate(context),
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
                              // if (statusCode == 200) {
                              //
                              // }

                              if (statusCode == 200) {
                                showToast(true);
                                tv.getTodos(authProvider.token.toString());
                                Navigator.pop(context);
                              } else {
                                showToast(false);
                              }
                            } else {
                              print("object");
                            }
                          },
                          buttonText: widget.jsonObj.isEmpty
                              ? 'ADD TASK'
                              : "UPDATE TASK",
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
