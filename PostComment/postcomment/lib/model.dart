import 'package:floor/floor.dart';

@Entity(tableName: "Post")
class Post {
  Post({required this.id, required this.text});

  @PrimaryKey(autoGenerate: true)
  final int? id;

  String text;
}

@Entity(tableName: "Comment", foreignKeys: [
  ForeignKey(
      childColumns: ["postId"],
      parentColumns: ["id"],
      entity: Post,
      onDelete: ForeignKeyAction.cascade)
])
class Comment {
  Comment({required this.id, required this.text, required this.postId});
  @PrimaryKey()
  final int? id;
  String text;
  @ColumnInfo(name: "postId")
  final int postId;
}
