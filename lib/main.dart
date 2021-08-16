import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hive/hive.dart';
import 'package:movi/blocs/auth_bloc/auth_bloc.dart';
import 'package:movi/models/movie.dart';
import 'package:movi/pages/home_page/HomePage.dart';
import 'package:movi/pages/login_page/LoginPage.dart';
import 'package:path_provider/path_provider.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
    statusBarColor: Colors.transparent,
  ));
  await Firebase.initializeApp();

  final appDocumentDir = await getApplicationDocumentsDirectory();
  Hive.init(appDocumentDir.path);
  Hive.registerAdapter(MovieAdapter());

  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final _authBloc = AuthBloc();

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primaryColor: Color(0xFFF6F4E4),
        backgroundColor: Color(0xFFF6F4E4),
      ),
      home: StreamBuilder(
        stream: _authBloc.authStateChanges,
        initialData: _authBloc.currentUser,
        builder: (context, snapshot) {
          if (snapshot.hasData && snapshot.data != null) {
            return HomePage();
          } else {
            return LoginPage();
          }
        },
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();
    _authBloc.dispose();
  }
}

class LandingPage extends StatelessWidget {
  const LandingPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container();
  }
}
