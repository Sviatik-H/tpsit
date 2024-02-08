
import 'package:floor/floor.dart';

@Entity(tableName: 'posts')
class Post {
  @PrimaryKey(autoGenerate: true)
  final int? id;
  final String name;
  final String title;

  Post({this.id, required this.name, required this.title});
}
