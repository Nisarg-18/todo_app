import 'package:todo_app/Note.dart';
import 'package:todo_app/database_helper.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class NoteDetail extends StatefulWidget {
  final Note note;
  final String title;
  const NoteDetail({Key? key, required this.note, required this.title})
      : super(key: key);

  @override
  _NoteDetailState createState() => _NoteDetailState();
}

class _NoteDetailState extends State<NoteDetail> {
  String hl = '';
  DatabaseHelper helper = DatabaseHelper();
  var priorities = ['High', 'Low'];
  TextEditingController _titleController = TextEditingController();
  TextEditingController _descriptionController = TextEditingController();

  updateTitle() {
    widget.note.title = _titleController.text;
  }

  updateDesc() {
    widget.note.description = _descriptionController.text;
  }

  _save() async {
    moveToListScreen();
    widget.note.date = DateFormat.yMMMd().format(DateTime.now());
    int result;
    if (widget.note.id != null) {
      result = await helper.updateNote(widget.note);
    } else {
      result = await helper.insertNote(widget.note);
    }

    if (result != 0) {
      showDailogBox('Status', 'Note Saved Successfully');
    } else {
      showDailogBox('Status', 'Could not save the Note');
    }
  }

  _delete() async {
    moveToListScreen();
    if (widget.note.id == null) {
      showDailogBox('Status', 'First add a note');
      return;
    }
    int result;
    result = await helper.deleteNote(widget.note.id);
    if (result != 0) {
      showDailogBox('Status', 'Note Deleted Successfully');
    } else {
      showDailogBox('Status', 'Could not delete the Note');
    }
  }

  //convert string to int
  priorityStringToInt(String value) {
    switch (value) {
      case 'High':
        widget.note.priority = 1;
        break;

      case 'Low':
        widget.note.priority = 2;
        break;
    }
  }

  //convert int to String
  String priorityIntToString(int value) {
    String priority = '0';
    switch (value) {
      case 1:
        priority = priorities[0];
        break;

      case 2:
        priority = priorities[1];
        break;
    }
    return priority;
  }

  moveToListScreen() {
    Navigator.pop(context, true);
  }

  showDailogBox(String title, String message) {
    AlertDialog alertDialog = AlertDialog(
      title: Text(title),
      content: Text(message),
    );
    showDialog(context: context, builder: (_) => alertDialog);
  }

  @override
  Widget build(BuildContext context) {
    TextStyle? textStyle = Theme.of(context).textTheme.headline6;
    _titleController.text = widget.note.title;
    _descriptionController.text = widget.note.description;
    return WillPopScope(
        child: Scaffold(
          appBar: AppBar(
            title: Text(widget.title),
            backgroundColor: Theme.of(context).primaryColor,
          ),
          body: SingleChildScrollView(
            child: Padding(
              padding: EdgeInsets.all(10.0),
              child: Card(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15.0),
                ),
                child: ListView(
                  shrinkWrap: true,
                  children: <Widget>[
                    Padding(
                      padding: EdgeInsets.only(top: 15.0, bottom: 5.0),
                      //dropdown menu
                      child: new ListTile(
                        leading: const Icon(Icons.low_priority),
                        title: DropdownButton(
                            items: priorities.map((String dropDownStringItem) {
                              return DropdownMenuItem<String>(
                                value: dropDownStringItem,
                                child: Text(dropDownStringItem,
                                    style: TextStyle(
                                        fontSize: 20.0,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.red)),
                              );
                            }).toList(),
                            value: priorityIntToString(widget.note.priority),
                            onChanged: (valueSelectedByUser) {
                              var object = valueSelectedByUser.toString();
                              if (this.mounted) {
                                setState(() {
                                  priorityStringToInt(object);
                                });
                              }
                            }),
                      ),
                    ),
                    // Second Element
                    Padding(
                      padding:
                          EdgeInsets.only(top: 15.0, bottom: 15.0, left: 15.0),
                      child: TextField(
                        controller: _titleController,
                        style: textStyle,
                        onChanged: (value) {
                          updateTitle();
                        },
                        decoration: InputDecoration(
                          labelText: 'Title',
                          labelStyle: textStyle,
                          icon: Icon(Icons.title),
                        ),
                      ),
                    ),

                    // Third Element
                    Padding(
                      padding:
                          EdgeInsets.only(top: 15.0, bottom: 15.0, left: 15.0),
                      child: TextField(
                        controller: _descriptionController,
                        style: textStyle,
                        onChanged: (value) {
                          updateDesc();
                        },
                        decoration: InputDecoration(
                          labelText: 'Details',
                          icon: Icon(Icons.details),
                        ),
                      ),
                    ),

                    // Fourth Element
                    Padding(
                      padding: EdgeInsets.all(15.0),
                      child: Row(
                        children: <Widget>[
                          Expanded(
                            child: TextButton(
                              child: Text(
                                'Save',
                                textScaleFactor: 1.5,
                                style: TextStyle(color: Colors.black),
                              ),
                              onPressed: () {
                                setState(() {
                                  debugPrint("Save button clicked");
                                  _save();
                                });
                              },
                            ),
                          ),
                          Container(
                            width: 5.0,
                          ),
                          Expanded(
                            child: TextButton(
                              child: Text(
                                'Delete',
                                textScaleFactor: 1.5,
                                style: TextStyle(color: Colors.black),
                              ),
                              onPressed: () {
                                setState(() {
                                  _delete();
                                });
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
        onWillPop: () => moveToListScreen());
  }
}
