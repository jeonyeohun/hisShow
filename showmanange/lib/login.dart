import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:csee/userInfo.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

final FirebaseAuth _auth = FirebaseAuth.instance;
final GoogleSignIn _googleSignIn = GoogleSignIn();

class SignInPage extends StatefulWidget {
  final String title = 'Registration';
  @override
  State<StatefulWidget> createState() => SignInPageState();
}

class SignInPageState extends State<SignInPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Builder(builder: (BuildContext context) {
        return ListView(
          scrollDirection: Axis.vertical,
          padding: EdgeInsets.all(90),
          children: <Widget>[
            Image.asset('assets/logo.png', scale: 5,),
            _GoogleSignInSection(),
            _AnonymouslySignInSection(),
          ],
        );
      }),
    );
  }
}

class _AnonymouslySignInSection extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _AnonymouslySignInSectionState();
}

class _AnonymouslySignInSectionState extends State<_AnonymouslySignInSection> {
  bool _success;
  String _userID;
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Container(
            alignment: Alignment.center,
            child: ButtonTheme(
              minWidth: double.infinity,
              buttonColor: Colors.grey,
              child: RaisedButton(
                onPressed: () async {
                  await _signInAnonymously();
                  final QuerySnapshot result = await Firestore.instance.collection('UserInfo').getDocuments();
                  final List<DocumentSnapshot> documents = result.documents;
                  List<String> ll = [];
                  documents.forEach((element) {
                    ll.add(element.documentID);
                  });
                  print(ll);
                  if(!ll.contains(UserInfoRecord.currentUser.uid)) {
                    Navigator.popAndPushNamed(context, '/userinfo');
                  }
                  else Navigator.pop(context);
                },
                child: const Text('GUEST', style: TextStyle(color: Colors.white)),
              ),
            )),
      ],
    );
  }

  // Example code of how to sign in anonymously.
  void _signInAnonymously() async {
    final FirebaseUser user = (await _auth.signInAnonymously()).user;
    assert(user != null);
    assert(user.isAnonymous);
    assert(!user.isEmailVerified);
    assert(await user.getIdToken() != null);
    if (Platform.isIOS) {
      // Anonymous auth doesn't show up as a provider on iOS
      assert(user.providerData.isEmpty);
    } else if (Platform.isAndroid) {
      // Anonymous auth does show up as a provider on Android
      assert(user.providerData.length == 1);
      assert(user.providerData[0].providerId == 'firebase');
      assert(user.providerData[0].uid != null);
      assert(user.providerData[0].displayName == null);
      assert(user.providerData[0].photoUrl == null);
      assert(user.providerData[0].email == null);
    }

    final FirebaseUser currentUser = await _auth.currentUser();
    assert(user.uid == currentUser.uid);
    setState(() {
      if (user != null) {
        _success = true;
        _userID = user.uid;
        UserInfoRecord.currentUser = user;
      } else {
        _success = false;
      }
    });
  }
}

class _GoogleSignInSection extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _GoogleSignInSectionState();
}

class _GoogleSignInSectionState extends State<_GoogleSignInSection> {
  bool _success;
  String _userID;
  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Container(
          padding: const EdgeInsets.symmetric(vertical: 5.0),
          alignment: Alignment.center,
          child: ButtonTheme(
            minWidth: double.infinity,
            buttonColor: Colors.redAccent,
            child:RaisedButton(
              onPressed: () async {
                await _signInWithGoogle();
                final QuerySnapshot result = await Firestore.instance.collection('UserInfo').getDocuments();
                final List<DocumentSnapshot> documents = result.documents;
                List<String> ll = [];
                documents.forEach((element) {
                  ll.add(element.documentID);
                });
                print(ll);
                if(!ll.contains(UserInfoRecord.currentUser.uid)) {
                  Navigator.popAndPushNamed(context, '/userinfo');
                }
                else Navigator.pop(context);
              },
              child: const Text('GOOGLE', style: TextStyle(color: Colors.white)),
            ),
          ),
        ),
      ],
    );
  }

  // Example code of how to sign in with google.
  void _signInWithGoogle() async {
    final GoogleSignInAccount googleUser = await _googleSignIn.signIn();
    final GoogleSignInAuthentication googleAuth =
        await googleUser.authentication;
    final AuthCredential credential = GoogleAuthProvider.getCredential(
      accessToken: googleAuth.accessToken,
      idToken: googleAuth.idToken,
    );
    final FirebaseUser user =
        (await _auth.signInWithCredential(credential)).user;
    assert(user.email != null);
    assert(user.displayName != null);
    assert(!user.isAnonymous);
    assert(await user.getIdToken() != null);

    final FirebaseUser currentUser = await _auth.currentUser();
    assert(user.uid == currentUser.uid);
    setState(()  {
      if (user != null) {
        _success = true;
        _userID = user.uid;
        UserInfoRecord.currentUser = user;
      } else {
        _success = false;
      }
    });
  }
}
