import 'package:floor/floor.dart';
import 'post.dart';

@Entity(tableName: 'comments', foreignKeys: [
  ForeignKey(
    childColumns: ['postId'],
    parentColumns: ['id'],
    entity: Post,
  )
])
class Comment {
  @PrimaryKey(autoGenerate: true)
  final int? id;
  final int postId;
  final String message;

  Comment({this.id, required this.postId, required this.message});
}
