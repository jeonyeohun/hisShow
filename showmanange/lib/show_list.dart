import 'record.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class ShowList extends StatefulWidget {
  State<ShowList> createState() => ShowListState();
}

class ShowListState extends State<ShowList> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(body: _buildBody(context));
  }

  Widget _buildBody(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
        stream: Firestore.instance.collection('shows').snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) return Scaffold();
          return _buildList(context, snapshot.data.documents);
        });
  }

  bool isDataEmpty(DocumentSnapshot data) {
    return data.exists;
  }

  Widget _buildList(BuildContext context, List<DocumentSnapshot> snapshot) {
    if (snapshot.isEmpty)
      return Scaffold(
        body: Container(
          alignment: Alignment.center,
          child: Text('예정된 공연이 없습니다.'),
        ),
      );

    return ListView(
      padding: const EdgeInsets.only(top: 15),
      children: snapshot.map((data) => _buildItems(context, data)).toList(),
    );
  }

  Card _buildItems(BuildContext context, DocumentSnapshot data) {
    final record = Record.fromSnapshot(data);
    return Card(
        margin: EdgeInsets.all(10),
        elevation: 2,
        clipBehavior: Clip.antiAlias,
        child: Container(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Container(
                  padding: EdgeInsets.all(15),
                  child:
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: <Widget>[
                      Text('Date', style: TextStyle(fontSize: 20),),
                      Text(record.title, style: TextStyle(fontSize: 20),),
                    ],
                  )),
              FlatButton(
                child: Text('더보기'),
                onPressed: () {
                  Navigator.pushNamed(context, '/details');
                },
              ),
            ],
          ),
          height: 200,
        ));
  }
}
