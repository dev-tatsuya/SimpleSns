import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:simple_sns/app/sign_in/email_sign_in_model.dart';
import 'package:simple_sns/services/auth.dart';

class EmailSignInBloc {
  EmailSignInBloc({@required this.auth});

  final AuthBase auth;

  final StreamController<EmailSignInModel> _modelController = StreamController<EmailSignInModel>();
  EmailSignInModel _model = EmailSignInModel();

  Stream<EmailSignInModel> get modelStream => _modelController.stream;

  void dispose() {
    _modelController.close();
  }

  Future<void> submit() async {
    updateWith(submitted: true, isLoading: true);
    try {
      if (_model.formType == EmailSignInFromType.signIn) {
        await auth.signInWithEmailAndPassword(_model.email, _model.password);
      } else {
        await auth.createUserWithEmailAndPassword(_model.email, _model.password);
      }
    } catch (e) {
      updateWith(isLoading: false);
      rethrow;
    }
  }

  void updateEmail(String email) => updateWith(email: email);

  void updatePassword(String password) => updateWith(password: password);

  void toggleFromType() {
    final formType = _model.formType == EmailSignInFromType.signIn
        ? EmailSignInFromType.register
        : EmailSignInFromType.signIn;
    updateWith(
      email: "",
      password: "",
      formType: formType,
      isLoading: false,
      submitted: false,
    );
  }

  void updateWith({
    String email,
    String password,
    EmailSignInFromType formType,
    bool isLoading,
    bool submitted,
  }) {
    _model = _model.copyWith(
      email: email,
      password: password,
      formType: formType,
      isLoading: isLoading,
      submitted: submitted,
    );

    _modelController.add(_model);
  }
}
