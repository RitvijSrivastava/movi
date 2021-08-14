import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:movi/blocs/auth_bloc/auth_bloc.dart';
import 'package:movi/models/movie.dart';
import 'package:movi/pages/home_page/HomePage.dart';
import 'package:movi/pages/login_page/LoginPage.dart';
import 'package:movi/utils/Loading.dart';
import 'package:path_provider/path_provider.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final _authBloc = AuthBloc();

  initHive() async {
    final appDocsDir = await getApplicationDocumentsDirectory();
    Hive.init(appDocsDir.path);
    Hive.registerAdapter(MovieAdapter());
  }

  @override
  void initState() {
    initHive();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: Scaffold(
        body: SafeArea(
          child: StreamBuilder(
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
        ),
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
