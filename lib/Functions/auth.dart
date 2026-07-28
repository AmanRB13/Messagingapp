import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:google_sign_in/google_sign_in.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // ---------------- SIGN UP ----------------
Future<UserCredential> signup(
    String email,
    String password,
    String username,
) async {
    try {
      UserCredential userCredential =
          await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      await _firestore.collection('users').doc(userCredential.user!.uid).set({
        'email': email,
        'uid': userCredential.user!.uid,
        'createdAt': FieldValue.serverTimestamp(),
      });

      return userCredential;
    } on FirebaseAuthException catch (e) {
      throw e.message ?? 'Signup failed';
    }
  }

  // ---------------- SIGN IN ----------------
  Future<UserCredential> signin(String email, String password) async {
    try {
      return await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
    } on FirebaseAuthException catch (e) {
      throw e.message ?? 'Login failed';
    }
  }

  // ---------------- GOOGLE SIGN IN ----------------
  Future<bool> signInWithGoogle() async {
    try {
      if (kIsWeb) {
        // WEB - Keep your existing web code
        GoogleAuthProvider googleProvider = GoogleAuthProvider();
        googleProvider.setCustomParameters({'prompt': 'select_account'});

        await _auth.signInWithPopup(googleProvider);

        final user = _auth.currentUser;

        if (user != null) {
          await _firestore.collection('users').doc(user.uid).set({
            'email': user.email,
            'uid': user.uid,
            'createdAt': FieldValue.serverTimestamp(),
          }, SetOptions(merge: true));
        }

        print('/////// Google Sign-In Success (Web) ////////');
        return true;
      } else {
        // MOBILE - Updated for google_sign_in 7.2.0
        final GoogleSignIn googleSignIn = GoogleSignIn(
          clientId: null, // Use null for mobile, it will use the default
          scopes: <String>[
            'email',
            'https://www.googleapis.com/auth/userinfo.profile',
          ],
        );

        // Try to sign out first to clear any cached credentials
        await googleSignIn.signOut();

        // Use signIn() - this is the correct method for version 7.2.0
        final GoogleSignInAccount? googleUser = await googleSignIn.signIn();

        if (googleUser == null) {
          print('User cancelled the Google Sign-In');
          return false;
        }

        final GoogleSignInAuthentication googleAuth =
            await googleUser.authentication;

        // Debug print
        print('ID Token: ${googleAuth.idToken != null ? "Exists" : "NULL"}');
        print(
            'Access Token: ${googleAuth.accessToken != null ? "Exists" : "NULL"}');

        if (googleAuth.idToken == null) {
          print('ID Token is null, authentication failed');
          return false;
        }

        final credential = GoogleAuthProvider.credential(
          accessToken: googleAuth.accessToken,
          idToken: googleAuth.idToken,
        );

        final UserCredential userCredential =
            await _auth.signInWithCredential(credential);

        final user = userCredential.user;

        if (user != null) {
          await _firestore.collection('users').doc(user.uid).set({
            'email': user.email,
            'uid': user.uid,
            'displayName': user.displayName,
            'photoURL': user.photoURL,
            'createdAt': FieldValue.serverTimestamp(),
          }, SetOptions(merge: true));

          print('/////// Google Sign-In Success (Mobile) ////////');
          print('User Email: ${user.email}');
          print('User UID: ${user.uid}');
          return true;
        }

        return false;
      }
    } catch (e, stackTrace) {
      print('Google Sign-In Error: $e');
      print('Stack Trace: $stackTrace');

      // More detailed error handling
      if (e is FirebaseAuthException) {
        print('Firebase Auth Error Code: ${e.code}');
        print('Firebase Auth Error Message: ${e.message}');
      }

      return false;
    }
  }

  // ---------------- SIGN OUT ----------------
  Future<void> signOut() async {
    try {
      // Sign out from Firebase
      await _auth.signOut();

      // Sign out from Google (only for mobile)
      if (!kIsWeb) {
        // For google_sign_in 6.2.2, you need to create an instance first
        final GoogleSignIn googleSignIn = GoogleSignIn();
        await googleSignIn.signOut();

        // Optional: Also disconnect to fully revoke access
        await googleSignIn.disconnect();
      }

      print('/////// Signed Out ////////');
    } catch (e) {
      print('Error during sign out: $e');
      // Don't throw, just log the error
    }
  }
}
