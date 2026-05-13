import 'package:flutter/material.dart';
import 'admin_approval.dart';
import 'admin_redeem.dart';

class AdminPanel extends StatefulWidget {
  const AdminPanel({super.key});

  @override
  State<AdminPanel> createState() => _AdminPanelState();
}

class _AdminPanelState extends State<AdminPanel> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xffF0F0FA),
      appBar: AppBar(
        title: Text(
          "Home Admin",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        centerTitle: true,
        elevation: 0,
      ),
      body: Padding(
        padding: EdgeInsets.all(20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [

            /// ADMIN APPROVAL CARD
            GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => AdminApproval(),
                  ),
                );
              },
              child: Container(
                width: double.infinity,
                padding: EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.shade200,
                      blurRadius: 10,
                      spreadRadius: 2,
                    ),
                  ],
                ),
                child: Row(
                  children: [
                    /// IMAGE
                    Container(
                      height: 70,
                      width: 70,
                      decoration: BoxDecoration(
                        color: Color(0xffF0F0FA),
                        borderRadius: BorderRadius.circular(15),
                      ),
                      child: Image.asset(
                        "images/admin_approval.png",
                        fit: BoxFit.contain,
                        errorBuilder: (context, error, stackTrace) =>
                            Icon(Icons.approval,
                                size: 40, color: Colors.green),
                      ),
                    ),

                    SizedBox(width: 20),

                    /// TEXT
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Admin",
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                          ),
                        ),
                        Text(
                          "Approval",
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                          ),
                        ),
                      ],
                    ),

                    Spacer(),

                    Icon(Icons.arrow_forward_ios,
                        color: Colors.grey, size: 18),
                  ],
                ),
              ),
            ),

            SizedBox(height: 20),

            /// REDEEM REQUEST CARD
            GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => AdminRedeem(),
                  ),
                );
              },
              child: Container(
                width: double.infinity,
                padding: EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.shade200,
                      blurRadius: 10,
                      spreadRadius: 2,
                    ),
                  ],
                ),
                child: Row(
                  children: [
                    /// IMAGE
                    Container(
                      height: 70,
                      width: 70,
                      decoration: BoxDecoration(
                        color: Color(0xffF0F0FA),
                        borderRadius: BorderRadius.circular(15),
                      ),
                      child: Image.asset(
                        "images/redeem_request.png",
                        fit: BoxFit.contain,
                        errorBuilder: (context, error, stackTrace) =>
                            Icon(Icons.card_giftcard,
                                size: 40, color: Colors.orange),
                      ),
                    ),

                    SizedBox(width: 20),

                    /// TEXT
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Redeem",
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                          ),
                        ),
                        Text(
                          "Request",
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                          ),
                        ),
                      ],
                    ),

                    Spacer(),

                    Icon(Icons.arrow_forward_ios,
                        color: Colors.grey, size: 18),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}