import 'package:flutter/material.dart';
import 'package:simple_sns/app/main/models/post.dart';

class PostListTile extends StatelessWidget {
  const PostListTile({Key key, @required this.post, this.onTap}) : super(key: key);
  final Post post;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(post.title),
      subtitle: Text(post.body),
      trailing: Icon(Icons.chevron_right),
      onTap: onTap,
    );
  }
}