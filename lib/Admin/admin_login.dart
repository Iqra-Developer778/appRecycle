import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'admin_panel.dart'; // apna admin panel page import karo

class AdminLogin extends StatefulWidget {
  const AdminLogin({super.key});

  @override
  State<AdminLogin> createState() => _AdminLoginState();
}

class _AdminLoginState extends State<AdminLogin> {
  TextEditingController usernameController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  bool isLoading = false;
  bool obscurePassword = true;

  /// ✅ Firebase se admin login verify karo
  Future<void> adminLogin() async {
    String username = usernameController.text.trim();
    String password = passwordController.text.trim();

    if (username.isEmpty || password.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Please fill all fields"),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    setState(() => isLoading = true);

    try {
      // ✅ Firestore mein admin collection check karo
      QuerySnapshot adminSnap = await FirebaseFirestore.instance
          .collection("Admin")
          .where("username", isEqualTo: username)
          .where("password", isEqualTo: password)
          .get();

      if (adminSnap.docs.isNotEmpty) {
        // ✅ Admin found — panel pe navigate karo
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => AdminPanel()),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text("Invalid Username or Password"),
            backgroundColor: Colors.red,
          ),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Error: $e"),
          backgroundColor: Colors.red,
        ),
      );
    }

    setState(() => isLoading = false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Column(
          children: [
            /// TOP IMAGE SECTION
            Container(
              width: double.infinity,
              height: 280,
              decoration: BoxDecoration(
                color: Color(0xffE8F5E9),
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(40),
                  bottomRight: Radius.circular(40),
                ),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(height: 40),
                  // ✅ Apni image lagao — assets mein daalo
                  Image.asset(
                    "images/img.png", // apni image path
                    height: 180,
                    fit: BoxFit.contain,
                    errorBuilder: (context, error, stackTrace) => Icon(
                      Icons.admin_panel_settings,
                      size: 100,
                      color: Colors.green,
                    ),
                  ),
                ],
              ),
            ),

            SizedBox(height: 30),

            /// ADMIN LOGIN TEXT
            Text(
              "Admin Login",
              style: TextStyle(
                fontSize: 26,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),

            SizedBox(height: 30),

            /// FORM FIELDS
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 25),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [

                  /// USERNAME
                  Text(
                    "Username",
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                      color: Colors.black87,
                    ),
                  ),
                  SizedBox(height: 8),
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.grey[100],
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: Colors.grey.shade300),
                    ),
                    child: TextField(
                      controller: usernameController,
                      decoration: InputDecoration(
                        hintText: "Enter Username",
                        hintStyle: TextStyle(color: Colors.grey),
                        prefixIcon: Icon(Icons.person_outline,
                            color: Colors.grey),
                        border: InputBorder.none,
                        contentPadding:
                        EdgeInsets.symmetric(vertical: 15),
                      ),
                    ),
                  ),

                  SizedBox(height: 20),

                  /// PASSWORD
                  Text(
                    "Password",
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                      color: Colors.black87,
                    ),
                  ),
                  SizedBox(height: 8),
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.grey[100],
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: Colors.grey.shade300),
                    ),
                    child: TextField(
                      controller: passwordController,
                      obscureText: obscurePassword,
                      decoration: InputDecoration(
                        hintText: "Enter Password",
                        hintStyle: TextStyle(color: Colors.grey),
                        prefixIcon: Icon(Icons.lock_outline,
                            color: Colors.grey),
                        suffixIcon: GestureDetector(
                          onTap: () {
                            setState(() {
                              obscurePassword = !obscurePassword;
                            });
                          },
                          child: Icon(
                            obscurePassword
                                ? Icons.visibility_off
                                : Icons.visibility,
                            color: Colors.grey,
                          ),
                        ),
                        border: InputBorder.none,
                        contentPadding:
                        EdgeInsets.symmetric(vertical: 15),
                      ),
                    ),
                  ),

                  SizedBox(height: 35),

                  /// LOGIN BUTTON
                  GestureDetector(
                    onTap: isLoading ? null : adminLogin,
                    child: Container(
                      height: 52,
                      width: double.infinity,
                      decoration: BoxDecoration(
                        color: Colors.black,
                        borderRadius: BorderRadius.circular(14),
                      ),
                      child: Center(
                        child: isLoading
                            ? CircularProgressIndicator(
                          color: Colors.white,
                          strokeWidth: 2,
                        )
                            : Text(
                          "Login",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ),

                  SizedBox(height: 30),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}