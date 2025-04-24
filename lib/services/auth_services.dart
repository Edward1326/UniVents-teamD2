import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

class AuthServices {
  final googleSignIn = GoogleSignIn();

  Future<User?> signInWithGoogle() async {
    await googleSignIn.signOut();

    final GoogleSignInAccount? gUser = await googleSignIn.signIn();
    if (gUser == null) throw Exception("Google Sign-In was cancelled");

    final GoogleSignInAuthentication gAuth = await gUser.authentication;

    final credential = GoogleAuthProvider.credential(
      accessToken: gAuth.accessToken,
      idToken: gAuth.idToken,
    );

    final userCredential = await FirebaseAuth.instance.signInWithCredential(
      credential,
    );

    final email = userCredential.user?.email ?? '';

    if (!email.endsWith('@addu.edu.ph')) {
      await FirebaseAuth.instance.signOut();
      await googleSignIn.signOut();
      throw Exception("Only @addu.edu.ph emails are allowed.");
    }

    return userCredential.user;
  }
}
