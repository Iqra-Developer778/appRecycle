import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:apprecycle/pages/login.dart'; // apna login page import karo

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  String uid = "";
  String name = "";
  String email = "";
  String image = "";
  int points = 0;
  bool loading = true;

  @override
  void initState() {
    super.initState();
    loadUserData();
  }

  /// ✅ Firebase se user data fetch karo
  Future<void> loadUserData() async {
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
          name = data["name"] ?? user.displayName ?? "User";
          email = data["email"] ?? user.email ?? "";
          image = data["image"] ?? user.photoURL ?? "";
          points = ((data["Points"] ?? 0) as num).toInt();
          loading = false;
        });
      } else {
        setState(() {
          uid = user.uid;
          name = user.displayName ?? "User";
          email = user.email ?? "";
          image = user.photoURL ?? "";
          loading = false;
        });
      }
    } else {
      setState(() => loading = false);
    }
  }

  /// ✅ Logout function
  Future<void> logout() async {
    bool? confirm = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        shape:
        RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        title: Text("Logout"),
        content: Text("Do you want to Logout ?"),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: Text("Cancel", style: TextStyle(color: Colors.grey)),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            onPressed: () => Navigator.pop(ctx, true),
            child:
            Text("Logout", style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );

    if (confirm == true) {
      await GoogleSignIn().signOut();
      await FirebaseAuth.instance.signOut();

      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => Login()),
            (route) => false,
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
          "Profile",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        centerTitle: true,
        elevation: 0,
      ),
      body: StreamBuilder<DocumentSnapshot>(
        stream: FirebaseFirestore.instance
            .collection("users")
            .doc(uid)
            .snapshots(),
        builder: (context, snapshot) {
          // ✅ Live update
          if (snapshot.hasData && snapshot.data!.exists) {
            var data = snapshot.data!.data() as Map<String, dynamic>;
            name = data["name"] ?? name;
            email = data["email"] ?? email;
            image = data["image"] ?? image;
            points = ((data["Points"] ?? 0) as num).toInt();
          }

          return SingleChildScrollView(
            child: Column(
              children: [
                /// TOP GREEN HEADER
                Container(
                  width: double.infinity,
                  padding: EdgeInsets.only(top: 30, bottom: 30),
                  decoration: BoxDecoration(
                    color: Colors.green,
                    borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(30),
                      bottomRight: Radius.circular(30),
                    ),
                  ),
                  child: Column(
                    children: [
                      /// PROFILE IMAGE
                      Container(
                        padding: EdgeInsets.all(3),
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.white,
                        ),
                        child: CircleAvatar(
                          radius: 50,
                          backgroundColor: Colors.grey[200],
                          backgroundImage: image.isNotEmpty
                              ? NetworkImage(image)
                              : null,
                          child: image.isEmpty
                              ? Icon(Icons.person,
                              size: 50, color: Colors.grey)
                              : null,
                        ),
                      ),

                      SizedBox(height: 12),

                      /// NAME
                      Text(
                        name,
                        style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),

                      SizedBox(height: 5),

                      /// EMAIL
                      Text(
                        email,
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.white70,
                        ),
                      ),
                    ],
                  ),
                ),

                SizedBox(height: 20),

                /// POINTS CARD
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 20),
                  child: Container(
                    width: double.infinity,
                    padding: EdgeInsets.all(18),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(15),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.shade200,
                          blurRadius: 8,
                          spreadRadius: 2,
                        )
                      ],
                    ),
                    child: Row(
                      children: [
                        Container(
                          padding: EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            color: Colors.orange.shade50,
                            shape: BoxShape.circle,
                          ),
                          child: Icon(Icons.monetization_on,
                              color: Colors.orange, size: 30),
                        ),
                        SizedBox(width: 15),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Total Points",
                              style: TextStyle(
                                  fontSize: 13, color: Colors.grey),
                            ),
                            Text(
                              "$points pts",
                              style: TextStyle(
                                  fontSize: 22,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),

                SizedBox(height: 20),

                /// INFO CARDS
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 20),
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(15),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.shade200,
                          blurRadius: 8,
                          spreadRadius: 2,
                        )
                      ],
                    ),
                    child: Column(
                      children: [

                        /// NAME ROW
                        _infoTile(
                          icon: Icons.person_outline,
                          iconColor: Colors.green,
                          title: "Name",
                          value: name,
                        ),

                        Divider(height: 1, indent: 20, endIndent: 20),

                        /// EMAIL ROW
                        _infoTile(
                          icon: Icons.email_outlined,
                          iconColor: Colors.blue,
                          title: "Email",
                          value: email,
                        ),

                        Divider(height: 1, indent: 20, endIndent: 20),

                        /// UID ROW
                        _infoTile(
                          icon: Icons.fingerprint,
                          iconColor: Colors.purple,
                          title: "User ID",
                          value: uid.length > 15
                              ? "${uid.substring(0, 15)}..."
                              : uid,
                        ),
                      ],
                    ),
                  ),
                ),

                SizedBox(height: 25),

                /// LOGOUT BUTTON
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 20),
                  child: GestureDetector(
                    onTap: logout,
                    child: Container(
                      height: 52,
                      width: double.infinity,
                      decoration: BoxDecoration(
                        color: Colors.red,
                        borderRadius: BorderRadius.circular(14),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.red.withOpacity(0.3),
                            blurRadius: 8,
                            offset: Offset(0, 4),
                          )
                        ],
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.logout, color: Colors.white),
                          SizedBox(width: 10),
                          Text(
                            "Logout",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),

                SizedBox(height: 30),
              ],
            ),
          );
        },
      ),
    );
  }

  /// INFO TILE WIDGET
  Widget _infoTile({
    required IconData icon,
    required Color iconColor,
    required String title,
    required String value,
  }) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 15, vertical: 12),
      child: Row(
        children: [
          Container(
            padding: EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: iconColor.withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(icon, color: iconColor, size: 22),
          ),
          SizedBox(width: 15),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style:
                TextStyle(fontSize: 12, color: Colors.grey),
              ),
              Text(
                value,
                style: TextStyle(
                    fontSize: 15, fontWeight: FontWeight.w600),
              ),
            ],
          ),
        ],
      ),
    );
  }
}