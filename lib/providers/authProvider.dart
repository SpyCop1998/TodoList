
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:todo_app/providers/splashProvider.dart';

class AuthProvider with ChangeNotifier {
  final GoogleSignIn _googleSignIn = GoogleSignIn();
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _fireStore = FirebaseFirestore.instance;

  User? _user;

  User? get user => _user;

  String? _token;
  String? get token => _token;

  String? _userName;
  String? get userName => _userName;

  String? _email;
  String? get email => _email;


  Future<bool> isSignedIn() async {
    final sharedPreferences = await SharedPreferences.getInstance();

    final email = sharedPreferences.getString('googleSignInEmail');

    _token=sharedPreferences.getString("secretToken");
    _userName=sharedPreferences.getString("userName");
    _email=sharedPreferences.getString("googleSignInEmail");


    return email != null;
  }



  Future<void> signInWithGoogle() async {
    final sharedPreferences = await SharedPreferences.getInstance();
    final bool isSigned=await isSignedIn();
    if (isSigned) {

      _token=sharedPreferences.getString("secretToken");
      _userName=sharedPreferences.getString("userName");
      _email=sharedPreferences.getString("googleSignInEmail");
      SplashProvider splashProvider=new SplashProvider();
      await splashProvider.getUser;
      notifyListeners();

    } else {
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
      final GoogleSignInAuthentication googleAuth =
      await googleUser!.authentication;
      final AuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );
      final UserCredential authResult = await _auth.signInWithCredential(credential);

      _user = authResult.user;
      _token= user!.uid;
      _userName= user!.displayName;
      _email= user!.email;

      sharedPreferences.setString("secretToken", user!.uid);
      sharedPreferences.setString("userName", user!.displayName.toString());
      sharedPreferences.setString("googleSignInEmail", user!.email.toString());
      await _fireStore.collection("User").doc(user!.uid).set(
        {
          "email": user!.email,
        },
      );
      notifyListeners();
    }
  }

  Future<void> signOut() async {
    await _auth.signOut();
    await _googleSignIn.signOut();

    _user = null;
    _token= null;
    _userName= null;
    _email= null;

    final sharedPreferences = await SharedPreferences.getInstance();
    sharedPreferences.remove('googleSignInEmail');
    sharedPreferences.remove('secretToken');
    sharedPreferences.remove('userName');
    notifyListeners();
  }
}
