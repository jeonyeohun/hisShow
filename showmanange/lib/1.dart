import 'dart:io';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';


class Second extends StatefulWidget {
  State<Second> createState() => SecondState();
}

class SecondState extends State<Second> {
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      body: Text('1'),
    );
  }

}