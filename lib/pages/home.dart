import 'package:apprecycle/pages/upload_item.dart';
import 'package:apprecycle/services/shared_preference.dart';
import 'package:apprecycle/services/widget_support.dart';
import 'package:flutter/material.dart';
import 'package:apprecycle/Admin//admin_login.dart';
import 'package:apprecycle/services/database.dart'; // aapki DatabaseMethod file
import 'package:cloud_firestore/cloud_firestore.dart';
class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {

  String? id;

  getUser() async{
    id = await SharedPreferenceHelper().getUserId();
    print("🔴 USER ID: $id");
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    getUser();
  }

  /// CATEGORY WIDGET
  Widget buildCategory(String name,String image){

    return GestureDetector(

      onTap: (){
        Navigator.push(
          context,
          MaterialPageRoute(
            builder:(context)=> UploadItem(
              category: name,
              id: id ?? "",
            ),
          ),
        );
      },

      child: Column(
        children: [

          Container(
            padding: EdgeInsets.all(8),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: Colors.black),
            ),

            child: ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: Image.asset(
                image,
                height: 90,
                width: 90,
                fit: BoxFit.cover,
              ),
            ),
          ),

          SizedBox(height:5),

          Text(
            name,
            style: AppWidget.normaltextstyle(15),
          )

        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(

      backgroundColor: Colors.white,

      body: SingleChildScrollView(

        child: Container(

          margin: EdgeInsets.only(top: 20,left: 20),

          child: Column(

            crossAxisAlignment: CrossAxisAlignment.start,

            children: [

              /// HEADER
              Row(
                children: [

                  Image.asset(
                    "images/img_2.png",
                    height:40,
                    width:40,
                  ),

                  SizedBox(width:5),

                  Text("Hello ",
                      style: AppWidget.normaltextstyle(26)),

                  Text("User",
                      style: AppWidget.greentextstyle(26)),

                  Spacer(),

                  Padding(
                    padding: const EdgeInsets.only(right: 20),
                    child: GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => AdminLogin(),
                          ),
                        );
                      },
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(10),
                        child: Image.asset(
                          "images/img_1.png",
                          height: 50,
                          width: 50,
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                  ),

                ],
              ),

              SizedBox(height:10),

              /// BANNER
              Center(
                child: Padding(
                  padding: const EdgeInsets.only(right:20),
                  child: Container(

                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.black,width:3),
                      borderRadius: BorderRadius.circular(20),
                    ),

                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(20),
                      child: Image.asset(
                        "images/trash.jpg",
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                ),
              ),

              SizedBox(height:10),

              /// CATEGORY TITLE
              Text(
                "Categories",
                style: AppWidget.headlinetextstyle(22),
              ),

              SizedBox(height:10),

              /// CATEGORY LIST
              SizedBox(

                height:150,

                child: ListView(

                  scrollDirection: Axis.horizontal,

                  children: [

                    buildCategory("Plastic","images/img_4.png"),

                    SizedBox(width:15),

                    buildCategory("Paper","images/img_3.png"),

                    SizedBox(width:15),

                    buildCategory("Glass","images/img_5.png"),

                    SizedBox(width:15),

                    buildCategory("Battery","images/img_6.png"),

                    SizedBox(width:15),

                    buildCategory("E-Waste","images/img_9.png"),

                  ],
                ),
              ),

              SizedBox(height:10),

              /// PENDING REQUEST TITLE
              Text(
                "Pending Request",
                style: AppWidget.normaltextstyle(22),
              ),

              SizedBox(height:15),

              /// SAMPLE CARD
              /// PENDING REQUESTS TITLE


              id == null
                  ? Center(child: CircularProgressIndicator())
                  : StreamBuilder<QuerySnapshot>(
                stream: DatabaseMethod().getUserPendingRequests(id!),
                builder: (context, snapshot) {

                  // Loading
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(child: CircularProgressIndicator());
                  }

                  // Empty
                  if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                    return Center(
                      child: Padding(
                        padding: const EdgeInsets.all(20),
                        child: Text(
                          "No Pending Request",
                          style: AppWidget.normaltextstyle(16),
                        ),
                      ),
                    );
                  }

                  // Items List
                  return ListView.builder(
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    itemCount: snapshot.data!.docs.length,
                    itemBuilder: (context, index) {
                      Map<String, dynamic> item =
                      snapshot.data!.docs[index].data() as Map<String, dynamic>;

                      return Container(
                        margin: EdgeInsets.only(right: 20, bottom: 15),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(color: Colors.black, width: 1.5),
                        ),
                        child: Column(
                          children: [
                            SizedBox(height: 10),

                            // Location
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(Icons.location_on, color: Colors.green, size: 30),
                                SizedBox(width: 10),
                                Flexible(
                                  child: Text(
                                    item["Address"] ?? "Address not",
                                    style: AppWidget.normaltextstyle(17),
                                  ),
                                ),
                              ],
                            ),

                            Divider(),

                            // Image
                            item["Image"] != null
                                ? ClipRRect(
                              borderRadius: BorderRadius.circular(10),
                              child: Image.network(
                                item["Image"],
                                height: 120,
                                width: 120,
                                fit: BoxFit.cover,
                                errorBuilder: (_, __, ___) => Image.asset(
                                  "images/trash.jpg",
                                  height: 120,
                                  width: 120,
                                ),
                              ),
                            )
                                : Image.asset(
                              "images/trash.jpg",
                              height: 120,
                              width: 120,
                            ),

                            SizedBox(height: 10),

                            // Category
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(Icons.category, color: Colors.green, size: 25),
                                SizedBox(width: 10),
                                Text(
                                  item["Category"] ?? "",
                                  style: AppWidget.normaltextstyle(18),
                                ),
                              ],
                            ),

                            SizedBox(height: 6),

                            // Quantity
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(Icons.layers, color: Colors.green, size: 30),
                                SizedBox(width: 10),
                                Text(
                                  item["Quantity"]?.toString() ?? "0",
                                  style: AppWidget.normaltextstyle(24),
                                ),
                              ],
                            ),

                            SizedBox(height: 10),

                            // Status Badge
                            Container(
                              padding: EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                              decoration: BoxDecoration(
                                color: Colors.orange.shade100,
                                borderRadius: BorderRadius.circular(20),
                                border: Border.all(color: Colors.orange),
                              ),
                              child: Text(
                                "Pending",
                                style: TextStyle(
                                  color: Colors.orange,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),

                            SizedBox(height: 10),
                          ],
                        ),
                      );
                    },
                  );
                },
              ),

            ],
          ),
        ),
      ),
    );
  }
}