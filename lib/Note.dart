class Note {
  int id = 0;
  String title;
  String date;
  String description;
  int priority;

  Note(
      {required this.title,
      required this.date,
      required this.description,
      required this.priority});

  Note.withId(
      {required this.title,
      required this.date,
      required this.description,
      required this.priority,
      required this.id});

  get getId => this.id;
  get getTitle => this.title;

  set setTitle(title) {
    if (title.length < 255) {
      this.title = title;
    }
  }

  get getDate => this.date;

  set setDate(date) => this.date = date;

  get getDescription => this.description;

  set setDescription(description) {
    if (description.length < 255) {
      this.description = description;
    }
  }

  int get getPriority => this.priority;

  set setPriority(int priority) {
    if (priority >= 1 && priority <= 2) {
      this.priority = priority;
    }
  }

  Map<String, dynamic> toMap() {
    final map = Map<String, dynamic>();
    if (id == null) {
      map['id'] = id;
    }
    map['title'] = title;
    map['date'] = date;
    map['priority'] = priority;
    return map;
  }

  factory Note.fromMap(Map<String, dynamic> map) {
    return Note.withId(
      id: map['id'],
      title: map['title'],
      date: map['date'],
      description: map['description'],
      priority: map['priority'],
    );
  }
}
