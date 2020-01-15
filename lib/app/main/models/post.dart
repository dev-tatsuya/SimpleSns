
import 'package:flutter/foundation.dart';

class Post {
  Post({@required this.id, @required this.title, @required this.body});
  final String id;
  final String title;
  final String body;

  factory Post.fromMap(Map<String, dynamic> data, String documentId) {
    if (data == null) {
      return null;
    }
    final String title = data['title'];
    final String body = data['body'];
    return Post(
        id: documentId,
        title: title,
        body: body
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'body': body,
    };
  }

}