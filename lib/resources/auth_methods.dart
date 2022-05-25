import 'dart:typed_data';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:instagram_clone_flutter/models/user.dart' as model;
import 'package:instagram_clone_flutter/resources/storage_methods.dart';

class AuthMethods{
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<model.User> getUserDetails() async{
    User currentUser = _auth.currentUser!;
    DocumentSnapshot snap = await _firestore.collection('users').doc(currentUser.uid).get();

    return model.User.fromSnap(snap);
  }

  //sign up
  Future<String> signUpUser({
    required String email,
    required String password,
    required String username,
    required String bio,
    required Uint8List file,
  }) async {
    String res = 'Ocurrio un error';
    try{
      if(email.isNotEmpty || password.isNotEmpty || username.isNotEmpty || bio.isNotEmpty){// || file != null){
        // registrar usuario
        UserCredential cred = await _auth.createUserWithEmailAndPassword(email: email, password: password);
        
        print(cred.user!.uid);

        String photoUrl = await StorageMethods().uploadImageToStorage('profilePics', file, false);

        model.User user = model.User(
          username: username,
          uid: cred.user!.uid,
          email: email,
          bio: bio,
          photoUrl: photoUrl,
          following: [],
          followers: [],
        );
        //agregar usuario a BD
        await _firestore.collection('users').doc(cred.user!.uid).set(user.toJson());
        res = 'success';
      }
    } 
    catch(err){
        res = err.toString();
    }
    return res;
  }
  //logging
  Future<String> loginUser({
    required String email,
    required String password,
  }) async {
    String res = 'Ocurrio un error';

    try{
      if(email.isNotEmpty || password.isNotEmpty){
        await _auth.signInWithEmailAndPassword(email: email, password: password);
        res = 'success';
      }else{
        res = 'Completa todos los campos';
      }
    } on FirebaseAuthException catch (e){
      if(e.code == 'wrong-password'){
        res='Contraseña incorrecta';
      }
    }
    
    catch(err){
      res = err.toString();
    }
    return res;
  }

  Future<void> SignOut() async{
    await _auth.signOut();
  }
}