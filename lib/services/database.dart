import 'dart:async';

import 'package:meta/meta.dart';
import 'package:simple_sns/app/main/models/post.dart';
import 'package:simple_sns/services/api_path.dart';
import 'package:simple_sns/services/auth.dart';
import 'package:simple_sns/services/firestore_service.dart';

abstract class Database {
  Future<void> setUser(User user);

  Future<void> deleteUser(User user);

  Stream<User> userStream();

  Future<void> setPost(Post post);

  Future<void> deletePost(Post post);

  Stream<Post> postStream({@required String postId});

  Stream<List<Post>> postsStream();
}

String documentIdFromCurrentDate() => DateTime.now().toIso8601String();

class FirestoreDatabase implements Database {
  FirestoreDatabase({@required this.uid}) : assert(uid != null);
  final String uid;

  final _service = FirestoreService.instance;

  @override
  Future<void> deleteUser(User user) {
    // TODO: implement deleteUser
    return null;
  }

  @override
  Future<void> setUser(User user) async => await _service.setData(
        path: APIPath.user(uid),
        data: user.toMap(),
      );

  @override
  Stream<User> userStream() => _service.documentStream(
        path: APIPath.user(uid),
        builder: (data, _) => User.fromMap(data, uid),
      );

  @override
  Future<void> deletePost(Post post) {
    // TODO: implement deletePost
    return null;
  }

  @override
  Stream<Post> postStream({String postId}) {
    // TODO: implement postStream
    return null;
  }

  @override
  Stream<List<Post>> postsStream() {
    // TODO: implement postsStream
    return null;
  }

  @override
  Future<void> setPost(Post post) async => await _service.setData(
        path: APIPath.post(uid, post.id),
        data: post.toMap(),
      );
}
