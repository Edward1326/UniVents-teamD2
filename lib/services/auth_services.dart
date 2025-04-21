import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

class AuthServices {
  signInWithGoogle() async {
    final googleSignIn = GoogleSignIn();

    // 🔁 This clears the previously cached account
    await googleSignIn.signOut();

    // 📲 This will now show the account picker again
    final GoogleSignInAccount? gUser = await googleSignIn.signIn();

    if (gUser == null) {
      throw Exception("Google Sign-In was cancelled");
    }

    final GoogleSignInAuthentication gAuth = await gUser.authentication;

    final credential = GoogleAuthProvider.credential(
      accessToken: gAuth.accessToken,
      idToken: gAuth.idToken,
    );

    return await FirebaseAuth.instance.signInWithCredential(credential);
  }
}
