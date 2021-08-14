import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:movi/blocs/auth_bloc/auth_event.dart';

class AuthBloc {
  FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  GoogleSignIn _googleSignIn = GoogleSignIn();

  final _authStateController = StreamController<User?>();

  Stream<User?> get authStateChanges => _firebaseAuth.authStateChanges();
  User? get currentUser => _firebaseAuth.currentUser;

  final _authEventController = StreamController<AuthEvent>();
  Sink<AuthEvent> get authEventSink => _authEventController.sink;

  AuthBloc() {
    _authEventController.stream.listen(_mapEventToState);
  }

  void _mapEventToState(AuthEvent event) {
    if (event is SignIn) {
      _handleSignIn();
    } else if (event is SignOut) {
      _handleSignOut();
    }
  }

  Future<void> _handleSignIn() async {
    try {
      GoogleSignInAccount? _googleSignInAccount = await _googleSignIn.signIn();
      if (_googleSignInAccount != null) {
        GoogleSignInAuthentication _googleSignInAuthentication =
            await _googleSignInAccount.authentication;

        AuthCredential _authCredential = GoogleAuthProvider.credential(
            idToken: _googleSignInAuthentication.idToken,
            accessToken: _googleSignInAuthentication.accessToken);

        // Sign into Firebase.
        await _firebaseAuth.signInWithCredential(_authCredential);
      }
    } catch (error) {
      print(error);
    }
  }

  Future<void> _handleSignOut() async {
    // Sign out from both Firebase and Google.
    await _firebaseAuth.signOut();
    await _googleSignIn.signOut();
  }

  void dispose() {
    _authStateController.close();
    _authEventController.close();
  }
}
