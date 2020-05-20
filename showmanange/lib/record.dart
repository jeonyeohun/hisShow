
import 'package:cloud_firestore/cloud_firestore.dart';

class Record {
  final String title;
  final Timestamp start_date;
  final Timestamp end_date;
  final String description;
  final String create_uid;
  final List<dynamic> vote_list;
  final String image_uid;
  final List<List<String>> sits;

  final DocumentReference reference;

  Record.fromMap(Map<String, dynamic> map, {this.reference})
      : assert(map['title'] != null),
   


  Record.fromSnapshot(DocumentSnapshot snapshot)
      : this.fromMap(snapshot.data, reference: snapshot.reference);
}