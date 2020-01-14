import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:simple_sns/app/sign_in/email_sign_in_model.dart';
import 'package:simple_sns/services/auth.dart';

class EmailSignInBloc {
  EmailSignInBloc({@required this.auth, @required this.formType});

  final AuthBase auth;
  EmailSignInFormType formType;

  final StreamController<EmailSignInModel> _modelController = StreamController<EmailSignInModel>();
  EmailSignInModel _model = EmailSignInModel();

  Stream<EmailSignInModel> get modelStream => _modelController.stream;

  void dispose() {
    _modelController.close();
  }

  Future<void> submit() async {
    updateWith(submitted: true, isLoading: true);
    try {
      if (_model.formType == EmailSignInFormType.signIn) {
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
    final retType = formType == EmailSignInFormType.signIn
        ? EmailSignInFormType.register
        : EmailSignInFormType.signIn;
    updateWith(
      email: "",
      password: "",
      emailSignInFormType: retType,
      isLoading: false,
      submitted: false,
    );
    formType = retType;
  }

  void updateWith({
    String email,
    String password,
    EmailSignInFormType emailSignInFormType,
    bool isLoading,
    bool submitted,
  }) {
    _model = _model.copyWith(
      email: email,
      password: password,
      formType: emailSignInFormType ?? formType,
      isLoading: isLoading,
      submitted: submitted,
    );

    _modelController.add(_model);
  }
}
