import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:apprecycle/services/shared_preference.dart';
import 'package:apprecycle/services/database.dart';
import 'package:random_string/random_string.dart';
import 'package:firebase_auth/firebase_auth.dart';

class UploadItem extends StatefulWidget {

  final String category;
  final String id;

  const UploadItem({
    super.key,
    required this.category,
    required this.id
  });

  @override
  State<UploadItem> createState() => _UploadItemState();
}

class _UploadItemState extends State<UploadItem> {

  TextEditingController addressController = TextEditingController();
  TextEditingController quantityController = TextEditingController();

  String? id;
  String? name;

  File? selectedImage;

  final ImagePicker picker = ImagePicker();

  /// GET USER DATA
  getUserData() async {

    id = await SharedPreferenceHelper().getUserId();
    name = await SharedPreferenceHelper().getUserName();

    if(id == null){

      id = FirebaseAuth.instance.currentUser?.uid;
      name = FirebaseAuth.instance.currentUser?.displayName;

    }

    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    getUserData();
  }

  /// IMAGE PICKER
  Future getImage() async {

    final XFile? pickedFile =
    await picker.pickImage(source: ImageSource.gallery);

    if(pickedFile != null){

      setState(() {

        selectedImage = File(pickedFile.path);

      });

    }

  }

  /// UPLOAD ITEM FUNCTION
  uploadItem() async {

    if(addressController.text.isEmpty ||
        quantityController.text.isEmpty){

      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Please fill all fields")));

      return;
    }

    String itemId = randomAlphaNumeric(10);

    Map<String,dynamic> addItem = {

      "Image": "",

      "Address": addressController.text,

      "Quantity": int.parse(quantityController.text),

      "UserId": id,

      "UserName": name,

      "Category": widget.category,

      "Status":"Pending",

      "Points":0

    };

    /// USER ITEMS
    await DatabaseMethod()
        .addUserUploadItem(addItem, id!, itemId);

    /// ADMIN REQUEST
    await DatabaseMethod()
        .addAdminItem(addItem, itemId);

    ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Item Uploaded Successfully")));

    setState(() {

      selectedImage = null;

    });

    addressController.clear();
    quantityController.clear();

  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(

      backgroundColor: Colors.white,

      body: Column(

        children: [

          SizedBox(height:50),

          /// TOP BAR
          Padding(

            padding: const EdgeInsets.symmetric(horizontal:16),

            child: Row(

              children: [

                GestureDetector(

                  onTap: (){
                    Navigator.pop(context);
                  },

                  child: Container(

                    padding: EdgeInsets.all(6),

                    decoration: BoxDecoration(

                      color: Colors.black,
                      borderRadius: BorderRadius.circular(20),

                    ),

                    child: Icon(Icons.arrow_back_ios_new,
                        color: Colors.white,size:18),

                  ),
                ),

                SizedBox(width:20),

                Text(
                  "Upload ${widget.category}",
                  style: TextStyle(
                      fontSize:20,
                      fontWeight: FontWeight.bold),
                )

              ],
            ),
          ),

          SizedBox(height:20),

          /// MAIN CONTAINER
          Expanded(

            child: Container(

              width: double.infinity,

              decoration: BoxDecoration(

                color: Color(0xffE9E9F9),

                borderRadius: BorderRadius.only(

                  topLeft: Radius.circular(30),
                  topRight: Radius.circular(30),

                ),

              ),

              child: SingleChildScrollView(

                child: Padding(

                  padding: EdgeInsets.all(20),

                  child: Column(

                    crossAxisAlignment: CrossAxisAlignment.start,

                    children: [

                      /// CATEGORY
                      Center(
                        child: Text(
                          "Category : ${widget.category}",
                          style: TextStyle(
                              fontSize:20,
                              fontWeight: FontWeight.bold),
                        ),
                      ),

                      SizedBox(height:20),

                      /// IMAGE PICKER
                      Center(

                        child: GestureDetector(

                          onTap: (){
                            getImage();
                          },

                          child: Container(

                            height:140,
                            width:140,

                            decoration: BoxDecoration(

                              color: Colors.grey[300],
                              borderRadius: BorderRadius.circular(15),

                            ),

                            child: selectedImage == null
                                ? Icon(Icons.camera_alt_outlined,size:40)
                                : ClipRRect(

                              borderRadius: BorderRadius.circular(15),

                              child: Image.file(
                                selectedImage!,
                                fit: BoxFit.cover,
                              ),

                            ),

                          ),
                        ),
                      ),

                      SizedBox(height:30),

                      /// ADDRESS
                      Text("Enter Pickup Address"),

                      SizedBox(height:10),

                      Container(

                        padding: EdgeInsets.symmetric(horizontal:12),

                        decoration: BoxDecoration(

                          color: Colors.white,
                          borderRadius: BorderRadius.circular(10),

                        ),

                        child: TextField(

                          controller: addressController,

                          decoration: InputDecoration(

                            border: InputBorder.none,

                            icon: Icon(Icons.location_on,
                                color: Colors.green),

                            hintText: "Enter Address",

                          ),
                        ),
                      ),

                      SizedBox(height:20),

                      /// QUANTITY
                      Text("Enter Quantity"),

                      SizedBox(height:10),

                      Container(

                        padding: EdgeInsets.symmetric(horizontal:12),

                        decoration: BoxDecoration(

                          color: Colors.white,
                          borderRadius: BorderRadius.circular(10),

                        ),

                        child: TextField(

                          controller: quantityController,

                          keyboardType: TextInputType.number,

                          decoration: InputDecoration(

                            border: InputBorder.none,

                            icon: Icon(Icons.inventory_2,
                                color: Colors.green),

                            hintText: "Enter Quantity",

                          ),
                        ),
                      ),

                      SizedBox(height:30),

                      /// UPLOAD BUTTON
                      GestureDetector(

                        onTap: (){
                          uploadItem();
                        },

                        child: Container(

                          height:50,
                          width: double.infinity,

                          decoration: BoxDecoration(

                            color: Colors.green,
                            borderRadius: BorderRadius.circular(12),

                          ),

                          child: Center(

                            child: Text(

                              "Upload",

                              style: TextStyle(

                                  color: Colors.white,
                                  fontSize:18,
                                  fontWeight: FontWeight.bold),

                            ),
                          ),
                        ),
                      ),

                      SizedBox(height:20)

                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}