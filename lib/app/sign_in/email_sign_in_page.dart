import 'package:flutter/material.dart';
import 'package:simple_sns/app/sign_in/email_sign_in_form_bloc_based.dart';
import 'package:simple_sns/app/sign_in/email_sign_in_model.dart';

class EmailSignInPage extends StatelessWidget {

  const EmailSignInPage({Key key, @required this.formType}) : super(key: key);

  final EmailSignInFormType formType;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Welcome"),
        elevation: 10.0,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Card(
            child: EmailSignInFormBlocBased.create(context, formType),
          ),
        ),
      ),
      backgroundColor: Colors.grey[200],
    );
  }
}
