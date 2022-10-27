import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final Stream<QuerySnapshot> userDetail =
      FirebaseFirestore.instance.collection('ueserdetails').snapshots();
  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser!;

    return StreamBuilder<QuerySnapshot>(
      stream: userDetail,
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (snapshot.hasError) {
          print('something went wrong');
        }
        if (snapshot.connectionState == ConnectionState.done) {
          return Center(child: CircularProgressIndicator());
        }
        final List storeage = [];
        snapshot.data?.docs.map((DocumentSnapshot document) {
          Map a = document.data() as Map<String, dynamic>;
          storeage.add(a);
        }).toList();
        return Scaffold(
          backgroundColor: Color.fromARGB(255, 133, 113, 212),
          body: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Center(
                child: Column(
                  children: [
                    Text(
                      user.email!,
                      style: TextStyle(fontSize: 25),
                    ),
                    Center(
                      child: Text(
                        'LOGIN HISTORY',
                        style: TextStyle(
                            fontSize: 20, fontWeight: FontWeight.bold),
                      ),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    for (var i = 0; i < storeage.length; i++) ...[
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Column(
                              children: [Text('DATE&TIME',style: TextStyle(fontSize: 15,fontWeight: FontWeight.bold),),Text(storeage[i]['detail'],style: TextStyle(fontSize: 10,fontWeight: FontWeight.bold))],
                            ),
                            Column(
                              children: [Text('LOCATION',style: TextStyle(fontSize: 15,fontWeight: FontWeight.bold)),Text(storeage[i]['location'],style: TextStyle(fontSize: 10,fontWeight: FontWeight.bold))],
                            )
                          ],
                        ),
                      )
                    ]
                  ],
                ),
              ),
              SizedBox(
                height: 20,
              ),
              ElevatedButton.icon(
                onPressed: () => FirebaseAuth.instance.signOut(),
                icon: Icon(Icons.arrow_back),
                label: Text(
                  "LOGOUT",
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.bold),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
