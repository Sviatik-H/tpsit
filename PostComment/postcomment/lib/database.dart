import 'dart:async';

import 'package:floor/floor.dart';
import 'package:sqflite/sqflite.dart' as sqflite;

import 'dao.dart';
import 'model.dart';

part 'database.g.dart'; // the generated code will be there

@Database(version: 1, entities: [Post, Comment])
abstract class AppDatabase extends FloorDatabase {
  PostDao get postDao;
}
