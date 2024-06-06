import 'dart:io';

import 'package:carevive/common%20widgets/round_gradient_button.dart';
import 'package:carevive/common%20widgets/round_textfield.dart';
import 'package:carevive/screens/auth/forgot_password.dart';
import 'package:carevive/screens/auth/signup_screen.dart';
import 'package:carevive/screens/dashboard/dashboard_screen.dart';
import 'package:carevive/services/auth_service.dart';
import 'package:carevive/utils/app_colors.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:permission_handler/permission_handler.dart';

class LoginScreen extends StatefulWidget {
  static String routeName = "/LoginScreen";
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _isObscure = true;
  final _formKey = GlobalKey<FormState>();

  final GoogleSignIn googleSignIn = GoogleSignIn();

  Future<void> _signInWithGoogle() async {
    if (Platform.isAndroid) {
      try {
        final GoogleSignInAccount? googleSignInAccount =
            await googleSignIn.signIn();
        if (googleSignInAccount != null) {
          final GoogleSignInAuthentication googleSignInAuthentication =
              await googleSignInAccount.authentication;
          final AuthCredential credential = GoogleAuthProvider.credential(
            accessToken: googleSignInAuthentication.accessToken,
            idToken: googleSignInAuthentication.idToken,
          );
          await _auth.signInWithCredential(credential);
          Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => DashboardScreen(),
              ));
        }
      } catch (e) {}
    }
  }

  Future<User?> _signIn(
      BuildContext context, String email, String password) async {
    try {
      UserCredential userCredential = await _auth.signInWithEmailAndPassword(
          email: email, password: password);

      User? user = userCredential.user;

      Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => DashboardScreen(),
          ));

      return user;
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text("Login failed. Please check your email and password."),
      ));

      return null;
    }
  }

  @override
  void initState() {
    super.initState();
    requestPermissions2();
  }

  Future<void> requestPermissions2() async {
    if (await Permission.scheduleExactAlarm.isDenied) {
      // Request permission
      await Permission.scheduleExactAlarm.request();
    }
  }

  @override
  Widget build(BuildContext context) {
    var media = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: AppColors.whiteColor,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Container(
            padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 25),
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(
                    height: media.height * 0.1,
                  ),
                  SizedBox(
                    width: media.width,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        SizedBox(
                          height: media.width * 0.03,
                        ),
                        const Text(
                          "Hey there,",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: AppColors.blackColor,
                            fontSize: 16,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                        SizedBox(height: media.width * 0.01),
                        const Text(
                          "Welcome Back",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: AppColors.blackColor,
                            fontSize: 20,
                            fontFamily: "Poppins",
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: media.width * 0.1),
                  RoundTextField(
                    textEditingController: _emailController,
                    hintText: "Email",
                    icon: "assets/icons/message_icon.png",
                    textInputType: TextInputType.emailAddress,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter your email';
                      } else if (!RegExp(
                              r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+/=?^_`{|}~-]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
                          .hasMatch(value)) {
                        return 'Enter a valid email address';
                      }
                      return null;
                    },
                  ),
                  SizedBox(height: media.width * 0.05),
                  RoundTextField(
                    textEditingController: _passwordController,
                    hintText: "Password",
                    icon: "assets/icons/lock_icon.png",
                    textInputType: TextInputType.visiblePassword,
                    isObscureText: _isObscure,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter your password';
                      } else if (value.length < 6) {
                        return 'Password must be at least 6 characters long';
                      }
                      return null;
                    },
                    rightIcon: TextButton(
                        onPressed: () {
                          setState(() {
                            _isObscure = !_isObscure;
                          });
                        },
                        child: Container(
                            alignment: Alignment.center,
                            width: 20,
                            height: 20,
                            child: Image.asset(
                              _isObscure
                                  ? "assets/icons/show_pwd_icon.png"
                                  : "assets/icons/hide_pwd_icon.png",
                              width: 20,
                              height: 20,
                              fit: BoxFit.contain,
                              color: AppColors.grayColor,
                            ))),
                  ),
                  // SizedBox(height: media.width * 0.01),
                  Align(
                    alignment: Alignment.centerRight,
                    child: TextButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => ForgotPasswordScreen()),
                        );
                      },
                      child: const Text("Forgot your password?",
                          style: TextStyle(
                            color: AppColors.secondaryColor1,
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                          )),
                    ),
                  ),
                  SizedBox(height: media.width * 0.1),
                  RoundGradientButton(
                    title: "Login",
                    onPressed: () {
                      if (_formKey.currentState!.validate()) {
                        _signIn(context, _emailController.text,
                            _passwordController.text);
                      }
                    },
                  ),
                  SizedBox(height: media.width * 0.01),
                  Row(
                    children: [
                      Expanded(
                          child: Container(
                        width: double.maxFinite,
                        height: 1,
                        color: AppColors.grayColor.withOpacity(0.5),
                      )),
                      Text("  Or  ",
                          style: TextStyle(
                              color: AppColors.grayColor,
                              fontSize: 12,
                              fontWeight: FontWeight.w400)),
                      Expanded(
                          child: Container(
                        width: double.maxFinite,
                        height: 1,
                        color: AppColors.grayColor.withOpacity(0.5),
                      )),
                    ],
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      GestureDetector(
                        onTap: () {
                          AuthService().signInWithGoogle(context);
                        },
                        child: Container(
                          width: 50,
                          height: 50,
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(14),
                            border: Border.all(
                              color: AppColors.primaryColor1.withOpacity(0.5),
                              width: 1,
                            ),
                          ),
                          child: Image.asset(
                            "assets/icons/google_icon.png",
                            width: 20,
                            height: 20,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  TextButton(
                      onPressed: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => SignupScreen(),
                            ));
                      },
                      child: RichText(
                        textAlign: TextAlign.center,
                        text: TextSpan(
                            style: TextStyle(
                                color: AppColors.blackColor,
                                fontSize: 14,
                                fontWeight: FontWeight.w400),
                            children: [
                              const TextSpan(
                                text: "Don’t have an account yet? ",
                              ),
                              TextSpan(
                                  text: "Register",
                                  style: TextStyle(
                                      color: AppColors.secondaryColor1,
                                      fontSize: 14,
                                      fontWeight: FontWeight.w500)),
                            ]),
                      )),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
