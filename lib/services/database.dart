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

  Stream<List<Post>> allPostsStream();
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
  Future<void> deletePost(Post post) async {
    await _service.deleteData(path: APIPath.post(uid, post.id));
  }

  @override
  Stream<Post> postStream({String postId}) => _service.documentStream(
        path: APIPath.post(uid, postId),
        builder: (data, documentId) => Post.fromMap(data, documentId),
      );

  @override
  Stream<List<Post>> postsStream() => _service.collectionStream(
        path: APIPath.posts(uid),
        builder: (data, documentId) => Post.fromMap(data, documentId),
      );

  @override
  Future<void> setPost(Post post) async => await _service.setData(
        path: APIPath.post(uid, post.id),
        data: post.toMap(),
      );

  @override
  Stream<List<Post>> allPostsStream() => _service.collectionStream(
        path: APIPath.allPosts(),
        builder: (data, documentId) => Post.fromMap(data, documentId),
      );
}
