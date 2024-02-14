import 'package:flutter/material.dart';
import 'dao.dart';
import 'database.dart';
import 'model.dart';
import 'widgets.dart';

void main() {
  runApp(const MyApp());
}

late final PostDao _dao;

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Posts and Comments',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSwatch(
            primarySwatch: Colors.blue, backgroundColor: Colors.white70),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'Posts and Comments'),
      debugShowCheckedModeBanner: false,
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final TextEditingController _textFieldController = TextEditingController();
  final List<Post> _posts = <Post>[];
  final List<Comment> _comments = <Comment>[];

  @override
  initState() {
    super.initState();
    _getDao();
  }

  Future<void> _getDao() async {
    AppDatabase database =
        await $FloorAppDatabase.databaseBuilder('app_database.db').build();
    _dao = database.postDao;
    _updatePosts();
  }

  _updatePosts() {
    _dao.getPosts().then((posts) {
      setState(() {
        _posts.clear();
        _posts.addAll(posts);
      });
    });
  }

  Future<List<Comment>> _getPostComments(Post post) {
    List<Comment> c = [];
    if (post.id != null) {
      return _dao.findCommentsByPost((post.id)!).then((comments) {
        if (comments != null) {
          c.addAll(comments);
        }
        return c;
      });
    } else {
      return Future.delayed(Duration.zero).then((value) => c);
    }
  }

  _handlePostDelete(Post post) {
    setState(() {
      _posts.remove(post);
    });
    _dao.deletePost(post);
  }

  _handleCommentDelete(Comment comment) {
    _dao.deleteComment(comment).then((value) => setState(
          () {},
        ));
  }

  Future<void> _displayDialogPost() async {
    return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('add a post'),
          content: TextField(
            controller: _textFieldController,
            decoration: const InputDecoration(hintText: 'type here ...'),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('Add'),
              onPressed: () {
                Navigator.of(context).pop();
                _addPost(_textFieldController.text);
              },
            ),
          ],
        );
      },
    );
  }

  Future<void> _displayDialogComment(PostWidget post) async {
    return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('add a comment'),
          content: TextField(
            controller: _textFieldController,
            decoration: const InputDecoration(hintText: 'type here ...'),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('Add'),
              onPressed: () {
                Navigator.of(context).pop();
                _addComment(_textFieldController.text, post);
              },
            ),
          ],
        );
      },
    );
  }

  Future<void> _displayDialogEditPost(PostWidget post) async {
    _textFieldController.text = post.post.text;
    return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('edit post'),
          content: TextField(
            controller: _textFieldController,
            decoration: const InputDecoration(hintText: 'type here ...'),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('Edit'),
              onPressed: () {
                Navigator.of(context).pop();
                _editPost(_textFieldController.text, post.post);
              },
            ),
          ],
        );
      },
    );
  }

  Future<void> _displayDialogEditComment(CommentWidget comment) async {
    _textFieldController.text = comment.comment.text;
    return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('edit comment'),
          content: TextField(
            controller: _textFieldController,
            decoration: const InputDecoration(hintText: 'type here ...'),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('Edit'),
              onPressed: () {
                Navigator.of(context).pop();
                _editComment(_textFieldController.text, comment.comment);
              },
            ),
          ],
        );
      },
    );
  }

  void _addPost(String text) {
    Post post = Post(id: null, text: text);
    setState(() {
      _posts.insert(0, post);
    });
    _dao.insertPost(post).then((value) => _updatePosts());
    _textFieldController.clear();
  }

  void _addComment(String text, PostWidget post) {
    Comment comment = Comment(id: null, text: text, postId: post.post.id!);
    setState(() {
      post.appendComment(comment);
    });
    _dao.insertComment(comment);
    _textFieldController.clear();
  }

  void _editPost(String text, Post post) {
    post.text = text;
    _dao.updatePost(post).then((value) => _updatePosts());
    _textFieldController.clear();
  }

  void _editComment(String text, Comment comment) {
    comment.text = text;
    _dao.updateComment(comment).then((value) => _updatePosts());
    _textFieldController.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title, style: const TextStyle(color: Colors.white),),
        backgroundColor: Theme.of(context).primaryColor,
      ),
      body: Center(
        child: ListView.builder(
            padding: const EdgeInsets.symmetric(vertical: 8.0),
            itemCount: _posts.length,
            itemBuilder: (context, index) {
              return FutureBuilder<List<Comment>>(
                future: _getPostComments(_posts[index]),
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    return PostWidget(
                      post: _posts[index],
                      onPostDelete: _handlePostDelete,
                      addComment: _displayDialogComment,
                      removeComment: _handleCommentDelete,
                      updateComment: _displayDialogEditComment,
                      onPostUpdate: _displayDialogEditPost,
                      comments: snapshot.data!,
                    );
                  }
                  return const ListTile(
                    title: Text("loading..."),
                  );
                },
              );
            }),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _displayDialogPost(),
        tooltip: 'Add Post',
        child: const Icon(Icons.add),
      ),
    );
  }

  @override
  void dispose() {
    _textFieldController.dispose();
    super.dispose();
  }
}
