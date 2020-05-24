import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'dart:io';

import 'package:image_picker/image_picker.dart';

class AddPage extends StatefulWidget {
  State<AddPage> createState() => AddPageSate();
}

class AddPageSate extends State<AddPage> {
  final TextEditingController titleText = TextEditingController();
  final TextEditingController priceText = TextEditingController();
  final TextEditingController desText = TextEditingController();

  List<String> field = ['공연 이름', '단체 이름', '공연 설명', '예금주', '계좌 번호'];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('공연 등록'),
        ),
        body: ListView(
          children: <Widget>[
            Column(
              children: <Widget>[
                ImageSection(),
                Container(
                  padding: EdgeInsets.all(15),
                  child: Column(
                    children: <Widget>[
                      Container(
                        padding: EdgeInsets.fromLTRB(30, 0, 30, 0),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(15),
                          border: Border.all(width: 0.2, color: Colors.grey),
                          color: Color.fromARGB(10, 10, 10, 90),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.max,
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: <Widget>[
                            Container(
                                child: Container(
                              child: Row(
                                children: <Widget>[
                                  FlatButton(
                                      child: Row(children: <Widget>[
                                        Icon(
                                          Icons.calendar_today,
                                          color: Colors.blueGrey,
                                          size: 13,
                                        ),
                                        Text(' 날짜등록')
                                      ]),
                                      onPressed: () {
                                        showDatePicker(
                                                context: context,
                                                initialDate: DateTime.now(),
                                                firstDate: DateTime(2019),
                                                lastDate: DateTime(2022))
                                            .then((date) {
                                          setState(() {});
                                        });
                                      }),
                                  FlatButton(
                                      child: Row(children: <Widget>[
                                        Icon(
                                          Icons.event_seat,
                                          color: Colors.blueGrey,
                                          size: 13,
                                        ),
                                        Text(' 좌석등록')
                                      ]),
                                      onPressed: () {
                                        showDatePicker(
                                                context: context,
                                                initialDate: DateTime.now(),
                                                firstDate: DateTime(2019),
                                                lastDate: DateTime(2022))
                                            .then((date) {
                                          setState(() {});
                                        });
                                      }),
                                ],
                              ),
                            ))
                          ],
                        ),
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      Container(
                        child: Column(
                          children:
                              field.map((e) => _buildInputBox(e)).toList(),
                        ),
                      ),
                      SizedBox(
                        height: 30,
                      ),
                      RaisedButton(
                        color: Colors.redAccent,
                        textColor: Colors.white,
                        child: Text("등록하기"),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30)),
                        onPressed: () {},
                      ),
                    ],
                  ),
                )
              ],
            ),
          ],
        ));
  }

  Widget _buildInputBox(String labelText) {
    return Container(
      margin: EdgeInsets.fromLTRB(0, 5.5, 0, 5.5),
      height: 50,
      child: TextField(
        decoration: InputDecoration(
          focusColor: Color.fromRGBO(255, 178, 174, 10),
          focusedBorder: OutlineInputBorder(
            borderSide: const BorderSide(
                color: Color.fromRGBO(255, 178, 174, 10), width: 2.0),
            borderRadius: BorderRadius.circular(15.0),
          ),
          labelText: labelText,
          labelStyle: TextStyle(fontSize: 13, color: Colors.blueGrey),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(15.0),
            borderSide: BorderSide(),
          ),
        ),
        controller: titleText,
      ),
    );
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
