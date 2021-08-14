import 'package:flutter/material.dart';
import 'package:line_icons/line_icons.dart';
import 'package:movi/blocs/auth_bloc/auth_bloc.dart';
import 'package:movi/blocs/auth_bloc/auth_event.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _authBloc = AuthBloc();

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage("assets/movi-logo.png"),
              fit: BoxFit.cover,
            ),
          ),
        ),
        Align(
          alignment: AlignmentDirectional.bottomCenter,
          child: Padding(
            padding: const EdgeInsets.only(bottom: 65.0),
            child: OutlinedButton(
              style: ButtonStyle(
                padding: MaterialStateProperty.all<EdgeInsets>(
                  EdgeInsets.all(20.0),
                ),
                shape: MaterialStateProperty.all(
                  RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                ),
                backgroundColor:
                    MaterialStateProperty.all<Color>(Colors.red.shade400),
              ),
              onPressed: () => _authBloc.authEventSink.add(SignIn()),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    LineIcons.googlePlus,
                    size: 40.0,
                    color: Colors.white,
                  ),
                  SizedBox(width: 10.0),
                  Text(
                    "Sign in with Google",
                    textScaleFactor: 1.6,
                    style: TextStyle(color: Colors.white),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}
