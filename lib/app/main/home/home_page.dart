import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:simple_sns/app/main/add/post_detail_page.dart';
import 'package:simple_sns/app/main/models/post.dart';
import 'package:simple_sns/app/main/post_list_tile.dart';
import 'package:simple_sns/common_widgets/list_items_builder.dart';
import 'package:simple_sns/common_widgets/platform_alert_dialog.dart';
import 'package:simple_sns/common_widgets/platform_exception_alert_dialog.dart';
import 'package:simple_sns/services/database.dart';
import 'package:flutter/services.dart';

class HomePage extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Home"),
      ),
      body: _buildContents(context),
    );
  }

  Widget _buildContents(BuildContext context) {
    final database = Provider.of<Database>(context);
    return StreamBuilder<List<Post>>(
        stream: database.allPostsStream(),
        builder: (context, snapshot) {
          return ListItemsBuilder<Post>(
            snapshot: snapshot,
            itemBuilder: (context, post) =>
                Dismissible(
                  key: Key('post-${post.id}'),
                  background: Container(color: Colors.red),
                  direction: DismissDirection.endToStart,
                  confirmDismiss: (_) => _confirmDelete(context, post),
                  child: PostListTile(
                    post: post,
                    onTap: () => PostDetailPage.show(context, post: post),
                  ),
                ),
          );
        }
    );
  }

  Future<bool> _confirmDelete(BuildContext context, Post post) async {
    final didRequestDeletePost = await PlatformAlertDialog(
      title: 'Delete this post',
      content: 'Are you sure that you want to delete this post?',
      cancelActionText: 'Cancel',
      defaultActionText: 'Delete',
    ).show(context);
    if(didRequestDeletePost == true) {
      _delete(context, post);
      return true;
    }
    return false;
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
