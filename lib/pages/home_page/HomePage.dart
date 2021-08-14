import 'package:flutter/material.dart';
import 'package:movi/blocs/auth_bloc/auth_bloc.dart';
import 'package:movi/blocs/auth_bloc/auth_event.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final _authBloc = AuthBloc();

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Center(
        child: TextButton(
          onPressed: () => _authBloc.authEventSink.add(SignOut()),
          child: Text("Sign Out - Home Page"),
        ),
      ),
    );
  }
}
