import 'package:cloud_firestore/cloud_firestore.dart';

class FirestoreHelper {
  FirestoreHelper._();
  static final FirestoreHelper firestoreHelper = FirestoreHelper._();
  static final FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;
  late CollectionReference userRef;
  late CollectionReference partyRef;

  //connectionWithCollection
  void connectionWithUsersCollection() {
    userRef = firebaseFirestore.collection('users');
  }

  void connectionWithPartyCollection() {
    partyRef = firebaseFirestore.collection('parties');
  }

  //insertRecord
  Future<void> insertRecord({
    required String id,
    required String name,
    required String email,
    required int age,
    required String password,
  }) async {
    connectionWithUsersCollection();

    Map<String, dynamic> data = {
      'name': name,
      'email': email,
      'age': age,
      'password': password,
      'hasVoted': false,
    };

    await userRef.doc(id).set(data);
  }

  //updateRecord
  updateRecord({required String id, required int totalVotes}) async {
    connectionWithPartyCollection();
    Map<String, dynamic> data = {'total_votes': totalVotes};
    await partyRef.doc(id).update(data);
  }

  updateUserRecord({required String id, required bool voteStatus}) async {
    connectionWithUsersCollection();
    Map<String, dynamic> data = {
      'hasVoted': voteStatus,
    };
    await userRef.doc(id).update(data);
  }

  //fetchRecords
  Stream<QuerySnapshot> fetchPartiesRecord() {
    connectionWithPartyCollection();

    return partyRef.snapshots();
  }
}
