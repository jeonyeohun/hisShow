import 'dart:io';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';


class DetailPage extends StatefulWidget {
  State<DetailPage> createState() => DetailPageSate();
}

class DetailPageSate extends State<DetailPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('공연정보'),
      ),
    );
  }

}
