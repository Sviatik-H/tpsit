// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'database.dart';

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
            'CREATE TABLE IF NOT EXISTS `Post` (`id` INTEGER, `text` TEXT NOT NULL, PRIMARY KEY (`id`))');
        await database.execute(
            'CREATE TABLE IF NOT EXISTS `Comment` (`id` INTEGER, `text` TEXT NOT NULL, `postId` INTEGER NOT NULL, PRIMARY KEY (`id`))');

        await callback?.onCreate?.call(database, version);
      },
    );
    return sqfliteDatabaseFactory.openDatabase(path, options: databaseOptions);
  }

  @override
  PostDao get postDao {
    return _postDaoInstance ??= _$PostDao(database, changeListener);
  }
}

class _$PostDao extends PostDao {
  _$PostDao(
    this.database,
    this.changeListener,
  )   : _queryAdapter = QueryAdapter(database),
        _postInsertionAdapter = InsertionAdapter(database, 'Post',
            (Post item) => <String, Object?>{'id': item.id, 'text': item.text}),
        _commentInsertionAdapter = InsertionAdapter(
            database,
            'Comment',
            (Comment item) => <String, Object?>{
                  'id': item.id,
                  'text': item.text,
                  'postId': item.postId
                }),
        _postUpdateAdapter = UpdateAdapter(database, 'Post', ['id'],
            (Post item) => <String, Object?>{'id': item.id, 'text': item.text}),
        _commentUpdateAdapter = UpdateAdapter(
            database,
            'Comment',
            ['id'],
            (Comment item) => <String, Object?>{
                  'id': item.id,
                  'text': item.text,
                  'postId': item.postId
                }),
        _postDeletionAdapter = DeletionAdapter(database, 'Post', ['id'],
            (Post item) => <String, Object?>{'id': item.id, 'text': item.text}),
        _commentDeletionAdapter = DeletionAdapter(
            database,
            'Comment',
            ['id'],
            (Comment item) => <String, Object?>{
                  'id': item.id,
                  'text': item.text,
                  'postId': item.postId
                });

  final sqflite.DatabaseExecutor database;

  final StreamController<String> changeListener;

  final QueryAdapter _queryAdapter;

  final InsertionAdapter<Post> _postInsertionAdapter;

  final InsertionAdapter<Comment> _commentInsertionAdapter;

  final UpdateAdapter<Post> _postUpdateAdapter;

  final UpdateAdapter<Comment> _commentUpdateAdapter;

  final DeletionAdapter<Post> _postDeletionAdapter;

  final DeletionAdapter<Comment> _commentDeletionAdapter;

  @override
  Future<List<Post>> getPosts() async {
    return _queryAdapter.queryList('SELECT * FROM Post',
        mapper: (Map<String, Object?> row) =>
            Post(id: row['id'] as int?, text: row['text'] as String));
  }

  @override
  Future<Post?> findPostById(int id) async {
    return _queryAdapter.query('SELECT * FROM Post WHERE id = ?1',
        mapper: (Map<String, Object?> row) =>
            Post(id: row['id'] as int?, text: row['text'] as String),
        arguments: [id]);
  }

  @override
  Future<List<Comment>> getComments() async {
    return _queryAdapter.queryList('SELECT * FROM Comment',
        mapper: (Map<String, Object?> row) => Comment(
            id: row['id'] as int?,
            text: row['text'] as String,
            postId: row['postId'] as int));
  }

  @override
  Future<Comment?> findCommentById(int id) async {
    return _queryAdapter.query('SELECT * FROM Comment WHERE id = ?1',
        mapper: (Map<String, Object?> row) => Comment(
            id: row['id'] as int?,
            text: row['text'] as String,
            postId: row['postId'] as int),
        arguments: [id]);
  }

  @override
  Future<List<Comment>> findCommentsByPost(int postId) async {
    return _queryAdapter.queryList('SELECT * FROM Comment WHERE postId = ?1',
        mapper: (Map<String, Object?> row) => Comment(
            id: row['id'] as int?,
            text: row['text'] as String,
            postId: row['postId'] as int),
        arguments: [postId]);
  }

  @override
  Future<void> insertPost(Post item) async {
    await _postInsertionAdapter.insert(item, OnConflictStrategy.abort);
  }

  @override
  Future<void> insertPosts(List<Post> items) async {
    await _postInsertionAdapter.insertList(items, OnConflictStrategy.abort);
  }

  @override
  Future<void> insertComment(Comment item) async {
    await _commentInsertionAdapter.insert(item, OnConflictStrategy.abort);
  }

  @override
  Future<void> insertComments(List<Comment> items) async {
    await _commentInsertionAdapter.insertList(items, OnConflictStrategy.abort);
  }

  @override
  Future<void> updatePost(Post item) async {
    await _postUpdateAdapter.update(item, OnConflictStrategy.abort);
  }

  @override
  Future<void> updatePosts(List<Post> items) async {
    await _postUpdateAdapter.updateList(items, OnConflictStrategy.abort);
  }

  @override
  Future<void> updateComment(Comment item) async {
    await _commentUpdateAdapter.update(item, OnConflictStrategy.abort);
  }

  @override
  Future<void> updateComments(List<Comment> items) async {
    await _commentUpdateAdapter.updateList(items, OnConflictStrategy.abort);
  }

  @override
  Future<void> deletePost(Post items) async {
    await _postDeletionAdapter.delete(items);
  }

  @override
  Future<void> deletePosts(List<Post> itemss) async {
    await _postDeletionAdapter.deleteList(itemss);
  }

  @override
  Future<void> deleteComment(Comment items) async {
    await _commentDeletionAdapter.delete(items);
  }

  @override
  Future<void> deleteComments(List<Comment> itemss) async {
    await _commentDeletionAdapter.deleteList(itemss);
  }
}
