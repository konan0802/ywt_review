import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:flutter_signin_button/flutter_signin_button.dart';
import 'package:ywt_review/LogoutPage.dart';

class LoginPage extends StatelessWidget {
  static final googleLogin = GoogleSignIn(scopes: [
    'email',
    'https://www.googleapis.com/auth/contacts.readonly',
  ]);

  const LoginPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SignInButton(
              Buttons.Google,
              onPressed: () async {
                GoogleSignInAccount? signinAccount = await googleLogin.signIn();
                if (signinAccount == null) return;
                GoogleSignInAuthentication auth =
                    await signinAccount.authentication;
                final OAuthCredential credential =
                    GoogleAuthProvider.credential(
                  idToken: auth.idToken,
                  accessToken: auth.accessToken,
                );
                User? user = (await FirebaseAuth.instance
                        .signInWithCredential(credential))
                    .user;
                if (user != null) {
                  // ignore: use_build_context_synchronously
                  await Navigator.of(context).pushReplacement(
                    MaterialPageRoute(builder: (context) {
                      return LogoutPage(user);
                    }),
                  );
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}
