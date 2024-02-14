import 'package:flutter/material.dart';

import 'model.dart';


class PostWidget extends StatelessWidget {
  PostWidget(
      {required this.post,
      required this.addComment,
      required this.removeComment,
      required this.updateComment,
      required this.onPostDelete,
      required this.onPostUpdate,
      required this.comments,})
      : super(key: ObjectKey(post));

  final Post post;
  final Function addComment;
  final Function removeComment;
  final Function updateComment;
  final Function onPostDelete;
  final Function onPostUpdate;
  final List<Comment> comments;

  final TextStyle _textStyle = const TextStyle(
    color: Colors.black45,
  );

  @override
  Widget build(BuildContext context) {
    List<Widget> widgets = [];
    for (Comment comment in comments) {
      widgets.add(CommentWidget(
        comment: comment,
        onCommentDelete: removeComment,
        onCommentUpdate: updateComment,
      ));
    }
    if (widgets.isEmpty) {
      widgets.add(const Text("no comments",selectionColor: Color.fromARGB(66, 101, 101, 101),));
    }
    widgets.add(TextButton(
        onPressed: () => addComment(this), child: const Text("Add comment")));
    widgets.add(TextButton(
        onPressed: () => onPostDelete(post), child: const Text("Remove post")));
    return ExpansionTile(
      leading: CircleAvatar(child: Text(post.text[0])),
      title: Text(post.text, style: _textStyle),
      trailing: IconButton(onPressed: (){onPostUpdate(this);}, icon: const Icon(Icons.edit), color: Theme.of(context).primaryColor,),
      children: widgets,
    );
  }

  appendComment(Comment comment) {
    comments.insert(0, comment);
  }
}

class CommentWidget extends StatelessWidget {
  CommentWidget({
    required this.comment,
    required this.onCommentDelete,
    required this.onCommentUpdate,
  }) : super(key: ObjectKey(comment));

  final Comment comment;
  final Function onCommentDelete;
  final Function onCommentUpdate;

  final TextStyle _textStyle = const TextStyle(
    color: Colors.black45,
  );

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onLongPress: ()=>onCommentUpdate(this),
      trailing: IconButton(onPressed: ()=>onCommentDelete(comment), icon: const Icon(Icons.delete), color: Theme.of(context).primaryColor),
      leading: CircleAvatar(backgroundColor: const Color.fromARGB(255, 17, 56, 83), child: Text("-", style: TextStyle(fontSize: 27, color: Theme.of(context).primaryColor)),),
      title: Text(comment.text, style: _textStyle),
      tileColor: Color.fromARGB(255, 17, 56, 83),
    );
  }
}
