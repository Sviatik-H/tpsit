// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_database.dart';

// **************************************************************************
// FloorGenerator
// **************************************************************************

// ignore: avoid_classes_with_only_static_members
class $FloorAppDatabase {
  /// Creates a database builder for a persistent database.
  /// Once a database is built, you should keep a reference to it and re-use it.
  static _$AppDatabaseBuilder databaseBuilder(String name) =>
      _$AppDatabaseBuilder(name);

  /// Creates a database builder for an in memory database.
  /// Information stored in an in memory database disappears when the process is killed.
  /// Once a database is built, you should keep a reference to it and re-use it.
  static _$AppDatabaseBuilder inMemoryDatabaseBuilder() =>
      _$AppDatabaseBuilder(null);
}

class _$AppDatabaseBuilder {
  _$AppDatabaseBuilder(this.name);

  final String? name;

  final List<Migration> _migrations = [];

  Callback? _callback;

  /// Adds migrations to the builder.
  _$AppDatabaseBuilder addMigrations(List<Migration> migrations) {
    _migrations.addAll(migrations);
    return this;
  }

  /// Adds a database [Callback] to the builder.
  _$AppDatabaseBuilder addCallback(Callback callback) {
    _callback = callback;
    return this;
  }

  /// Creates the database and initializes it.
  Future<AppDatabase> build() async {
    final path = name != null
        ? await sqfliteDatabaseFactory.getDatabasePath(name!)
        : ':memory:';
    final database = _$AppDatabase();
    database.database = await database.open(
      path,
      _migrations,
      _callback,
    );
    return database;
  }
}

class _$AppDatabase extends AppDatabase {
  _$AppDatabase([StreamController<String>? listener]) {
    changeListener = listener ?? StreamController<String>.broadcast();
  }

  PostDao? _postDaoInstance;

  CommentDao? _commentDaoInstance;

  Future<sqflite.Database> open(
    String path,
    List<Migration> migrations, [
    Callback? callback,
  ]) async {
    final databaseOptions = sqflite.OpenDatabaseOptions(
      version: 1,
      onConfigure: (database) async {
        await database.execute('PRAGMA foreign_keys = ON');
        await callback?.onConfigure?.call(database);
      },
      onOpen: (database) async {
        await callback?.onOpen?.call(database);
      },
      onUpgrade: (database, startVersion, endVersion) async {
        await MigrationAdapter.runMigrations(
            database, startVersion, endVersion, migrations);

        await callback?.onUpgrade?.call(database, startVersion, endVersion);
      },
      onCreate: (database, version) async {
        await database.execute(
            'CREATE TABLE IF NOT EXISTS `posts` (`id` INTEGER PRIMARY KEY AUTOINCREMENT, `name` TEXT NOT NULL, `title` TEXT NOT NULL)');
        await database.execute(
            'CREATE TABLE IF NOT EXISTS `comments` (`id` INTEGER PRIMARY KEY AUTOINCREMENT, `postId` INTEGER NOT NULL, `message` TEXT NOT NULL, FOREIGN KEY (`postId`) REFERENCES `posts` (`id`) ON UPDATE NO ACTION ON DELETE CASCADE)');

        await callback?.onCreate?.call(database, version);
      },
    );
    return sqfliteDatabaseFactory.openDatabase(path, options: databaseOptions);
  }

  @override
  PostDao get postDao {
    return _postDaoInstance ??= _$PostDao(database, changeListener);
  }

  @override
  CommentDao get commentDao {
    return _commentDaoInstance ??= _$CommentDao(database, changeListener);
  }
}

class _$PostDao extends PostDao {
  _$PostDao(
    this.database,
    this.changeListener,
  )   : _queryAdapter = QueryAdapter(database),
        _postInsertionAdapter = InsertionAdapter(
            database,
            'posts',
            (Post item) => <String, Object?>{
                  'id': item.id,
                  'name': item.name,
                  'title': item.title
                }),
        _postUpdateAdapter = UpdateAdapter(
            database,
            'posts',
            ['id'],
            (Post item) => <String, Object?>{
                  'id': item.id,
                  'name': item.name,
                  'title': item.title
                }),
        _postDeletionAdapter = DeletionAdapter(
            database,
            'posts',
            ['id'],
            (Post item) => <String, Object?>{
                  'id': item.id,
                  'name': item.name,
                  'title': item.title
                });

  final sqflite.DatabaseExecutor database;

  final StreamController<String> changeListener;

  final QueryAdapter _queryAdapter;

  final InsertionAdapter<Post> _postInsertionAdapter;

  final UpdateAdapter<Post> _postUpdateAdapter;

  final DeletionAdapter<Post> _postDeletionAdapter;

  @override
  Future<List<Post>> getAllPosts() async {
    return _queryAdapter.queryList('SELECT * FROM posts',
        mapper: (Map<String, Object?> row) => Post(
            id: row['id'] as int?,
            name: row['name'] as String,
            title: row['title'] as String));
  }

  @override
  Future<void> insertPost(Post post) async {
    await _postInsertionAdapter.insert(post, OnConflictStrategy.abort);
  }

  @override
  Future<void> updatePost(Post post) async {
    await _postUpdateAdapter.update(post, OnConflictStrategy.abort);
  }

  @override
  Future<void> deletePost(Post post) async {
    await _postDeletionAdapter.delete(post);
  }
}

class _$CommentDao extends CommentDao {
  _$CommentDao(
    this.database,
    this.changeListener,
  )   : _queryAdapter = QueryAdapter(database),
        _commentInsertionAdapter = InsertionAdapter(
            database,
            'comments',
            (Comment item) => <String, Object?>{
                  'id': item.id,
                  'postId': item.postId,
                  'message': item.message
                }),
        _commentUpdateAdapter = UpdateAdapter(
            database,
            'comments',
            ['id'],
            (Comment item) => <String, Object?>{
                  'id': item.id,
                  'postId': item.postId,
                  'message': item.message
                }),
        _commentDeletionAdapter = DeletionAdapter(
            database,
            'comments',
            ['id'],
            (Comment item) => <String, Object?>{
                  'id': item.id,
                  'postId': item.postId,
                  'message': item.message
                });

  final sqflite.DatabaseExecutor database;

  final StreamController<String> changeListener;

  final QueryAdapter _queryAdapter;

  final InsertionAdapter<Comment> _commentInsertionAdapter;

  final UpdateAdapter<Comment> _commentUpdateAdapter;

  final DeletionAdapter<Comment> _commentDeletionAdapter;

  @override
  Future<List<Comment>> getAllComments() async {
    return _queryAdapter.queryList('SELECT * FROM comments',
        mapper: (Map<String, Object?> row) => Comment(
            id: row['id'] as int?,
            postId: row['postId'] as int,
            message: row['message'] as String));
  }

  @override
  Future<void> insertComment(Comment comment) async {
    await _commentInsertionAdapter.insert(comment, OnConflictStrategy.abort);
  }

  @override
  Future<void> updateComment(Comment comment) async {
    await _commentUpdateAdapter.update(comment, OnConflictStrategy.abort);
  }

  @override
  Future<void> deleteComment(Comment comment) async {
    await _commentDeletionAdapter.delete(comment);
  }
}
