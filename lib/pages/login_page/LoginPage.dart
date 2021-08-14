import 'package:flutter/material.dart';
import 'package:movi/blocs/auth_bloc/auth_bloc.dart';
import 'package:movi/blocs/auth_bloc/auth_event.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _bloc = AuthBloc();

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Center(
        child: TextButton(
          onPressed: () => _bloc.authEventSink.add(SignIn()),
          child: Text("Sign In"),
        ),
      ),
    );
  }
}
