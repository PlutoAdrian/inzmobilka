import 'package:cloud_firestore/cloud_firestore.dart';

class Session {
  final String child;
  final DateTime date;
  final String id;
  Session({
    required this.child,
    required this.date,
    required this.id,
  });

  factory Session.fromFirestore(DocumentSnapshot<Map<String, dynamic>> snapshot,
      [SnapshotOptions? options]) {
    final data = snapshot.data()!;
    return Session(
      date: data['date'].toDate(),
      child: data['child'],
      id: snapshot.id,
    );
  }

  Map<String, Object?> toFirestore() {
    return {
      "date": Timestamp.fromDate(date),
      "child": child,
    };
  }
}