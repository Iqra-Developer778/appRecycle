import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:apprecycle/services/database.dart';

class PointsPage extends StatefulWidget {
  const PointsPage({super.key});

  @override
  State<PointsPage> createState() => _PointsPageState();
}

class _PointsPageState extends State<PointsPage> {
  TextEditingController jazzcashController = TextEditingController();
  String uid = "";
  String userName = "";
  int currentPoints = 0;
  bool loading = true;

  @override
  void initState() {
    super.initState();
    getCurrentUser();
  }

  Future<void> getCurrentUser() async {
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      DocumentSnapshot doc = await FirebaseFirestore.instance
          .collection("users")
          .doc(user.uid)
          .get();

      if (doc.exists) {
        var data = doc.data() as Map<String, dynamic>;
        setState(() {
          uid = user.uid;
          currentPoints = (data["Points"] ?? 0) as int;
          userName = (data["name"] ?? "") as String;
          loading = false;
        });
      } else {
        setState(() {
          uid = user.uid;
          loading = false;
        });
      }
    } else {
      setState(() => loading = false);
    }
  }

  void showRedeemDialog() {
    jazzcashController.clear();
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape:
        RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        title: Text(
          "Redeem Points",
          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.green),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: EdgeInsets.symmetric(horizontal: 16, vertical: 10),
              decoration: BoxDecoration(
                color: Colors.green.shade50,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.monetization_on,
                      color: Colors.orange, size: 22),
                  SizedBox(width: 8),
                  Text(
                    "Available: $currentPoints pts",
                    style: TextStyle(
                        fontSize: 16, fontWeight: FontWeight.w700),
                  ),
                ],
              ),
            ),
            SizedBox(height: 15),
            TextField(
              controller: jazzcashController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                labelText: "JazzCash Number",
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                prefixIcon:
                Icon(Icons.phone_android, color: Colors.green),
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text("Cancel", style: TextStyle(color: Colors.grey)),
          ),
          ElevatedButton(
            style:
            ElevatedButton.styleFrom(backgroundColor: Colors.green),
            onPressed: () async {
              Navigator.pop(context);
              await redeemRequest();
            },
            child: Text("Send Request",
                style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }

  Future<void> redeemRequest() async {
    if (jazzcashController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Please enter your JazzCash Number")),
      );
      return;
    }

    if (uid.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("User not logged in")),
      );
      return;
    }

    DocumentSnapshot freshDoc = await FirebaseFirestore.instance
        .collection("users")
        .doc(uid)
        .get();

    int freshPoints = 0;
    String freshName = "";

    if (freshDoc.exists) {
      var data = freshDoc.data() as Map<String, dynamic>;
      freshPoints = (data["Points"] ?? 0) as int;
      freshName = (data["name"] ?? "") as String;
    }

    if (mounted) {
      setState(() {
        currentPoints = freshPoints;
        userName = freshName;
      });
    }

    if (freshPoints <= 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("You don't have enough points to redeem"),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    String redeemId =
        FirebaseFirestore.instance.collection("Redeem").doc().id;

    Map<String, dynamic> redeemData = {
      "JazzCash": jazzcashController.text.trim(),
      "Status": "Pending",
      "Time": FieldValue.serverTimestamp(),
      "UserId": uid,
      "UserName": freshName,
      "Points": freshPoints,
    };

    try {
      await FirebaseFirestore.instance
          .collection("Redeem")
          .doc(redeemId)
          .set(redeemData);

      await FirebaseFirestore.instance
          .collection("users")
          .doc(uid)
          .collection("Redeem")
          .doc(redeemId)
          .set(redeemData);

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Redeem request sent! ($freshPoints pts)"),
          backgroundColor: Colors.green,
        ),
      );
      jazzcashController.clear();
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Failed: $e"),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    if (loading) {
      return Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    return Scaffold(
      backgroundColor: Color(0xffF5F5F5),
      appBar: AppBar(
        title: Text(
          "Points Page",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0,
        centerTitle: true,
      ),
      body: uid.isEmpty
          ? Center(child: Text("Please log in to view points"))
          : StreamBuilder<DocumentSnapshot>(
        stream: FirebaseFirestore.instance
            .collection("users")
            .doc(uid)
            .snapshots(),
        builder: (context, userSnapshot) {

          if (userSnapshot.hasData && userSnapshot.data!.exists) {
            var userData =
            userSnapshot.data!.data() as Map<String, dynamic>;
            int newPoints = (userData["Points"] ?? 0) as int;
            String newName = (userData["name"] ?? "") as String;

            if (newPoints != currentPoints || newName != userName) {
              WidgetsBinding.instance.addPostFrameCallback((_) {
                if (mounted) {
                  setState(() {
                    currentPoints = newPoints;
                    userName = newName;
                  });
                }
              });
            }
          }

          return Padding(
            padding: EdgeInsets.all(20),
            child: Column(
              children: [
                SizedBox(height: 10),

                /// POINTS CARD
                Container(
                  width: double.infinity,
                  padding: EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.shade200,
                        blurRadius: 12,
                        spreadRadius: 3,
                      )
                    ],
                  ),
                  child: Column(
                    children: [
                      Container(
                        padding: EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: Colors.orange.shade50,
                          shape: BoxShape.circle,
                        ),
                        child: Icon(Icons.monetization_on,
                            color: Colors.orange, size: 45),
                      ),
                      SizedBox(height: 10),
                      if (userName.isNotEmpty)
                        Text(
                          userName,
                          style: TextStyle(
                              fontSize: 15,
                              color: Colors.grey[600],
                              fontWeight: FontWeight.w500),
                        ),
                      SizedBox(height: 4),
                      Text(
                        "Points Earned",
                        style: TextStyle(
                            fontSize: 14, color: Colors.grey[500]),
                      ),
                      SizedBox(height: 6),
                      Text(
                        "$currentPoints",
                        style: TextStyle(
                            fontSize: 38,
                            fontWeight: FontWeight.bold,
                            color: Colors.black),
                      ),
                    ],
                  ),
                ),

                SizedBox(height: 20),

                /// ✅ REDEEM BUTTON — disabled + msg when points = 0
                GestureDetector(
                  onTap: currentPoints <= 0 ? null : showRedeemDialog,
                  child: Container(
                    height: 60,
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: currentPoints <= 0
                          ? Colors.grey
                          : Colors.green,
                      borderRadius: BorderRadius.circular(14),
                      boxShadow: [
                        BoxShadow(
                          color: currentPoints <= 0
                              ? Colors.grey.withOpacity(0.3)
                              : Colors.green.withOpacity(0.3),
                          blurRadius: 8,
                          offset: Offset(0, 4),
                        )
                      ],
                    ),
                    child: Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            "Redeem Points",
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 18,
                                fontWeight: FontWeight.bold),
                          ),
                          // ✅ Sirf tab show ho jab points 0 hon
                          if (currentPoints <= 0)
                            Text(
                              "You can't redeem, points are 0",
                              style: TextStyle(
                                  color: Colors.white70,
                                  fontSize: 11),
                            ),
                        ],
                      ),
                    ),
                  ),
                ),

                SizedBox(height: 25),

                /// LAST TRANSACTIONS HEADER
                Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    "Last Transactions",
                    style: TextStyle(
                        fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                ),

                SizedBox(height: 10),

                /// TRANSACTIONS LIST
                Expanded(
                  child: StreamBuilder<QuerySnapshot>(
                    stream: FirebaseFirestore.instance
                        .collection("users")
                        .doc(uid)
                        .collection("Redeem")
                        .orderBy("Time", descending: true)
                        .snapshots(),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState ==
                          ConnectionState.waiting) {
                        return Center(
                            child: CircularProgressIndicator());
                      }

                      if (!snapshot.hasData ||
                          snapshot.data!.docs.isEmpty) {
                        return Center(
                          child: Column(
                            mainAxisAlignment:
                            MainAxisAlignment.center,
                            children: [
                              Icon(Icons.receipt_long,
                                  size: 50,
                                  color: Colors.grey[300]),
                              SizedBox(height: 10),
                              Text(
                                "No transactions yet",
                                style: TextStyle(
                                    color: Colors.grey,
                                    fontSize: 15),
                              ),
                            ],
                          ),
                        );
                      }

                      return ListView.builder(
                        itemCount: snapshot.data!.docs.length,
                        itemBuilder: (context, index) {
                          var doc = snapshot.data!.docs[index];
                          var data =
                          doc.data() as Map<String, dynamic>;

                          String status =
                              data["Status"] ?? "Pending";
                          int points =
                          (data["Points"] ?? 0) as int;
                          String jazz =
                              data["JazzCash"] ?? "N/A";

                          String day = "--";
                          String month = "";
                          if (data["Time"] != null) {
                            DateTime dt =
                            (data["Time"] as Timestamp)
                                .toDate();
                            day = dt.day.toString();
                            List<String> months = [
                              "",
                              "Jan","Feb","Mar","Apr",
                              "May","Jun","Jul","Aug",
                              "Sep","Oct","Nov","Dec"
                            ];
                            month = months[dt.month];
                          }

                          Color statusColor =
                          status == "Approved"
                              ? Colors.green
                              : status == "Rejected"
                              ? Colors.red
                              : Colors.orange;

                          return Container(
                            margin: EdgeInsets.only(bottom: 10),
                            padding: EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius:
                              BorderRadius.circular(12),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.grey.shade100,
                                  blurRadius: 6,
                                  spreadRadius: 1,
                                )
                              ],
                            ),
                            child: Row(
                              children: [
                                /// DATE BOX
                                Container(
                                  padding: EdgeInsets.symmetric(
                                      horizontal: 10,
                                      vertical: 8),
                                  decoration: BoxDecoration(
                                    color: Colors.black,
                                    borderRadius:
                                    BorderRadius.circular(8),
                                  ),
                                  child: Column(
                                    children: [
                                      Text(day,
                                          style: TextStyle(
                                              color: Colors.white,
                                              fontWeight:
                                              FontWeight.bold,
                                              fontSize: 16)),
                                      Text(month,
                                          style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 12)),
                                    ],
                                  ),
                                ),

                                SizedBox(width: 12),

                                /// DETAILS
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                    CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        "Redeem Request",
                                        style: TextStyle(
                                            fontWeight:
                                            FontWeight.bold,
                                            fontSize: 15),
                                      ),
                                      SizedBox(height: 3),
                                      Text(
                                        "JazzCash: $jazz",
                                        style: TextStyle(
                                            color:
                                            Colors.grey[600],
                                            fontSize: 13),
                                      ),
                                      SizedBox(height: 3),
                                      Text(
                                        "$points pts",
                                        style: TextStyle(
                                            color: Colors.black87,
                                            fontWeight:
                                            FontWeight.w600),
                                      ),
                                    ],
                                  ),
                                ),

                                /// STATUS BADGE
                                Container(
                                  padding: EdgeInsets.symmetric(
                                      horizontal: 10, vertical: 5),
                                  decoration: BoxDecoration(
                                    color: statusColor
                                        .withOpacity(0.15),
                                    borderRadius:
                                    BorderRadius.circular(20),
                                  ),
                                  child: Text(
                                    status,
                                    style: TextStyle(
                                        color: statusColor,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 12),
                                  ),
                                ),
                              ],
                            ),
                          );
                        },
                      );
                    },
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}