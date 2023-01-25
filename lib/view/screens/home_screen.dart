import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../controller/helpers/firestore_helper.dart';
import '../../controller/helpers/firebase_auth_helper.dart';
import '../../global.dart';

TextStyle txtStyle = GoogleFonts.ubuntu(
  fontSize: 18,
);

class HomeScreen extends StatelessWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.teal,
        title: Row(
          children: [
            Text(
              "Welcome, ${Global.currentUser!['name']}",
              style: GoogleFonts.ubuntu(
                fontSize: 18,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
        actions: [
          IconButton(
            onPressed: () {
              FirebaseAuthHelper.firebaseAuthHelper.signOut;
              Get.offNamedUntil('/login_screen', (route) => false);
            },
            icon: const Icon(Icons.exit_to_app),
          ),
        ],
      ),
      body: Container(
        height: Get.height,
        width: Get.width,
        child: StreamBuilder<QuerySnapshot>(
          stream: FirestoreHelper.firestoreHelper.fetchPartiesRecord(),
          builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
            if (snapshot.hasError) {
              return Center(
                child: Text("Error: ${snapshot.error}"),
              );
            } else if (snapshot.hasData) {
              QuerySnapshot? documents = snapshot.data;
              List<QueryDocumentSnapshot> data = documents!.docs;

              return ListView.builder(
                itemCount: data.length,
                itemBuilder: (context, i) {
                  return Container(
                    width: Get.width,
                    height: Get.height * 0.18,
                    margin:
                        const EdgeInsets.symmetric(horizontal: 8, vertical: 12),
                    decoration: BoxDecoration(
                        color: Colors.white,
                        boxShadow: <BoxShadow>[
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.2),
                            spreadRadius: 2,
                            blurRadius: 4,
                            offset: const Offset(0, 0),
                          ),
                        ]),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        const SizedBox(height: 14),
                        Text(
                          "Party:- ${data[i]['party_name']}",
                          style: txtStyle,
                        ),
                        const SizedBox(height: 14),
                        Text(
                          "Candidate:- ${data[i]['candidate_name']}",
                          style: txtStyle,
                        ),
                        const SizedBox(height: 14),
                        Text(
                          "Total Votes:- ${data[i]['total_votes']}",
                          style: txtStyle,
                        ),
                        (Global.currentUser!['hasVoted'] == false)
                            ? TextButton(
                                onPressed: () {
                                  showDialog(
                                      context: context,
                                      builder: (context) {
                                        return AlertDialog(
                                          title: Text(
                                              "Vote ${data[i]['party_name']} ?"),
                                          actions: [
                                            OutlinedButton(
                                              onPressed: () {
                                                Get.back();
                                              },
                                              child: Text(
                                                "Cancel",
                                                style: txtStyle,
                                              ),
                                            ),
                                            ElevatedButton(
                                              onPressed: () async {
                                                int totalVotes =
                                                    data[i]['total_votes'];
                                                totalVotes++;
                                                await FirestoreHelper
                                                    .firestoreHelper
                                                    .updateRecord(
                                                        id: data[i].id,
                                                        totalVotes: totalVotes);

                                                await FirestoreHelper
                                                    .firestoreHelper
                                                    .updateUserRecord(
                                                        id: Global.currentUser![
                                                            'email'],
                                                        voteStatus: true);
                                                Global.currentUser![
                                                    'hasVoted'] = true;

                                                Get.back();

                                                ScaffoldMessenger.of(context)
                                                    .showSnackBar(
                                                  SnackBar(
                                                    content: Text(
                                                        "Voted Successfully to ${data[i]['party_name']} "),
                                                    action: SnackBarAction(
                                                      onPressed: () {},
                                                      label: "Dismiss",
                                                      textColor: Colors.black,
                                                    ),
                                                    backgroundColor:
                                                        Colors.green,
                                                    behavior: SnackBarBehavior
                                                        .floating,
                                                  ),
                                                );
                                              },
                                              child: Text(
                                                "Vote",
                                                style: txtStyle,
                                              ),
                                            ),
                                          ],
                                        );
                                      });
                                },
                                child: Text(
                                  "Vote ${data[i]['party_name']}",
                                  style: txtStyle,
                                ),
                              )
                            : Text(
                                "You've already Voted",
                                style: txtStyle,
                              ),
                      ],
                    ),
                  );
                },
              );
            }
            return const Center(
              child: CircularProgressIndicator(
                color: Colors.teal,
              ),
            );
          },
        ),
      ),
    );
  }
}
