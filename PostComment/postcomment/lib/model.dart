import 'package:floor/floor.dart';

@entity
class Post {
  Post({required this.id, required this.text});

  @primaryKey
  final int? id;

  String text;
}

@entity
class Comment {
  Comment({required this.id, required this.text, required this.postId});

  @primaryKey
  final int? id;

  String text;
  @ForeignKey(
      childColumns: ["postId"],
      parentColumns: ["id"],
      entity: Post,
      onDelete: ForeignKeyAction.cascade)
  final int postId;
}
