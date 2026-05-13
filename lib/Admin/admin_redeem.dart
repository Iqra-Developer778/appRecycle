import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:apprecycle/services/database.dart';

class AdminRedeem extends StatefulWidget {
  const AdminRedeem({super.key});

  @override
  State<AdminRedeem> createState() => _AdminRedeemState();
}

class _AdminRedeemState extends State<AdminRedeem> {

  Stream<QuerySnapshot> getRedeemStream() {
    return FirebaseFirestore.instance
        .collection("Redeem")
        .where("Status", isEqualTo: "Pending")
        .snapshots();
  }

  Future<void> approveRedeem(String redeemId, String userId,
      int points, String userName) async {
    try {
      // ✅ Step 1: Admin Redeem collection → Approved
      await FirebaseFirestore.instance
          .collection("Redeem")
          .doc(redeemId)
          .update({"Status": "Approved"});

      // ✅ Step 2: User subcollection Redeem → Approved
      if (userId.isNotEmpty) {
        try {
          await FirebaseFirestore.instance
              .collection("users")
              .doc(userId)
              .collection("Redeem")
              .doc(redeemId)
              .update({"Status": "Approved"});
        } catch (e) {
          // subcollection doc na mile to skip
        }

        // ✅ Step 3: User ke Points deduct karo
        if (points > 0) {
          DocumentReference userRef = FirebaseFirestore.instance
              .collection("users")
              .doc(userId);

          DocumentSnapshot userSnap = await userRef.get();

          if (userSnap.exists) {
            Map<String, dynamic> userData =
            userSnap.data() as Map<String, dynamic>;
            int currentPoints =
            ((userData["Points"] ?? 0) as num).toInt();
            int updated = (currentPoints - points).clamp(0, 999999);
            await userRef.update({"Points": updated});
          }
        }
      }

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("$userName ka redeem approve ho gaya!"),
          backgroundColor: Colors.green,
        ),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Error: $e"),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Redeem Approval"),
        backgroundColor: Colors.green,
        centerTitle: true,
        foregroundColor: Colors.white,
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: getRedeemStream(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }

          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.check_circle_outline,
                      size: 70, color: Colors.grey[300]),
                  SizedBox(height: 15),
                  Text(
                    "No Pending Redeem Requests",
                    style: TextStyle(
                        fontSize: 16, color: Colors.grey),
                  ),
                ],
              ),
            );
          }

          return ListView.builder(
            padding: EdgeInsets.all(12),
            itemCount: snapshot.data!.docs.length,
            itemBuilder: (context, index) {
              var ds = snapshot.data!.docs[index];
              var data = ds.data() as Map<String, dynamic>;

              String redeemId = ds.id;
              String userId = data["UserId"] ?? "";
              String userName = data["UserName"] ?? "User";
              String jazzCash = data["JazzCash"] ?? "N/A";
              int points = ((data["Points"] ?? 0) as num).toInt();
              String status = data["Status"] ?? "Pending";

              // Date
              String dateStr = "";
              if (data["Time"] != null) {
                DateTime dt = (data["Time"] as Timestamp).toDate();
                dateStr =
                "${dt.day}/${dt.month}/${dt.year}";
              }

              return Card(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15)),
                elevation: 3,
                margin: EdgeInsets.only(bottom: 15),
                child: Padding(
                  padding: EdgeInsets.all(15),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [

                      /// USER INFO ROW
                      Row(
                        children: [
                          CircleAvatar(
                            backgroundColor: Colors.green.shade100,
                            child: Icon(Icons.person,
                                color: Colors.green),
                          ),
                          SizedBox(width: 10),
                          Expanded(
                            child: Column(
                              crossAxisAlignment:
                              CrossAxisAlignment.start,
                              children: [
                                Text(
                                  userName,
                                  style: TextStyle(
                                      fontSize: 17,
                                      fontWeight: FontWeight.bold),
                                ),
                                if (dateStr.isNotEmpty)
                                  Text(
                                    dateStr,
                                    style: TextStyle(
                                        fontSize: 12,
                                        color: Colors.grey),
                                  ),
                              ],
                            ),
                          ),

                          /// STATUS BADGE
                          Container(
                            padding: EdgeInsets.symmetric(
                                horizontal: 10, vertical: 4),
                            decoration: BoxDecoration(
                              color: Colors.orange.shade50,
                              borderRadius: BorderRadius.circular(20),
                              border: Border.all(
                                  color: Colors.orange, width: 1),
                            ),
                            child: Text(
                              status,
                              style: TextStyle(
                                  color: Colors.orange,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 12),
                            ),
                          ),
                        ],
                      ),

                      SizedBox(height: 12),
                      Divider(height: 1, color: Colors.grey[200]),
                      SizedBox(height: 12),

                      /// POINTS ROW
                      Row(
                        children: [
                          Icon(Icons.monetization_on,
                              color: Colors.orange, size: 20),
                          SizedBox(width: 8),
                          Text(
                            "Points: ",
                            style: TextStyle(
                                fontSize: 15, color: Colors.grey[600]),
                          ),
                          Text(
                            "$points pts",
                            style: TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.bold,
                                color: Colors.black),
                          ),
                        ],
                      ),

                      SizedBox(height: 8),

                      /// JAZZCASH ROW
                      Row(
                        children: [
                          Icon(Icons.phone_android,
                              color: Colors.green, size: 20),
                          SizedBox(width: 8),
                          Text(
                            "JazzCash: ",
                            style: TextStyle(
                                fontSize: 15, color: Colors.grey[600]),
                          ),
                          Text(
                            jazzCash,
                            style: TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.bold,
                                color: Colors.black),
                          ),
                        ],
                      ),

                      SizedBox(height: 15),

                      /// APPROVE BUTTON
                      SizedBox(
                        width: double.infinity,
                        height: 45,
                        child: ElevatedButton.icon(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.green,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                          icon: Icon(Icons.check_circle,
                              color: Colors.white),
                          label: Text(
                            "Approve Redeem",
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 16,
                                fontWeight: FontWeight.bold),
                          ),
                          onPressed: () async {
                            // Confirm dialog
                            bool? confirm = await showDialog<bool>(
                              context: context,
                              builder: (ctx) => AlertDialog(
                                shape: RoundedRectangleBorder(
                                    borderRadius:
                                    BorderRadius.circular(15)),
                                title: Text("Confirm Approval"),
                                content: Text(
                                  " Do you want to approve $points redeem for $userName?",
                                  //iqragul ko 16 points ka redeem approve krwana chahaty hu
                                ),
                                actions: [
                                  TextButton(
                                    onPressed: () =>
                                        Navigator.pop(ctx, false),
                                    child: Text("Cancel",
                                        style: TextStyle(
                                            color: Colors.grey)),
                                  ),
                                  ElevatedButton(
                                    style: ElevatedButton.styleFrom(
                                        backgroundColor: Colors.green),
                                    onPressed: () =>
                                        Navigator.pop(ctx, true),
                                    child: Text("Approve",
                                        style: TextStyle(
                                            color: Colors.white)),
                                  ),
                                ],
                              ),
                            );

                            if (confirm == true) {
                              await approveRedeem(
                                  redeemId, userId, points, userName);
                            }
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}