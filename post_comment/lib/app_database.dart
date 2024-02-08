
import 'dart:async';
import 'package:floor/floor.dart';
import 'package:sqflite/sqflite.dart' as sqflite;
import 'package:path/path.dart';
import 'post_dao.dart';
import 'comment_dao.dart';
import 'post.dart';
import 'comment.dart';

part 'app_database.g.dart'; // Il file verrà generato da Floor

@Database(version: 1, entities: [Post, Comment])
abstract class AppDatabase extends FloorDatabase {
  PostDao get postDao;
  CommentDao get commentDao;
}
