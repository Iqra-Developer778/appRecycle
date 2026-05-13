// // import 'package:flutter/material.dart';
// // import 'package:cloud_firestore/cloud_firestore.dart';
// // import 'package:firebase_auth/firebase_auth.dart';
// // import 'package:fl_chart/fl_chart.dart';
// //
// // class HistoryPage extends StatefulWidget {
// //   const HistoryPage({super.key});
// //
// //   @override
// //   State<HistoryPage> createState() => _HistoryPageState();
// // }
// //
// // class _HistoryPageState extends State<HistoryPage> {
// //   String uid = "";
// //
// //   @override
// //   void initState() {
// //     super.initState();
// //     getUser();
// //   }
// //
// //   Future<void> getUser() async {
// //     User? user = FirebaseAuth.instance.currentUser;
// //     if (user != null) {
// //       setState(() {
// //         uid = user.uid;
// //       });
// //     }
// //   }
// //
// //   @override
// //   Widget build(BuildContext context) {
// //     if (uid.isEmpty) {
// //       return const Scaffold(
// //         body: Center(child: CircularProgressIndicator()),
// //       );
// //     }
// //
// //     return Scaffold(
// //       appBar: AppBar(
// //         title: const Text("History"),
// //         backgroundColor: Colors.green,
// //         centerTitle: true,
// //       ),
// //
// //       body: StreamBuilder<QuerySnapshot>(
// //         stream: FirebaseFirestore.instance
// //             .collection("users")
// //             .doc(uid)
// //             .collection("Items")
// //             .snapshots(),
// //
// //         builder: (context, snapshot) {
// //           if (snapshot.connectionState == ConnectionState.waiting) {
// //             return const Center(child: CircularProgressIndicator());
// //           }
// //
// //           if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
// //             return const Center(
// //               child: Text(
// //                 "No History Found",
// //                 style: TextStyle(fontSize: 16, color: Colors.grey),
// //               ),
// //             );
// //           }
// //
// //           final docs = snapshot.data!.docs;
// //
// //           // 🔥 Extract points for graph
// //           List<BarChartGroupData> barGroups = [];
// //
// //           for (int i = 0; i < docs.length; i++) {
// //             var data = docs[i].data() as Map<String, dynamic>;
// //             int points = (data["Points"] ?? 0);
// //
// //             barGroups.add(
// //               BarChartGroupData(
// //                 x: i,
// //                 barRods: [
// //                   BarChartRodData(
// //                     toY: points.toDouble(),
// //                     width: 16,
// //                   )
// //                 ],
// //               ),
// //             );
// //           }
// //
// //           return Column(
// //             children: [
// //               // 📊 GRAPH SECTION
// //               SizedBox(
// //                 height: 220,
// //                 child: Padding(
// //                   padding: const EdgeInsets.all(12),
// //                   child: BarChart(
// //                     BarChartData(
// //                       barGroups: barGroups,
// //                       titlesData: FlTitlesData(
// //                         leftTitles: AxisTitles(
// //                           sideTitles: SideTitles(  showTitles: true,
// //                             interval: 20, // 👈 THIS controls 0,10,20,30...
// //                             reservedSize: 20, // 👈 space for numbers
// //                             getTitlesWidget: (value, meta) {
// //                               return Text(
// //                                 value.toInt().toString(),
// //                                 style: const TextStyle(
// //                                   fontSize: 12,
// //                                   color: Colors.black,
// //                                 ),
// //                               );
// //                             },
// //                           ),
// //                         ),
// //                         bottomTitles: AxisTitles(
// //                           sideTitles: SideTitles(  showTitles: true,
// //                             interval: 10, // 👈 THIS controls 0,10,20,30...
// //                             reservedSize: 20, // 👈 space for numbers
// //                             getTitlesWidget: (value, meta) {
// //                               return Text(
// //                                 value.toInt().toString(),
// //                                 style: const TextStyle(
// //                                   fontSize: 12,
// //                                   color: Colors.black,
// //                                 ),
// //                               );
// //                             },),
// //                         ),
// //                       ),
// //                       borderData: FlBorderData(show: false),
// //                       gridData: FlGridData(show: false),
// //                     ),
// //                   ),
// //                 ),
// //               ),
// //
// //               const SizedBox(height: 10),
// //
// //               // 📜 LIST SECTION
// //               Expanded(
// //                 child: ListView.builder(
// //                   padding: const EdgeInsets.all(12),
// //                   itemCount: docs.length,
// //                   itemBuilder: (context, index) {
// //                     var data = docs[index].data() as Map<String, dynamic>;
// //
// //                     String category = data["Category"] ?? "";
// //                     int quantity = (data["Quantity"] ?? 0);
// //                     String status = data["Status"] ?? "Pending";
// //                     int points = (data["Points"] ?? 0);
// //
// //                     Color statusColor;
// //
// //                     if (status == "Approved") {
// //                       statusColor = Colors.green;
// //                     } else if (status == "Rejected") {
// //                       statusColor = Colors.red;
// //                     } else {
// //                       statusColor = Colors.orange;
// //                     }
// //
// //                     return Card(
// //                       margin: const EdgeInsets.only(bottom: 12),
// //                       shape: RoundedRectangleBorder(
// //                         borderRadius: BorderRadius.circular(12),
// //                       ),
// //                       child: Padding(
// //                         padding: const EdgeInsets.all(12),
// //                         child: Column(
// //                           crossAxisAlignment: CrossAxisAlignment.start,
// //                           children: [
// //                             Row(
// //                               mainAxisAlignment: MainAxisAlignment.spaceBetween,
// //                               children: [
// //                                 Text(
// //                                   category,
// //                                   style: const TextStyle(
// //                                     fontSize: 18,
// //                                     fontWeight: FontWeight.bold,
// //                                   ),
// //                                 ),
// //                                 Container(
// //                                   padding: const EdgeInsets.symmetric(
// //                                       horizontal: 10, vertical: 5),
// //                                   decoration: BoxDecoration(
// //                                     color: statusColor.withOpacity(0.2),
// //                                     borderRadius: BorderRadius.circular(20),
// //                                   ),
// //                                   child: Text(
// //                                     status,
// //                                     style: TextStyle(
// //                                       color: statusColor,
// //                                       fontWeight: FontWeight.bold,
// //                                     ),
// //                                   ),
// //                                 )
// //                               ],
// //                             ),
// //                             const SizedBox(height: 8),
// //                             Text("Quantity: $quantity"),
// //                             Text("Points: $points"),
// //                           ],
// //                         ),
// //                       ),
// //                     );
// //                   },
// //                 ),
// //               ),
// //             ],
// //           );
// //         },
// //       ),
// //     );
// //   }
// // }
//
// import 'package:flutter/material.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:fl_chart/fl_chart.dart';
//
// class HistoryPage extends StatefulWidget {
//   const HistoryPage({super.key});
//
//   @override
//   State<HistoryPage> createState() => _HistoryPageState();
// }
//
// class _HistoryPageState extends State<HistoryPage> {
//   String uid = "";
//
//   @override
//   void initState() {
//     super.initState();
//     getUser();
//   }
//
//   Future<void> getUser() async {
//     User? user = FirebaseAuth.instance.currentUser;
//     if (user != null) {
//       setState(() {
//         uid = user.uid;
//       });
//     }
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     if (uid.isEmpty) {
//       return const Scaffold(
//         body: Center(child: CircularProgressIndicator()),
//       );
//     }
//
//     return Scaffold(
//       backgroundColor: const Color(0xFFF5F7F6),
//       appBar: AppBar(
//         title: const Text("History"),
//         backgroundColor: Colors.green,
//         centerTitle: true,
//         elevation: 0,
//       ),
//
//       body: StreamBuilder<QuerySnapshot>(
//         stream: FirebaseFirestore.instance
//             .collection("users")
//             .doc(uid)
//             .collection("Items")
//             .snapshots(),
//         builder: (context, snapshot) {
//
//           if (snapshot.connectionState == ConnectionState.waiting) {
//             return const Center(child: CircularProgressIndicator());
//           }
//
//           if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
//             return const Center(
//               child: Text(
//                 "No History Found",
//                 style: TextStyle(fontSize: 16, color: Colors.grey),
//               ),
//             );
//           }
//
//           final docs = snapshot.data!.docs;
//
//           /// 🔥 GRAPH DATA
//           List<BarChartGroupData> barGroups = [];
//
//           for (int i = 0; i < docs.length; i++) {
//             var data = docs[i].data() as Map<String, dynamic>;
//             int points = (data["Points"] ?? 0);
//
//             barGroups.add(
//               BarChartGroupData(
//                 x: i,
//                 barRods: [
//                   BarChartRodData(
//                     toY: points.toDouble(),
//                     width: 14,
//                     borderRadius: BorderRadius.circular(12),
//                     gradient: LinearGradient(
//                       colors: [
//                         Colors.green.shade700,
//                         Colors.green.shade300,
//                       ],
//                       begin: Alignment.bottomCenter,
//                       end: Alignment.topCenter,
//                     ),
//                   )
//                 ],
//               ),
//             );
//           }
//
//           double maxY = barGroups.isEmpty
//               ? 10
//               : barGroups
//               .map((e) => e.barRods.first.toY)
//               .reduce((a, b) => a > b ? a : b) +
//               10;
//
//           return Column(
//             children: [
//
//               /// 📊 STYLISH GRAPH CARD
//               Container(
//                 margin: const EdgeInsets.all(12),
//                 padding: const EdgeInsets.all(12),
//                 decoration: BoxDecoration(
//                   color: Colors.white,
//                   borderRadius: BorderRadius.circular(16),
//                   boxShadow: [
//                     BoxShadow(
//                       color: Colors.grey.withOpacity(0.08),
//                       blurRadius: 10,
//                       spreadRadius: 2,
//                     )
//                   ],
//                 ),
//                 child: SizedBox(
//                   height: 230,
//                   child: BarChart(
//                     BarChartData(
//                       alignment: BarChartAlignment.spaceEvenly,
//                       maxY: maxY,
//
//                       gridData: FlGridData(
//                         show: true,
//                         drawVerticalLine: false,
//                         horizontalInterval: maxY <= 20 ? 5 : 10,
//                         getDrawingHorizontalLine: (value) {
//                           return FlLine(
//                             color: Colors.green.withOpacity(0.08),
//                             strokeWidth: 1,
//                           );
//                         },
//                       ),
//
//                       borderData: FlBorderData(show: false),
//
//                       titlesData: FlTitlesData(
//                         leftTitles: AxisTitles(
//                           sideTitles: SideTitles(
//                             showTitles: true,
//                             reservedSize: 28,
//                             interval: maxY <= 20 ? 5 : 10,
//                             getTitlesWidget: (value, meta) {
//                               return Text(
//                                 value.toInt().toString(),
//                                 style: TextStyle(
//                                   fontSize: 10,
//                                   color: Colors.grey.shade500,
//                                 ),
//                               );
//                             },
//                           ),
//                         ),
//
//                         bottomTitles: AxisTitles(
//                           sideTitles: SideTitles(
//                             showTitles: true,
//                             reservedSize: 28,
//                             getTitlesWidget: (value, meta) {
//                               return Padding(
//                                 padding: const EdgeInsets.only(top: 6),
//                                 child: Text(
//                                   "${value.toInt() + 1}",
//                                   style: TextStyle(
//                                     fontSize: 10,
//                                     color: Colors.grey.shade500,
//                                   ),
//                                 ),
//                               );
//                             },
//                           ),
//                         ),
//
//                         topTitles: const AxisTitles(
//                           sideTitles: SideTitles(showTitles: false),
//                         ),
//                         rightTitles: const AxisTitles(
//                           sideTitles: SideTitles(showTitles: false),
//                         ),
//                       ),
//
//                       barGroups: barGroups,
//
//                       barTouchData: BarTouchData(
//                         enabled: true,
//                         touchTooltipData: BarTouchTooltipData(
//                           tooltipRoundedRadius: 12,
//                           tooltipPadding: const EdgeInsets.all(8),
//                           tooltipMargin: 8,
//                           getTooltipItem:
//                               (group, groupIndex, rod, rodIndex) {
//                             return BarTooltipItem(
//                               "${rod.toY.toInt()} pts",
//                               const TextStyle(
//                                 color: Colors.white,
//                                 fontWeight: FontWeight.w600,
//                               ),
//                             );
//                           },
//                         ),
//                       ),
//                     ),
//                   ),
//                 ),
//               ),
//
//               /// 📜 HISTORY LIST
//               Expanded(
//                 child: ListView.builder(
//                   padding: const EdgeInsets.all(12),
//                   itemCount: docs.length,
//                   itemBuilder: (context, index) {
//
//                     var data = docs[index].data() as Map<String, dynamic>;
//
//                     String category = data["Category"] ?? "";
//                     int quantity = (data["Quantity"] ?? 0);
//                     String status = data["Status"] ?? "Pending";
//                     int points = (data["Points"] ?? 0);
//
//                     Color statusColor;
//
//                     if (status == "Approved") {
//                       statusColor = Colors.green;
//                     } else if (status == "Rejected") {
//                       statusColor = Colors.red;
//                     } else {
//                       statusColor = Colors.orange;
//                     }
//
//                     return Container(
//                       margin: const EdgeInsets.only(bottom: 12),
//                       padding: const EdgeInsets.all(14),
//                       decoration: BoxDecoration(
//                         color: Colors.white,
//                         borderRadius: BorderRadius.circular(14),
//                         boxShadow: [
//                           BoxShadow(
//                             color: Colors.grey.withOpacity(0.08),
//                             blurRadius: 8,
//                           )
//                         ],
//                       ),
//                       child: Column(
//                         crossAxisAlignment: CrossAxisAlignment.start,
//                         children: [
//
//                           Row(
//                             mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                             children: [
//                               Text(
//                                 category,
//                                 style: const TextStyle(
//                                   fontSize: 17,
//                                   fontWeight: FontWeight.bold,
//                                 ),
//                               ),
//                               Container(
//                                 padding: const EdgeInsets.symmetric(
//                                     horizontal: 10, vertical: 5),
//                                 decoration: BoxDecoration(
//                                   color: statusColor.withOpacity(0.15),
//                                   borderRadius: BorderRadius.circular(20),
//                                 ),
//                                 child: Text(
//                                   status,
//                                   style: TextStyle(
//                                     color: statusColor,
//                                     fontWeight: FontWeight.bold,
//                                   ),
//                                 ),
//                               )
//                             ],
//                           ),
//
//                           const SizedBox(height: 10),
//
//                           Row(
//                             children: [
//                               Icon(Icons.scale,
//                                   size: 16, color: Colors.grey),
//                               SizedBox(width: 6),
//                               Text("Quantity: $quantity"),
//                             ],
//                           ),
//
//                           const SizedBox(height: 4),
//
//                           Row(
//                             children: [
//                               Icon(Icons.star,
//                                   size: 16, color: Colors.amber),
//                               SizedBox(width: 6),
//                               Text("Points: $points"),
//                             ],
//                           ),
//                         ],
//                       ),
//                     );
//                   },
//                 ),
//               ),
//             ],
//           );
//         },
//       ),
//     );
//   }
// }



import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fl_chart/fl_chart.dart';

class HistoryPage extends StatefulWidget {
  const HistoryPage({super.key});

  @override
  State<HistoryPage> createState() => _HistoryPageState();
}

class _HistoryPageState extends State<HistoryPage> {
  String uid = "";

  @override
  void initState() {
    super.initState();
    getUser();
  }

  Future<void> getUser() async {
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      setState(() {
        uid = user.uid;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (uid.isEmpty) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    return Scaffold(
      backgroundColor: const Color(0xFFF5F7F6),
      appBar: AppBar(
        title: const Text("History"),
        backgroundColor: Colors.green,
        centerTitle: true,
        elevation: 0,
      ),

      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection("users")
            .doc(uid)
            .collection("Items")
            .snapshots(),
        builder: (context, snapshot) {

          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return const Center(
              child: Text(
                "No History Found",
                style: TextStyle(fontSize: 16, color: Colors.grey),
              ),
            );
          }

          final docs = snapshot.data!.docs;

          /// 🔥 GRAPH DATA
          List<BarChartGroupData> barGroups = [];

          for (int i = 0; i < docs.length; i++) {
            var data = docs[i].data() as Map<String, dynamic>;
            int points = (data["Points"] ?? 0);

            barGroups.add(
              BarChartGroupData(
                x: i,
                barRods: [
                  BarChartRodData(
                    toY: points.toDouble(),
                    width: 14,
                    borderRadius: BorderRadius.circular(10),
                    gradient: LinearGradient(
                      colors: [
                        Colors.green.shade700,
                        Colors.green.shade300,
                      ],
                      begin: Alignment.bottomCenter,
                      end: Alignment.topCenter,
                    ),
                  )
                ],
              ),
            );
          }

          /// 🔥 FIX: scaling for large values
          double maxPoints = barGroups.isEmpty
              ? 100
              : barGroups
              .map((e) => e.barRods.first.toY)
              .reduce((a, b) => a > b ? a : b);

          double roundedMax = ((maxPoints / 100).ceil()) * 100;
          double interval = roundedMax <= 500 ? 100 : 200;

          return Column(
            children: [

              /// 📊 GRAPH
              Container(
                margin: const EdgeInsets.all(12),
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.08),
                      blurRadius: 10,
                    )
                  ],
                ),

                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: SizedBox(
                    width: barGroups.length * 50,
                    height: 230,

                    child: BarChart(
                      BarChartData(
                        alignment: BarChartAlignment.start,
                        maxY: roundedMax,

                        gridData: FlGridData(
                          show: true,
                          drawVerticalLine: false,
                          horizontalInterval: interval,
                          getDrawingHorizontalLine: (value) {
                            return FlLine(
                              color: Colors.green.withOpacity(0.08),
                              strokeWidth: 1,
                            );
                          },
                        ),

                        borderData: FlBorderData(show: false),

                        titlesData: FlTitlesData(
                          leftTitles: AxisTitles(
                            sideTitles: SideTitles(
                              showTitles: true,
                              reservedSize: 35,
                              interval: interval,
                              getTitlesWidget: (value, meta) {
                                return Text(
                                  value.toInt().toString(),
                                  style: TextStyle(
                                    fontSize: 10,
                                    color: Colors.grey.shade500,
                                  ),
                                );
                              },
                            ),
                          ),

                          bottomTitles: AxisTitles(
                            sideTitles: SideTitles(
                              showTitles: true,
                              reservedSize: 28,
                              getTitlesWidget: (value, meta) {
                                return Padding(
                                  padding: const EdgeInsets.only(top: 6),
                                  child: Text(
                                    "${value.toInt() + 1}",
                                    style: TextStyle(
                                      fontSize: 10,
                                      color: Colors.grey.shade500,
                                    ),
                                  ),
                                );
                              },
                            ),
                          ),

                          topTitles: const AxisTitles(
                            sideTitles: SideTitles(showTitles: false),
                          ),
                          rightTitles: const AxisTitles(
                            sideTitles: SideTitles(showTitles: false),
                          ),
                        ),

                        barGroups: barGroups,

                        barTouchData: BarTouchData(
                          enabled: true,
                          touchTooltipData: BarTouchTooltipData(
                            tooltipRoundedRadius: 12,
                            getTooltipItem:
                                (group, groupIndex, rod, rodIndex) {
                              return BarTooltipItem(
                                "${rod.toY.toInt()} pts",
                                const TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                ),
                              );
                            },
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),

              /// 📜 HISTORY LIST
              Expanded(
                child: ListView.builder(
                  padding: const EdgeInsets.all(12),
                  itemCount: docs.length,
                  itemBuilder: (context, index) {

                    var data = docs[index].data() as Map<String, dynamic>;

                    String category = data["Category"] ?? "";
                    int quantity = (data["Quantity"] ?? 0);
                    String status = data["Status"] ?? "Pending";
                    int points = (data["Points"] ?? 0);

                    Color statusColor;

                    if (status == "Approved") {
                      statusColor = Colors.green;
                    } else if (status == "Rejected") {
                      statusColor = Colors.red;
                    } else {
                      statusColor = Colors.orange;
                    }

                    return Container(
                      margin: const EdgeInsets.only(bottom: 12),
                      padding: const EdgeInsets.all(14),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(14),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.08),
                            blurRadius: 8,
                          )
                        ],
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [

                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                category,
                                style: const TextStyle(
                                  fontSize: 17,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Container(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 10, vertical: 5),
                                decoration: BoxDecoration(
                                  color: statusColor.withOpacity(0.15),
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                child: Text(
                                  status,
                                  style: TextStyle(
                                    color: statusColor,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              )
                            ],
                          ),

                          const SizedBox(height: 10),

                          Row(
                            children: [
                              Icon(Icons.scale, size: 16, color: Colors.grey),
                              SizedBox(width: 6),
                              Text("Quantity: $quantity"),
                            ],
                          ),

                          const SizedBox(height: 4),

                          Row(
                            children: [
                              Icon(Icons.star, size: 16, color: Colors.amber),
                              SizedBox(width: 6),
                              Text("Points: $points"),
                            ],
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}