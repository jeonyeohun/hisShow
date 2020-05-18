// Copyright 2018-present the Flutter authors. All Rights Reserved.
//
// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at
//
// http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the License for the specific language governing permissions and
// limitations under the License.

import 'package:csee/2.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '1.dart';

class HomePage extends StatefulWidget {
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _currentIndex = 0;

  void onTapped(int index) {
    setState(() {
      _currentIndex = index;
    });
  }
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    Widget child;
    switch (_currentIndex) {
      case 0:
        child = First();
        break;
      case 1:
        child = Second();
        break;
      case 2:
        child = FlutterLogo(colors: Colors.red);
        break;
    }
    return Scaffold(
      appBar: AppBar(
        title: Text('공연목록'),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.add),
            onPressed: (){},
          )
        ],
      ),
      body: child,
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        selectedItemColor: Colors.redAccent,
        onTap: onTapped,
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            title: Text('공연목록'),
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.list),
            title: Text('예약관리'),
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.settings),
            title: Text('설정'),
          ),
        ],
      ),
    );
  }
}
