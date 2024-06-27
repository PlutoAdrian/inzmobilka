import 'dart:async';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:pluto_apk/models/user.dart';
import 'package:pluto_apk/services/database.dart';

class AuthService {

  final FirebaseAuth _auth = FirebaseAuth.instance;
  //create user
  UserUID? _userFromFirebaseUser(User? user){
    return user != null ? UserUID(uid: user.uid) : null;
  }
  //auth stream
  Stream<UserUID?> get user {
    return _auth.authStateChanges().map((User? user) => _userFromFirebaseUser(user));
  }
  //sign in
  Future signInWithEmail(String email, String password) async {
    try{
      UserCredential result = await _auth.signInWithEmailAndPassword(email: email, password: password);
      User? user = result.user;
      return _userFromFirebaseUser(user);
    }catch(e){
      print(e.toString());
      return null;
    }
  }


  //register
  Future registerWithEmail(String email, String password) async {
    try{
      UserCredential result = await _auth.createUserWithEmailAndPassword(email: email, password: password);
      User? user = result.user;

      //create a doc
      await DatabaseService(uid: user!.uid).updateUserData('1');
      return _userFromFirebaseUser(user);
    }catch(e){
      print(e.toString());
      return null;
    }
  }
  //sign out
  Future signOut() async {
    try{
      return await _auth.signOut();
    }catch(e){
      return null;
    }
  }
}