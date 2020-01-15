import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:simple_sns/app/main/add/edit_post_page.dart';
import 'package:simple_sns/app/main/models/post.dart';
import 'package:simple_sns/services/database.dart';

class PostDetailPage extends StatelessWidget {
  const PostDetailPage({
    Key key,
    @required this.database,
    this.post,
  }) : super(key: key);

  final Database database;
  final Post post;

  static Future<void> show(
    BuildContext context, {
    Post post,
  }) async {
    final Database database = Provider.of<Database>(context, listen: false);
    await Navigator.of(context).push(
      CupertinoPageRoute(
        builder: (context) => PostDetailPage(database: database, post: post),
        fullscreenDialog: false,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 5,
        title: Text("post"),
      ),
      body: _buildContents(context),
      backgroundColor: Colors.grey[200],
    );
  }

  Widget _buildContents(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Card(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: _buildForm(context),
          ),
        ),
      ),
    );
  }

  Widget _buildForm(BuildContext context) {
    return StreamBuilder<Post>(
      stream: database.postStream(postId: post.id),
      builder: (context, snapshot) {
        final post = snapshot.data;
        return Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: _buildFormChildren(context, post),
        );
      }
    );
  }

  List<Widget> _buildFormChildren(BuildContext context, Post post) {
    final _optionItems = ["編集", "削除"];
    return [
      Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          FlatButton(
            onPressed: () {},
            child: Text(
              "＠鬼滅の炭治郎",
              style: TextStyle(fontSize: 20),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
          PopupMenuButton(
            itemBuilder: (context) => _optionItems
                .map(
                  (item) => PopupMenuItem(
                    child: Text(item),
                    value: item,
                  ),
                )
                .toList(),
            onSelected: (item) {
              if (item == "編集") {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => EditPostPage(database: database, post: post),
                    fullscreenDialog: true,
                  )
                );
              } else {
                // TODO アラートダイアログを表示して削除する
                print("アラートダイアログを表示して削除する");
              }
            },
          ),
        ],
      ),
      Divider(),
      Text(
        post?.title ?? "",
        style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
      ),
      SizedBox(height: 20),
      Text(
        post?.body ?? "",
        style: TextStyle(fontSize: 20),
      ),
      SizedBox(height: 20),
      Text("created at: ${post?.id}"),
      Divider(),
      Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: <Widget>[
          IconButton(
            icon: Icon(Icons.message),
            onPressed: () {},
          ),
          IconButton(
            icon: Icon(Icons.repeat),
            onPressed: () {},
          ),
          IconButton(
            icon: Icon(Icons.star),
            onPressed: () {},
          ),
          IconButton(
            icon: Icon(Icons.share),
            onPressed: () {},
          ),
        ],
      ),
      Divider(),
    ];
  }
}
