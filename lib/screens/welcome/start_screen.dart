import 'package:carevive/common%20widgets/round_gradient_button.dart';
import 'package:carevive/screens/auth/login_screen.dart';
import 'package:carevive/utils/app_colors.dart';
import 'package:flutter/material.dart';

class StartScreen extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    var media = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: AppColors.whiteColor,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 25),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.max,
            children: [
              Image.asset("assets/images/welcome_promo.png",
                  width: media.width * 0.75, fit: BoxFit.fitWidth),
              SizedBox(height: media.width * 0.05),
              const Text(
                "Welcome",
                style: TextStyle(
                    color: AppColors.blackColor,
                    fontSize: 23,
                    fontWeight: FontWeight.w700),
              ),
              SizedBox(height: media.width * 0.02),
              const Text(
                "You are all set now, let’s reach your\ngoals together with us",
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: AppColors.grayColor,
                  fontSize: 13,
                  fontFamily: "Poppins",
                  fontWeight: FontWeight.w400,
                ),
              ),
              SizedBox(height: media.width * 0.2),
              RoundGradientButton(
                title: "Get Started",
                onPressed: () {
                  Navigator.push(context, MaterialPageRoute(builder: (context) => LoginScreen(),));
                },
              )
            ],
          ),
        ),
      ),
    );
  }
}
