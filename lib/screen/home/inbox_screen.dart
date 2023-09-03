import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:timeago_flutter/timeago_flutter.dart';

import '../../api/api_constant.dart';
import '../../api/api_services.dart';
import '../../sharedpreference/sharedpreference.dart';
import '../chat/home_screen_inbox.dart';

class InboxScreen extends StatefulWidget {
  const InboxScreen({Key? key}) : super(key: key);

  @override
  InboxScreenState createState() => InboxScreenState();
}

class InboxScreenState extends State<InboxScreen> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  // late QuerySnapshot<Map<String, dynamic>> chats;

  bool _loading = false;
  String id = "";
  String name = "";
  bool isListener = false;

  String walletAmount = "0.0";
  bool isProgressingRunning = false;

  Future<void> loadData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    id = prefs.getString("userId")!;
    name = prefs.getString("userName")!;
    isListener = prefs.getBool("isListener")!;

    // _firestore
    //     .collection('chatroom')
    //     .where('user', isEqualTo: id)
    //     .get()
    //     .then((value) {
    setState(() {
      _loading = false;
      // chats = value;
    });
    // });
  }

  @override
  void initState() {
    super.initState();
    _loading = true;
    loadData();
    // apiWallet();
    // Future.delayed(Duration.zero, () async {
    //   String amount = await APIServices.getWalletAmount(
    //           SharedPreference.getValue(PrefConstants.MERA_USER_ID)) ??
    //       "0.0";
    //   setState(() {
    //     walletAmount = amount;
    //     SharedPreference.setValue(PrefConstants.WALLET_AMOUNT, walletAmount);
    //   });
    // });
  }

  Future<void> apiWallet() async {
    try {
      setState(() {
        isProgressingRunning = true;
      });
      String amount = await APIServices.getWalletAmount(
              SharedPreference.getValue(PrefConstants.MERA_USER_ID)) ??
          "0.0";
      setState(() {
        walletAmount = amount;
        SharedPreference.setValue(PrefConstants.WALLET_AMOUNT, walletAmount);
      });
    } catch (e) {
      log(e.toString());
    } finally {
      setState(() {
        isProgressingRunning = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return _loading
        ? const Center(child: CircularProgressIndicator())
        : StreamBuilder<QuerySnapshot>(
            stream: _firestore
                .collection('chatroom')
                .where('user', isEqualTo: id)
                .snapshots(),
            builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
              if (snapshot.hasData) {
                var chats = snapshot.data!.docs;
                return Container(
                  height: double.infinity,
                  decoration: const BoxDecoration(
                    gradient: LinearGradient(
                      colors: [Color(0xffA3E0F5), Color(0xffF3FBFE)],
                      begin: Alignment.bottomLeft,
                      end: Alignment.topRight,
                      stops: [0.1, 0.9],
                      tileMode: TileMode.repeated,
                    ),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.only(top: 25.0),
                    child: ListView.builder(
                        itemCount: chats.length,
                        itemBuilder: (context, index) {
                          var item = chats[index];
                          return Container(
                            margin: const EdgeInsets.symmetric(
                                horizontal: 20.0, vertical: 10.0),
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(20.0),
                                boxShadow: [
                                  BoxShadow(
                                      color: Colors.grey.shade300,
                                      spreadRadius: 5,
                                      blurRadius: 5)
                                ],
                                color: Colors.white),
                            child: ListTile(
                              onTap: () {
                                // if (double.tryParse(walletAmount)! <= 40.0) {
                                //   // showLowBalancetDialog(context);
                                // } else {

                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => HomeScreenInbox(
                                              listenerId: item['listener'],
                                              listenerName:
                                                  item['listener_name'],
                                              userId: id,
                                              userName: name,
                                            )));
                                // }
                              },
                              title: Text(item['listener_name']),
                              subtitle: item["listener_count"] > 0
                                  ? const Text(
                                      'You have a new message',
                                      style: TextStyle(
                                        color: Colors.grey,
                                        fontSize: 12,
                                        fontWeight: FontWeight.w700,
                                      ),
                                    )
                                  : Timeago(
                                      date: item["last_time"] == null
                                          ? DateTime.now()
                                          : item["last_time"].toDate(),
                                      builder:
                                          (BuildContext context, String value) {
                                        return Text(
                                          value,
                                          style: const TextStyle(
                                            fontSize: 12.0,
                                          ),
                                        );
                                      },
                                    ),
                              // subtitle: Text(item['session'].toString()),
                              leading: item["listener_photo"] == null ||
                                      item["listener_photo"] == ""
                                  ? const Icon(Icons.account_circle)
                                  : CircleAvatar(
                                      backgroundImage: NetworkImage(
                                          "${APIConstants.BASE_URL}${item["listener_photo"]}"),
                                    ),

                              trailing: Visibility(
                                visible: item["listener_count"] > 0,
                                child: Container(
                                  decoration: BoxDecoration(
                                      boxShadow: [
                                        BoxShadow(
                                          color: Colors.grey.shade500,
                                          blurRadius: 10.0,
                                        ),
                                      ],
                                      shape: BoxShape.circle,
                                      color: Colors.green),
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Text(
                                      isListener
                                          ? item["user_count"].toString()
                                          : item["listener_count"].toString(),
                                      style:
                                          const TextStyle(color: Colors.white),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          );
                        }),
                  ),
                );
              } else if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              } else {
                return Container();
              }
            });
  }
}
