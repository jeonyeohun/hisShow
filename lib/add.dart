import 'package:auto_size_text/auto_size_text.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:csee/seat.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:uuid/uuid.dart';
import 'package:flutter/material.dart';
import 'dart:io';

import 'package:image_picker/image_picker.dart';

class AddPage extends StatefulWidget {
  State<AddPage> createState() => AddPageSate();
}

class AddPageSate extends State<AddPage> {
  static final TextEditingController titleText = TextEditingController();
  static final TextEditingController priceText = TextEditingController();
  static final TextEditingController desText = TextEditingController();
  static final TextEditingController bankText = TextEditingController();
  static final TextEditingController accountText = TextEditingController();
  static final TextEditingController ownerText = TextEditingController();
  static final TextEditingController groupdesText = TextEditingController();
  static final TextEditingController placeText = TextEditingController();

  final String uuid = Uuid().v1();
  DateTime showDate = null;
  DateTime showTime = null;
  static Map<dynamic, dynamic> seats;

  String datetime2date(DateTime date) {
    return ' ' + date.month.toString() + '월' + date.day.toString() + '일';
  }

  String datetime2time(DateTime date) {
    return ' ' + date.hour.toString() + '시' + date.minute.toString() + '분';
  }

  Map<String, TextEditingController> field = {
    '공연 이름': titleText,
    '단체 이름': ownerText,
    '단체 소개': groupdesText,
    '공연 설명': desText,
    '가격': priceText,
    '공연 장소': placeText,
  };

  @override
  void initState() {
    titleText.clear();
    desText.clear();
    ownerText.clear();
    priceText.clear();
    bankText.clear();
    accountText.clear();
    groupdesText.clear();
    placeText.clear();
    seats = null;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('공연 등록'),
        ),
        body: ListView(
          children: <Widget>[
            Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                ImageSection(),
                Container(
                  padding: EdgeInsets.all(15),
                  child: Column(
                    children: <Widget>[
                      Container(
                        padding: EdgeInsets.fromLTRB(15, 0, 15, 0),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(15),
                          border: Border.all(width: 0.2, color: Colors.grey),
                          color: Color.fromARGB(10, 10, 10, 90),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.max,
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: <Widget>[
                            Flex(
                              direction: Axis.horizontal,
                              children: <Widget>[
                                Container(
                                  child: Row(
                                    children: <Widget>[
                                      FlatButton(
                                          child: Row(children: <Widget>[
                                            Icon(
                                              Icons.calendar_today,
                                              color: Colors.blueGrey,
                                              size: 13,
                                            ),
                                            showDate == null
                                                ? Text(' 날짜등록')
                                                : Text(datetime2date(showDate)),
                                          ]),
                                          onPressed: () {
                                            showModalBottomSheet(
                                                context: context,
                                                builder:
                                                    (BuildContext builder) {
                                                  return Container(
                                                    height: 150,
                                                    child: CupertinoDatePicker(
                                                      use24hFormat: true,
                                                      mode:
                                                          CupertinoDatePickerMode
                                                              .date,
                                                      initialDateTime:
                                                          DateTime.now(),
                                                      onDateTimeChanged:
                                                          (DateTime value) {
                                                        setState(() {
                                                          showDate = value;
                                                        });
                                                      },
                                                    ),
                                                  );
                                                });
                                          }),
                                      FlatButton(
                                          child: Row(
                                            children: <Widget>[
                                              Icon(
                                                Icons.access_time,
                                                color: Colors.blueGrey,
                                                size: 13,
                                              ),
                                              showTime == null
                                                  ? Text(' 시간등록')
                                                  : Text(
                                                      datetime2time(showTime)),
                                            ],
                                          ),
                                          onPressed: () {
                                            showModalBottomSheet(
                                                context: context,
                                                builder:
                                                    (BuildContext builder) {
                                                  return Container(
                                                    height: 150,
                                                    child: CupertinoDatePicker(
                                                      use24hFormat: true,
                                                      mode:
                                                          CupertinoDatePickerMode
                                                              .time,
                                                      initialDateTime:
                                                          DateTime.now(),
                                                      onDateTimeChanged:
                                                          (DateTime value) {
                                                        setState(() {
                                                          showTime = value;
                                                        });
                                                      },
                                                    ),
                                                  );
                                                });
                                          }),
                                      FlatButton(
                                          child: Row(children: <Widget>[
                                            Icon(
                                              Icons.event_seat,
                                              color: Colors.blueGrey,
                                              size: 13,
                                            ),
                                            seats == null
                                                ? Text(' 좌석등록')
                                                : AutoSizeText(' 총 ' +
                                                    (seats.length - 2)
                                                        .toString() +
                                                    '좌석')
                                          ]),
                                          onPressed: () async {
                                            var returnSeat =
                                                await Navigator.push(
                                              context,
                                              CupertinoPageRoute(
                                                  fullscreenDialog: true,
                                                  builder: (context) =>
                                                      SeatPage()),
                                            );
                                            setState(() {
                                              seats = returnSeat;
                                            });
                                          }),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      Container(
                        child: Column(
                            children: field.entries
                                .map((e) => _buildInputBox(e))
                                .toList()),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        mainAxisSize: MainAxisSize.max,
                        children: <Widget>[
                          Flexible(
                            child: Container(
                              margin: EdgeInsets.fromLTRB(0, 5.5, 0, 5.5),
                              child: TextField(
                                decoration: InputDecoration(
                                  focusColor: Color.fromRGBO(255, 178, 174, 10),
                                  focusedBorder: OutlineInputBorder(
                                    borderSide: const BorderSide(
                                        color:
                                            Color.fromRGBO(255, 178, 174, 10),
                                        width: 2.0),
                                    borderRadius: BorderRadius.circular(15.0),
                                  ),
                                  labelText: '은행',
                                  labelStyle: TextStyle(
                                      fontSize: 13, color: Colors.blueGrey),
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(15.0),
                                    borderSide: BorderSide(),
                                  ),
                                ),
                                controller: bankText,
                              ),
                            ),
                          ),
                          SizedBox(
                            width: 10,
                          ),
                          Flexible(
                            child: Container(
                              margin: EdgeInsets.fromLTRB(0, 5.5, 0, 5.5),
                              child: TextField(
                                decoration: InputDecoration(
                                  focusColor: Color.fromRGBO(255, 178, 174, 10),
                                  focusedBorder: OutlineInputBorder(
                                    borderSide: const BorderSide(
                                        color:
                                            Color.fromRGBO(255, 178, 174, 10),
                                        width: 2.0),
                                    borderRadius: BorderRadius.circular(15.0),
                                  ),
                                  labelText: '계좌번호',
                                  labelStyle: TextStyle(
                                      fontSize: 13, color: Colors.blueGrey),
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(15.0),
                                    borderSide: BorderSide(),
                                  ),
                                ),
                                controller: accountText,
                              ),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      RaisedButton(
                        color: Colors.redAccent,
                        textColor: Colors.white,
                        child: Text("등록하기"),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30)),
                        onPressed: () {
                          _ImageSectionState._image == null
                              ? showDialog(
                                  context: context,
                                  builder: (BuildContext context) =>
                                      CupertinoAlertDialog(
                                          title: Text('사진을 등록해주세요!')))
                              : createItem();
                          Navigator.of(context).pop();
                        },
                      ),
                    ],
                  ),
                )
              ],
            ),
          ],
        ));
  }

  Widget _buildInputBox(MapEntry<String, TextEditingController> map) {
    return Container(
      margin: EdgeInsets.fromLTRB(0, 5.5, 0, 5.5),
      //height: 50,
      child: TextFormField(
          maxLines: map.value == desText || map.value == groupdesText ? 10 : 1,
          decoration: InputDecoration(
            focusColor: Color.fromRGBO(255, 178, 174, 10),
            focusedBorder: OutlineInputBorder(
              borderSide: const BorderSide(
                  color: Color.fromRGBO(255, 178, 174, 10), width: 2.0),
              borderRadius: BorderRadius.circular(15.0),
            ),
            labelText: map.key,
            labelStyle: TextStyle(fontSize: 13, color: Colors.blueGrey),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(15.0),
              borderSide: BorderSide(),
            ),
          ),
          controller: map.value),
    );
  }

  void createItem() async {
    final FirebaseUser userID = await FirebaseAuth.instance.currentUser();
    String uid = userID.uid;
    String imgURL = await uploadImage();

    DocumentReference ref = await Firestore.instance.collection('Shows').add({
      'title': titleText.text,
      'description': desText.text,
      'date': showDate,
      'time': showTime,
      'price': priceText.text,
      'voteList': [],
      'imageURL': imgURL,
      'group': ownerText.text,
      'uid': uid,
      'seats': seats,
      'bank': bankText.text,
      'bankAccount': accountText.text,
      'groupDescription': groupdesText.text,
      'place': placeText.text,
      'reservation': {},
      'resConfirm': {},
    });
  }

  Future<String> uploadImage() async {
    File img = _ImageSectionState._image;
    if (img != null) {
      StorageReference ref =
          FirebaseStorage.instance.ref().child(uuid).child('image.jpg');
      StorageUploadTask uploadTask = ref.putFile(img);
      var url = await (await uploadTask.onComplete).ref.getDownloadURL();
      return url.toString();
    }
    return null;
  }
}

class ImageSection extends StatefulWidget {
  _ImageSectionState createState() => _ImageSectionState();
}

class _ImageSectionState extends State<ImageSection> {
  static File _image;

  getGalleryImage() async {
    var image = await ImagePicker.pickImage(source: ImageSource.gallery);
    setState(() {
      _image = image;
    });
  }

  void dispose() {
    _image = null;
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Container(
          height: 250,
          child: _image == null
              ? Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Text('공연 포스터 혹은 공연 사진을 첨부해주세요'),
                    IconButton(
                      icon: Icon(Icons.camera_alt),
                      onPressed: () {
                        getGalleryImage();
                      },
                    )
                  ],
                )
              : Image.file(_image),
        ),
        Divider(
          height: 5,
          color: Colors.blueGrey,
        )
      ],
    );
  }
}
