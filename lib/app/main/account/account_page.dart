import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:simple_sns/app/main/account/edit_account_page.dart';
import 'package:simple_sns/app/main/models/post.dart';
import 'package:simple_sns/app/main/post_list_tile.dart';
import 'package:simple_sns/common_widgets/avatar.dart';
import 'package:simple_sns/common_widgets/list_items_builder.dart';
import 'package:simple_sns/common_widgets/platform_alert_dialog.dart';
import 'package:simple_sns/common_widgets/platform_exception_alert_dialog.dart';
import 'package:simple_sns/services/auth.dart';
import 'package:simple_sns/services/database.dart';
import 'package:flutter/services.dart';

class AccountPage extends StatelessWidget {
  Future<void> _signOut(BuildContext context) async {
    try {
      final auth = Provider.of<AuthBase>(context, listen: false);
      await auth.signOut();
    } catch (e) {
      print(e.toString());
    }
  }

  Future<void> _confirmSignOut(BuildContext context) async {
    final didRequestSignOut = await PlatformAlertDialog(
      title: 'Logout',
      content: 'Are you sure that you want to logout?',
      cancelActionText: 'Cancel',
      defaultActionText: 'Logout',
    ).show(context);
    if (didRequestSignOut == true) {
      _signOut(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    final database = Provider.of<Database>(context);
    return StreamBuilder<User>(
      stream: database.userStream(),
      builder: (context, snapshot) {
        final user = snapshot.data;
        return Scaffold(
          appBar: AppBar(
            title: Text(user?.displayName ?? "Account"),
            leading: IconButton(
              icon: Icon(Icons.edit),
              onPressed: () => EditAccountPage.show(
                context,
                database: database,
                user: user,
              ),
            ),
            actions: <Widget>[
              FlatButton(
                child: Text(
                  'Logout',
                  style: TextStyle(
                    fontSize: 18.0,
                    color: Colors.white,
                  ),
                ),
                onPressed: () => _confirmSignOut(context),
              ),
            ],
            bottom: PreferredSize(
              preferredSize: Size.fromHeight(130),
              child: _buildUserInfo(user),
            ),
          ),
          body: _buildContents(context),
        );
      }
    );
  }

  Widget _buildUserInfo(User user) {
    return Column(
      children: <Widget>[
        Avatar(
          photoUrl: null,
          radius: 50,
        ),
        SizedBox(height: 8),
        if (user?.displayName == null)
          Text(
            "左上の編集アイコンからDisplayNameを設定してください",
            style: TextStyle(fontSize: 14, color: Colors.white),
          ),
        SizedBox(height: 8),
      ],
    );
  }

  Widget _buildContents(BuildContext context) {
    final database = Provider.of<Database>(context);
    return StreamBuilder<List<Post>>(
      stream: database.postsStream(),
      builder: (context, snapshot) {
        return ListItemsBuilder<Post>(
          snapshot: snapshot,
          itemBuilder: (context, post) => Dismissible(
            key: Key('post-${post.id}'),
            background: Container(color: Colors.red),
            direction: DismissDirection.endToStart,
            onDismissed: (direction) => _delete(context, post),
            child: PostListTile(
              post: post,
              onTap: () => () {}, //JobEntriesPage.show(context, job),
            ),
          ),
        );
      }
    );
  }

  Future<void> _delete(BuildContext context, Post post) async {
    try {
      final database = Provider.of<Database>(context, listen: false);
      await database.deletePost(post);
    } on PlatformException catch (e) {
      PlatformExceptionAlertDialog(
        title: 'Operation failed',
        exception: e,
      ).show(context);
    }
  }
}
