import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:apprecycle/services/database.dart';

class AdminApproval extends StatefulWidget {
  const AdminApproval({super.key});

  @override
  State<AdminApproval> createState() => _AdminApprovalState();
}

class _AdminApprovalState extends State<AdminApproval> {

  Stream<QuerySnapshot>? approvalStream;

  @override
  void initState() {
    super.initState();
    approvalStream = DatabaseMethod().getAdminApproval();
  }

  /// POINTS CALCULATION
  int calculatePoints(String category,int quantity){

    int perItemPoints = 0;

    switch(category){

      case "Plastic":
        perItemPoints = 10;
        break;

      case "Glass":
        perItemPoints = 8;
        break;

      case "Paper":
        perItemPoints = 5;
        break;

      case "Battery":
        perItemPoints = 15;
        break;

      case "E-Waste":
        perItemPoints = 20;
        break;

      default:
        perItemPoints = 2;
    }

    return perItemPoints * quantity;
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(

      appBar: AppBar(
        title: Text("Admin Approval"),
        backgroundColor: Colors.green,
        centerTitle: true,
      ),

      body: StreamBuilder<QuerySnapshot>(

        stream: approvalStream,

        builder: (context,snapshot){

          if(!snapshot.hasData){
            return Center(child:CircularProgressIndicator());
          }

          if(snapshot.data!.docs.isEmpty){
            return Center(child:Text("No Pending Requests"));
          }

          return ListView.builder(

            itemCount: snapshot.data!.docs.length,

            itemBuilder: (context,index){

              var ds = snapshot.data!.docs[index];

              String category = ds["Category"];
              int quantity = ds["Quantity"];
              String userId = ds["UserId"];
              String itemId = ds.id;

              int itemPoints =
              calculatePoints(category, quantity);

              return Card(

                margin: EdgeInsets.all(10),

                child: ListTile(

                  title: Text(category),

                  subtitle: Text("Quantity : $quantity"),

                  trailing: ElevatedButton(

                    style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.green),

                    child: Text("Approve"),

                    onPressed: () async {

                      await DatabaseMethod().updateAdminRequestWithPoints(itemId, itemPoints);
                      await DatabaseMethod().incrementUserPoints(userId, itemPoints);

                      await FirebaseFirestore.instance
                          .collection("users")
                          .doc(userId)
                          .collection("Items")
                          .doc(itemId)
                          .update({

                        "Status":"Approved",
                        "Points":itemPoints

                      });

                      ScaffoldMessenger.of(context)
                          .showSnackBar(

                        SnackBar(
                            content: Text(
                                "$category Approved & $itemPoints Points Added")),

                      );

                    },

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