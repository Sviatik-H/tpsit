import 'package:floor/floor.dart';

@entity
class Todo {
  Todo({required this.id, required this.name, this.checked = false});

  @primaryKey
  final int? id;

  final String name;
  bool checked;
}

@entity
class Post {
  Post({required this.id, required this.title});

  @primaryKey
  final int? id;

  final String title;
}

@entity
class Comment {
  Comment({required this.id, required this.text});

  @primaryKey
  final int? id;

  final String text;
}