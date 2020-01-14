import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:simple_sns/app/main/models/post.dart';
import 'package:simple_sns/common_widgets/platform_alert_dialog.dart';
import 'package:simple_sns/services/auth.dart';
import 'package:simple_sns/services/database.dart';

class AddPage extends StatefulWidget {

  @override
  _AddPageState createState() => _AddPageState();
}

class _AddPageState extends State<AddPage> {
  final _formKey = GlobalKey<FormState>();

  String _title;
  String _body;

  bool _validateAndSaveForm() {
    final form = _formKey.currentState;
    if (form.validate()) {
      form.save();
      return true;
    }
    return false;
  }

  Future<void> _submit(Database database) async {
    if (_validateAndSaveForm()) {
      final id = documentIdFromCurrentDate();
      final post = Post(id: id, title: _title, body: _body);
      await database.setPost(post);
    } else {
      PlatformAlertDialog(
        title: 'Title or Body is null',
        content: 'Please write something',
        defaultActionText: 'OK',
      ).show(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    final database = Provider.of<Database>(context);
    return Scaffold(
      appBar: AppBar(
        elevation: 5,
        title: Text("Add post"),
        actions: <Widget>[
          FlatButton(
            child: Text("Submit", style: TextStyle(fontSize: 18, color: Colors.white),),
            onPressed: () => _submit(database),
          )
        ],
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
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: _buildFormChildren(),
      ),
    );
  }

  List<Widget> _buildFormChildren() {
    return [
      TextFormField(
        decoration: InputDecoration(labelText: 'Title'),
        initialValue: _title,
        validator: (value) => value.isNotEmpty ? null : 'Title can\'t be empty',
        onSaved: (value) => _title = value,
      ),
      SizedBox(height: 8,),
      TextFormField(
        maxLines: 6,
        decoration: InputDecoration(labelText: 'Body'),
        initialValue: _body,
        validator: (value) => value.isNotEmpty ? null : 'Body can\'t be empty',
        onSaved: (value) => _body = value,
      ),
    ];
  }
}
