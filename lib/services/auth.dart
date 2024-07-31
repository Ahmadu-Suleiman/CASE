import 'package:case_be_heard/models/community_member.dart';
import 'package:case_be_heard/services/databases/member_database.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';

class AuthService extends ChangeNotifier {
  static final FirebaseAuth _auth = FirebaseAuth.instance;

  static CommunityMember? _communityMemberFromFirebaseUser(User? user) {
    return user != null ? CommunityMember(id: user.uid) : null;
  }

  // auth change user stream
  Stream<User?> get communityMember {
    return _auth.authStateChanges();
  }

  static bool isAuthenticated() {
    return (_auth.currentUser != null);
  }

  static Future signInWithEmailAndPassword(
      String email, String password) async {
    try {
      UserCredential result = await _auth.signInWithEmailAndPassword(
          email: email, password: password);
      User? user = result.user;
      return user;
    } catch (error) {
      return null;
    }
  }

  static Future registerWithEmailAndPassword(
      String email, String password) async {
    try {
      UserCredential result = await _auth.createUserWithEmailAndPassword(
          email: email, password: password);
      User? user = result.user;
      await DatabaseMember.updateCommunityMember(
          CommunityMember.login(id: user!.uid, email: user.email!));
      return _communityMemberFromFirebaseUser(user);
    } catch (error) {
      return null;
    }
  }

  static Future signInWithGoogle() async {
    User? user;

    final GoogleSignIn googleSignIn = GoogleSignIn();
    final GoogleSignInAccount? googleSignInAccount =
        await googleSignIn.signIn();

    if (googleSignInAccount != null) {
      final GoogleSignInAuthentication googleSignInAuthentication =
          await googleSignInAccount.authentication;
      final AuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleSignInAuthentication.accessToken,
        idToken: googleSignInAuthentication.idToken,
      );
      final UserCredential userCredential =
          await _auth.signInWithCredential(credential);
      user = userCredential.user;
      await DatabaseMember.updateCommunityMember(CommunityMember.fromGoogle(
          id: user!.uid,
          firstName: user.displayName!,
          email: user.email!,
          phoneNumber: user.phoneNumber!,
          photoUrl: user.photoURL!));
      return _communityMemberFromFirebaseUser(user);
    }

    return null;
  }

  // sign out
  static Future signOut() async {
    try {
      return await _auth.signOut();
    } catch (error) {
      return null;
    }
  }
}
