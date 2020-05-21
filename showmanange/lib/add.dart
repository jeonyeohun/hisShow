import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'dart:io';

import 'package:image_picker/image_picker.dart';

class AddPage extends StatefulWidget {
  State<AddPage> createState() => AddPageSate();
}

class AddPageSate extends State<AddPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('공연 등록'),
        ),
        body: Container(
          child: Column(
            children: <Widget>[
              ImageSection(),
            ],
          ),
        ));
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
