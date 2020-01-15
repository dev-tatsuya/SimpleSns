import 'package:flutter/material.dart';
import 'package:simple_sns/common_widgets/platform_alert_dialog.dart';
import 'package:simple_sns/services/auth.dart';
import 'package:simple_sns/services/database.dart';

class EditAccountPage extends StatefulWidget {
  const EditAccountPage({
    Key key,
    @required this.database,
    this.user,
  }) : super(key: key);

  final Database database;
  final User user;

  static Future<void> show(
      BuildContext context, {
        Database database,
        User user,
      }) async {
    await Navigator.of(context, rootNavigator: true).push(
      MaterialPageRoute(
        builder: (context) => EditAccountPage(database: database, user: user),
        fullscreenDialog: true,
      ),
    );
  }

  @override
  _EditAccountPageState createState() => _EditAccountPageState();
}

class _EditAccountPageState extends State<EditAccountPage> {
  final _formKey = GlobalKey<FormState>();

  String _name;

  @override
  void initState() {
    super.initState();
    if (widget.user != null) {
      _name = widget.user.displayName;
    }
  }

  bool _validateAndSaveForm() {
    final form = _formKey.currentState;
    if (form.validate()) {
      form.save();
      return true;
    }
    return false;
  }

  Future<void> _submit() async {
    if (_validateAndSaveForm()) {
      try {
        final id = widget.user?.uid;
        final user = User(uid: id, displayName: _name);
        await widget.database.setUser(user);
        Navigator.of(context).pop();
      } catch (e) {
        print(e.toString());
      }
    } else {
      PlatformAlertDialog(
        title: 'Display name is null',
        content: 'Please write something name',
        defaultActionText: 'OK',
      ).show(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 10,
        title: Text("Edit profile"),
        actions: <Widget>[
          FlatButton(
            child: Text("Save", style: TextStyle(fontSize: 18, color: Colors.white),),
            onPressed: _submit, // TODO
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
        decoration: InputDecoration(labelText: 'Display name'),
        initialValue: _name,
        validator: (value) => value.isNotEmpty ? null : 'Name can\'t be empty',
        onSaved: (value) => _name = value,
      ),
    ];
  }
}
