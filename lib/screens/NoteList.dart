import 'package:todo_app/database_helper.dart';
import 'package:todo_app/screens/Note_details.dart';
import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';

import '../Note.dart';

class NoteList extends StatefulWidget {
  const NoteList({Key? key}) : super(key: key);

  @override
  _NoteListState createState() => _NoteListState();
}

class _NoteListState extends State<NoteList> {
  DatabaseHelper databaseHelper = DatabaseHelper();
  List<Note>? noteList;
  int count = 0;
  navigateToDetail(Note note, String title) async {
    bool result =
        await Navigator.push(context, MaterialPageRoute(builder: (context) {
      return NoteDetail(note: note, title: title);
    }));

    if (result == true) {
      updateListView();
    }
  }

  ListView getNoteListView() {
    return ListView.builder(
      shrinkWrap: true,
      itemCount: count,
      itemBuilder: (context, position) {
        return Card(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10.0),
          ),
          color: Colors.deepPurple,
          elevation: 4.0,
          child: ListTile(
            leading: Icon(Icons.task),
            title: Text(
              this.noteList![position].title,
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 25.0,
              ),
            ),
            subtitle: Text(
              this.noteList![position].date,
              style: TextStyle(color: Colors.white),
            ),
            trailing: GestureDetector(
              child: Icon(Icons.open_in_new, color: Colors.white),
              onTap: () {
                navigateToDetail(this.noteList![position], 'Edit Todo');
              },
            ),
          ),
        );
      },
    );
  }

  void updateListView() {
    final Future<Database> dbFuture = databaseHelper.initalizeDatabase();
    dbFuture.then((database) {
      Future<List<Note>> noteListFuture = databaseHelper.getNoteList();
      noteListFuture.then((noteList) {
        if (this.mounted) {
          setState(() {
            this.noteList = noteList;
            this.count = noteList.length;
          });
        }
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    if (noteList == null) {
      noteList = <Note>[];
      updateListView();
    }
    return Scaffold(
      appBar: AppBar(
        title: Text('ToDo'),
        backgroundColor: Theme.of(context).primaryColor,
      ),
      body: SingleChildScrollView(child: getNoteListView()),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          navigateToDetail(
              Note(title: '', description: '', date: '', priority: 2), '');
        },
        child: Icon(Icons.add),
      ),
    );
  }
}
