import 'package:cloud_firestore/cloud_firestore.dart';

class DatabaseMethod {

  Future addUserInfo(Map<String, dynamic> userInfoMap, String id) async {
    return await FirebaseFirestore.instance
        .collection("users")
        .doc(id)
        .set(userInfoMap, SetOptions(merge: true));
  }

  Future addUserUploadItem(
      Map<String, dynamic> userInfoMap, String id, String itemId) async {
    return await FirebaseFirestore.instance
        .collection("users")
        .doc(id)
        .collection("Items")
        .doc(itemId)
        .set(userInfoMap);
  }

  Future<void> addAdminItem(
      Map<String, dynamic> userInfoMap, String id) async {
    return await FirebaseFirestore.instance
        .collection("Requests")
        .doc(id)
        .set(userInfoMap);
  }

  Stream<QuerySnapshot> getAdminApproval() {
    return FirebaseFirestore.instance
        .collection("Requests")
        .where("Status", isEqualTo: "Pending")
        .snapshots();
  }

  Stream<QuerySnapshot> getUserPendingRequests(String id) {
    return FirebaseFirestore.instance
        .collection("users")
          .doc(id)
           .collection("Items")
        .where("Status", isEqualTo: "Pending")
        .snapshots();
  }

  Future<void> updateAdminRequestWithPoints(
      String requestId, int points) async {
    return await FirebaseFirestore.instance
        .collection("Requests")
        .doc(requestId)
        .update({
      "Status": "Approved",
      "Points": points,
    });
  }

  // ✅ Transaction hataya — simple get + update, num cast safe hai
  Future<void> incrementUserPoints(String userId, int pointsToAdd) async {
    DocumentReference userRef =
    FirebaseFirestore.instance.collection("users").doc(userId);

    DocumentSnapshot snapshot = await userRef.get();

    if (!snapshot.exists) {
      // Document nahi hai to Points field set karo
      await userRef.set({"Points": pointsToAdd}, SetOptions(merge: true));
      return;
    }

    Map<String, dynamic> data = snapshot.data() as Map<String, dynamic>;

    // ✅ num.toInt() — int ya double dono safely handle karta hai
    int currentPoints = ((data["Points"] ?? 0) as num).toInt();
    int updatedPoints = currentPoints + pointsToAdd;

    await userRef.update({"Points": updatedPoints});
  }

  Future updateUserRequest(String userId, String itemId) async {
    return await FirebaseFirestore.instance
        .collection("users")
        .doc(userId)
        .collection("Items")
        .doc(itemId)
        .update({"Status": "Approved"});
  }

  Stream<QuerySnapshot> getAdminRedeemRequests() {
    return FirebaseFirestore.instance
        .collection("Redeem")
        .where("Status", isEqualTo: "Pending")
        .snapshots();
  }

  // ✅ Transaction hataya — simple get + update
  Future updateAdminRedeemRequest(String redeemId) async {
    DocumentSnapshot redeemDoc = await FirebaseFirestore.instance
        .collection("Redeem")
        .doc(redeemId)
        .get();

    if (!redeemDoc.exists) throw Exception("Redeem document not found");

    Map<String, dynamic> data = redeemDoc.data() as Map<String, dynamic>;
    String userId = data["UserId"] ?? "";
    int points = ((data["Points"] ?? 0) as num).toInt();

    // Admin Redeem → Approved
    await FirebaseFirestore.instance
        .collection("Redeem")
        .doc(redeemId)
        .update({"Status": "Approved"});

    if (userId.isNotEmpty) {
      // User subcollection Redeem → Approved
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

      // ✅ Points deduct — simple get + update
      if (points > 0) {
        DocumentReference userRef =
        FirebaseFirestore.instance.collection("users").doc(userId);

        DocumentSnapshot userSnap = await userRef.get();

        if (userSnap.exists) {
          Map<String, dynamic> userData =
          userSnap.data() as Map<String, dynamic>;
          int currentPoints = ((userData["Points"] ?? 0) as num).toInt();
          int updated = (currentPoints - points).clamp(0, 999999);
          await userRef.update({"Points": updated});
        }
      }
    }
  }

  Future addAdminRedeemPoints(
      Map<String, dynamic> data, String userId, String redeemId) async {
    return await FirebaseFirestore.instance
        .collection("Redeem")
        .doc(redeemId)
        .set(data);
  }

  Future addUserRedeemRequest(
      Map<String, dynamic> data, String userId, String redeemId) async {
    return await FirebaseFirestore.instance
        .collection("users")
        .doc(userId)
        .collection("Redeem")
        .doc(redeemId)
        .set(data);
  }

  Stream<QuerySnapshot> getUserRedeemHistory(String userId) {
    return FirebaseFirestore.instance
        .collection("users")
        .doc(userId)
        .collection("Redeem")
        .orderBy("Time", descending: true)
        .snapshots();
  }
}