import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:simple_sns/app/main/models/post.dart';
import 'package:simple_sns/services/database.dart';

class PostDetailPage extends StatefulWidget {
  const PostDetailPage({
    Key key,
    @required this.database,
    this.post,
  }) : super(key: key);

  final Database database;
  final Post post;

  static Future<void> show(
    BuildContext context, {
    Database database,
    Post post,
  }) async {
    await Navigator.of(context, rootNavigator: true).push(
      MaterialPageRoute(
        builder: (context) => PostDetailPage(database: database, post: post),
        fullscreenDialog: false,
      ),
    );
  }

  @override
  _PostDetailPageState createState() => _PostDetailPageState();
}

class _PostDetailPageState extends State<PostDetailPage> {
  final _formKey = GlobalKey<FormState>();

  String _name;

  @override
  void initState() {
    super.initState();
    if (widget.post != null) {
      _name = widget.post.title;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 5,
        title: Text("post"),
      ),
      body: _buildContents(),
      backgroundColor: Colors.grey[200],
    );
  }

  Widget _buildContents() {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Card(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: _buildForm(),
          ),
        ),
      ),
    );
  }

  Widget _buildForm() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: _buildFormChildren(),
    );
  }

  List<Widget> _buildFormChildren() {
    return [
      Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          FlatButton(
            onPressed: () {},
            child: Text(
              "Tatsuya",
              style: TextStyle(fontSize: 20),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
          IconButton(
            icon: Icon(Icons.more_vert),
            onPressed: () {},
          ),
        ],
      ),
      Divider(),
      Text(
        widget.post.title,
        style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
      ),
      SizedBox(height: 20),
      Text(
        widget.post.body,
        style: TextStyle(fontSize: 20),
      ),
      SizedBox(height: 20),
      Text("created at: ${widget.post.id}"), // TODO フォーマット修正
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
