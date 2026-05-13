import 'package:apprecycle/services/widget_support.dart';
import 'package:flutter/material.dart';
import 'package:apprecycle/pages/login.dart';
class Onboarding extends StatefulWidget {
  const Onboarding({super.key});

  @override
  State<Onboarding> createState() => _OnboardingState();
}

class _OnboardingState extends State<Onboarding> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Container(
        child: Column(
          children: [
            Image.asset("images/img.png"),
            SizedBox(height: 30),
            Padding(
              padding: EdgeInsets.only(left: 20),
              child: Text("Recycle your waste products",
              // style: AppWidget.headlinetextstyle(size),
                style: AppWidget.headlinetextstyle(32.0),
              ),
            ),

        SizedBox(height: 30),
        Padding(
          padding: EdgeInsets.only(left: 20),
 child: Text("Easily collect household waste and generate less waste",
   style: AppWidget.normaltextstyle(17.0),
         ),
          ),


            SizedBox(height: 50,),
            GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => Login()),
                );
              },
              child: Container(
                height: 70,
                width: MediaQuery.of(context).size.width / 2,
                decoration: BoxDecoration(
                  color: Colors.green,
                  borderRadius: BorderRadius.circular(40),
                ),
                child: Center(
                  child: Text(
                    "Get Started",
                    style: AppWidget.whitetextstyle(28.0),
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
