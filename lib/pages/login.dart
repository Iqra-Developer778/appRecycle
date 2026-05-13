import 'package:flutter/material.dart';
import 'package:apprecycle/services/auth.dart';

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center, // center content
              children: [

                // ── Top Image ──
                Image.asset(
                  "images/img.png",
                  height: 230,
                ),

                const SizedBox(height: 20),

                // ── Middle Content ──
                Column(
                  children: const [
                    Icon(
                      Icons.recycling,
                      size: 70,
                      color: Colors.green,
                    ),
                    SizedBox(height: 10),
                    Text(
                      "Reduce. Reuse. Recycle.\nRepeat!",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 26,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 10),
                    Text(
                      "Every item you recycle\nmakes a difference!",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.grey,
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 40),

                // ── Get Started Button ──
                SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: ElevatedButton(
                    onPressed: () {
                      // Navigate to next screen
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green,
                    ),
                    child: const Text(
                      "Get Started",
                      style: TextStyle(fontSize: 16),
                    ),
                  ),
                ),

                const SizedBox(height: 40),

                // ── Google Sign-In Button ──
                SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: OutlinedButton(
                    onPressed: () async {
                      await AuthMethods().signInWithGoogle(context);
                    },
                    style: OutlinedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(horizontal: 12),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min, // important to prevent overflow
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Image.network(
                          "https://cdn-icons-png.flaticon.com/512/281/281764.png",
                          height: 22,
                        ),
                        const SizedBox(width: 10),
                        Flexible(
                          child: Text(
                            "Sign in with Google",
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(fontSize: 16),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                const SizedBox(height: 20),
              ],
            ),
          ),
        ),
      ),
    );
  }
}