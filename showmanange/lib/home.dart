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

import 'package:csee/reservelist.dart';
import 'package:csee/userInfo.dart';
import 'package:csee/userinfomod.dart';
import 'package:flutter/material.dart';
import 'show_list.dart';
import 'mypage.dart';

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
    final pageTitle = [
      '공연목록',
      '예약한 공연',
      '내 공연 관리',
      '내 정보'
    ];

    Widget child;
    switch (_currentIndex) {
      case 0:
        child = ShowList();
        break;
      case 1:
        child = ReserveListPage();
        break;
      case 2:
        child = MyPage();
        break;
      case 3:
        child = UserInfoModPage();
        break;

    }
    return Scaffold(
      appBar: AppBar(
          title: Text(pageTitle[_currentIndex]),
          elevation: 0,
          actions: _currentIndex == 2
              ? <Widget>[
                    Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(25),
                      ),
                      child: FlatButton(
                        child: Text('새 공연 등록'),
                        onPressed: () {
                          Navigator.pushNamed(context, '/addpage');
                        },
                      ),
                    ),

                ]
              : null),
      body: child,
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        selectedItemColor: Colors.redAccent,
        unselectedItemColor: Colors.grey,
        onTap: onTapped,
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            title: Text('공연목록'),
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.list),
            title: Text('예약한 공연'),
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.audiotrack),
            title: Text('등록한 공연'),
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.settings),
            title: Text('내 정보'),
          ),
        ],
      ),
    );
  }
}
