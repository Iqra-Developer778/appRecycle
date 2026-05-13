import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class AiTipsPage extends StatefulWidget {
  const AiTipsPage({super.key});

  @override
  State<AiTipsPage> createState() => _AiTipsPageState();
}

class _AiTipsPageState extends State<AiTipsPage> {
  TextEditingController searchController = TextEditingController();
  String aiResponse = "";
  bool isLoading = false;
  String selectedChip = "";

  // ✅ Quick search chips
  final List<Map<String, dynamic>> quickChips = [
    {"label": "Plastic", "icon": Icons.local_drink},
    {"label": "Paper", "icon": Icons.description},
    {"label": "Glass", "icon": Icons.wine_bar},
    {"label": "Battery", "icon": Icons.battery_full},
    {"label": "E-Waste", "icon": Icons.devices},

  ];

  // ✅ Random eco facts shown at top
  final List<String> ecoFacts = [
    "♻️ Recycling 1 ton of paper saves 17 trees!",
    "🌍 Glass can be recycled endlessly without losing quality.",
    "⚡ Recycling aluminum saves 95% of the energy needed to make new aluminum.",
    "🔋 One battery can contaminate 600 liters of water.",
    "📱 A million phones contain over 16 tons of copper!",
  ];

  int currentFactIndex = 0;

  //  Gemini API Call — FREE API
  //  Get your free key from: https://aistudio.google.com/app/apikey
  final String geminiApiKey = "AIzaSyBT-3LvGCdk_TwtV_YGUDCgWTiOOdVBI_I";

  Future<void> getAITip(String item) async {
    if (item.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Please enter an item name first!"),
          backgroundColor: Colors.orange,
        ),
      );
      return;
    }

    setState(() {
      isLoading = true;
      aiResponse = "";
    });

    try {
      final response = await http.post(

          Uri.parse(
            'https://generativelanguage.googleapis.com/v1/models/gemini-2.5-flash-lite:generateContent?key=$geminiApiKey',
          ),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          "contents": [
            {
              "parts": [
                {
                  "text":
                  "I want to recycle: $item. Please give me:\n1. How to recycle it properly\n2. Environmental benefit\n3. One important tip\nKeep it short, friendly and practical. Use emojis."
                }
              ]
            }
          ],
          "generationConfig": {
            "maxOutputTokens": 300,
            "temperature": 0.7,
          }
        }),
      );

      print(response.body);

      if (response.statusCode == 200) {
        var data = jsonDecode(response.body);
        String result = "";

        if (data['candidates'] != null &&
            data['candidates'].isNotEmpty &&
            data['candidates'][0]['content'] != null) {
          result = data['candidates'][0]['content']['parts'][0]['text'] ?? "";
        } else {
          result = "No response from AI.";
        }
        setState(() {
          aiResponse = result;
          isLoading = false;
        });
      } else {
        setState(() {
          aiResponse =
          " Could not get tips. Please check your API key.\n\nError: ${response.statusCode}";
          isLoading = false;
        });
      }
    } catch (e) {
      setState(() {
        aiResponse = " Network error. Please check your internet connection.\n\nError: $e";
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xffF5F5F5),
      appBar: AppBar(
        title: Text(
          "AI Recycle Tips",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        centerTitle: true,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [

            // ──────────────────────────────────────
            //  ECO FACT CARD
            // ──────────────────────────────────────
            GestureDetector(
              onTap: () {
                setState(() {
                  currentFactIndex =
                      (currentFactIndex + 1) % ecoFacts.length;
                });
              },
              child: Container(
                width: double.infinity,
                padding: EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.green.shade50,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: Colors.green.shade200),
                ),
                child: Row(
                  children: [
                    Container(
                      padding: EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: Colors.green.shade100,
                        shape: BoxShape.circle,
                      ),
                      child: Icon(Icons.eco, color: Colors.green, size: 22),
                    ),
                    SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Did You Know?",
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.green.shade700,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          SizedBox(height: 4),
                          Text(
                            ecoFacts[currentFactIndex],
                            style: TextStyle(
                              fontSize: 13,
                              color: Colors.green.shade900,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Icon(Icons.refresh, color: Colors.green.shade400, size: 18),
                  ],
                ),
              ),
            ),

            SizedBox(height: 20),

            // ──────────────────────────────────────
            // 🤖 AI HEADER
            // ──────────────────────────────────────
            Row(
              children: [
                Container(
                  padding: EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.black,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Icon(Icons.smart_toy, color: Colors.white, size: 20),
                ),
                SizedBox(width: 10),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "AI Recycling Assistant",
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      "Ask how to recycle anything!",
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey,
                      ),
                    ),
                  ],
                ),
              ],
            ),

            SizedBox(height: 16),

            // ──────────────────────────────────────
            // 🔍 SEARCH BAR
            // ──────────────────────────────────────
            Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(14),
                border: Border.all(color: Colors.grey.shade300),
              ),
              child: Row(
                children: [
                  SizedBox(width: 12),
                  Icon(Icons.search, color: Colors.grey),
                  SizedBox(width: 8),
                  Expanded(
                    child: TextField(
                      controller: searchController,
                      decoration: InputDecoration(
                        hintText: "e.g. plastic bottle, old phone...",
                        hintStyle: TextStyle(color: Colors.grey.shade400),
                        border: InputBorder.none,
                        contentPadding: EdgeInsets.symmetric(vertical: 14),
                      ),
                      onSubmitted: (val) {
                        getAITip(val);
                        setState(() => selectedChip = "");
                      },
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      getAITip(searchController.text);
                      setState(() => selectedChip = "");
                    },
                    child: Container(
                      margin: EdgeInsets.all(6),
                      padding:
                      EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                      decoration: BoxDecoration(
                        color: Colors.green,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Text(
                        "Ask AI",
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 13,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),

            SizedBox(height: 16),

            // ──────────────────────────────────────
            // 🏷 QUICK CHIPS
            // ──────────────────────────────────────
            Text(
              "Quick Select:",
              style: TextStyle(
                fontSize: 13,
                color: Colors.grey.shade600,
                fontWeight: FontWeight.w600,
              ),
            ),
            SizedBox(height: 8),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: quickChips.map((chip) {
                bool isSelected = selectedChip == chip["label"];
                return GestureDetector(
                  onTap: () {
                    setState(() {
                      selectedChip = chip["label"];
                      searchController.text = chip["label"];
                    });
                    getAITip(chip["label"]);
                  },
                  child: Container(
                    padding:
                    EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                    decoration: BoxDecoration(
                      color: isSelected ? Colors.green : Colors.white,
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(
                        color:
                        isSelected ? Colors.green : Colors.grey.shade300,
                      ),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          chip["icon"] as IconData,
                          size: 14,
                          color: isSelected ? Colors.white : Colors.grey.shade600,
                        ),
                        SizedBox(width: 6),
                        Text(
                          chip["label"],
                          style: TextStyle(
                            color: isSelected ? Colors.white : Colors.black87,
                            fontSize: 13,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              }).toList(),
            ),

            SizedBox(height: 20),

            // ──────────────────────────────────────
            //  AI RESPONSE CARD
            // ──────────────────────────────────────
            if (isLoading)
              Container(
                width: double.infinity,
                padding: EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: Colors.green.shade100),
                ),
                child: Column(
                  children: [
                    CircularProgressIndicator(color: Colors.green),
                    SizedBox(height: 12),
                    Text(
                      "AI is thinking... 🌱",
                      style: TextStyle(color: Colors.grey),
                    ),
                  ],
                ),
              )
            else if (aiResponse.isNotEmpty)
              Container(
                width: double.infinity,
                padding: EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: Colors.green.shade200),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Header row
                    Row(
                      children: [
                        Container(
                          padding: EdgeInsets.all(6),
                          decoration: BoxDecoration(
                            color: Colors.green.shade50,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Icon(Icons.smart_toy,
                              color: Colors.green, size: 18),
                        ),
                        SizedBox(width: 8),
                        Text(
                          "AI Recycling Tips",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 15,
                            color: Colors.green.shade800,
                          ),
                        ),
                        Spacer(),
                        // Copy button
                        GestureDetector(
                          onTap: () {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text("Tips copied!"),
                                backgroundColor: Colors.green,
                              ),
                            );
                          },
                          child: Icon(Icons.copy,
                              color: Colors.grey.shade400, size: 18),
                        ),
                      ],
                    ),
                    SizedBox(height: 12),
                    Divider(color: Colors.green.shade100, height: 1),
                    SizedBox(height: 12),
                    // AI Response text
                    Text(
                      aiResponse,
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.black87,
                        height: 1.6,
                      ),
                    ),
                    SizedBox(height: 12),
                    // Ask again button
                    GestureDetector(
                      onTap: () {
                        getAITip(searchController.text);
                      },
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(Icons.refresh,
                              color: Colors.green.shade600, size: 16),
                          SizedBox(width: 4),
                          Text(
                            "Get different tips",
                            style: TextStyle(
                              color: Colors.green.shade600,
                              fontSize: 13,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              )
            else
            // ──────────────────────────────────────
            // EMPTY STATE
            // ──────────────────────────────────────
              Container(
                width: double.infinity,
                padding: EdgeInsets.all(30),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: Colors.grey.shade200),
                ),
                child: Column(
                  children: [
                    Icon(Icons.recycling, size: 60, color: Colors.green.shade200),
                    SizedBox(height: 12),
                    Text(
                      "Search anything above!",
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.grey.shade500,
                      ),
                    ),
                    SizedBox(height: 6),
                    Text(
                      "e.g. \"old phone\", \"plastic bag\", \"newspaper\"",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 13,
                        color: Colors.grey.shade400,
                      ),
                    ),
                  ],
                ),
              ),

            SizedBox(height: 30),
          ],
        ),
      ),
    );
  }
}