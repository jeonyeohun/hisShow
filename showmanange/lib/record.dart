
import 'package:cloud_firestore/cloud_firestore.dart';

class Record {
  final String title;
  final DateTime date;
  final String description;
  final String uid;
  final List<dynamic> voteList;
  final String imageURL;
  final List<List<String>> sits;

  final DocumentReference reference;

  Record.fromMap(Map<String, dynamic> map, {this.reference})
      : assert(map['title'] != null),
      title = map['title'],
  date = map['date'],
  description = map['description'],
  uid = map['uid'],
  voteList = map['voteList'],
  imageURL = map['imageURL'],
  sits = map['sits'];


  Record.fromSnapshot(DocumentSnapshot snapshot)
      : this.fromMap(snapshot.data, reference: snapshot.reference);
}