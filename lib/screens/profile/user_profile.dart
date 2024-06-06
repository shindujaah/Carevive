import 'package:carevive/common%20widgets/round_button.dart';
import 'package:carevive/screens/auth/login_screen.dart';
import 'package:carevive/screens/profile/documents/documents_screen.dart';
import 'package:carevive/screens/profile/information/edit_personaldata.dart';
import 'package:carevive/screens/profile/information/cancer_treatment.dart';
import 'package:carevive/screens/profile/information/health_metrics.dart';
import 'package:carevive/screens/profile/information/personal_information.dart';
import 'package:carevive/screens/profile/personal_data.dart';
import 'package:carevive/screens/profile/widgets/setting_row.dart';
import 'package:carevive/screens/profile/widgets/title_subtitle_cell.dart';
import 'package:carevive/services/auth_service.dart';
import 'package:carevive/utils/app_colors.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:provider/provider.dart';

class UserProfile extends StatefulWidget {
  const UserProfile({Key? key}) : super(key: key);

  @override
  State<UserProfile> createState() => _UserProfileState();
}

class _UserProfileState extends State<UserProfile> {
  bool positive = false;

  List accountArr = [
    {
      "image": "assets/icons/p_personal.png",
      "name": "Personal Information",
      "tag": "1"
    },
    {
      "image": "assets/icons/p_workout.png",
      "name": "Health Metrics",
      "tag": "2"
    },
    {
      "image": "assets/icons/cancer_icon.png",
      "name": "Cancer Treatment Details",
      "tag": "3"
    },
  ];

  List otherArr = [
    {"image": "assets/icons/resources.png", "name": "Documents", "tag": "1"},
  ];

  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  User? user;
  late String uid;
  String firstName = '';
  String lastName = '';
  double weight = 0;
  double height = 0;
  int age = 0;

  @override
  void initState() {
    super.initState();
    fetchUserData();
    // Fetch user data when the screen is first created
  }

  Future<void> fetchUserData() async {
    int retries = 3;
    while (retries > 0) {
      try {
        // Get the current user
        user = _auth.currentUser;

        if (user != null) {
          // Get user details
          uid = user!.uid;

          // Fetch additional user data from Firestore
          DocumentSnapshot userSnapshot =
              await _firestore.collection('users').doc(uid).get();

          // Update state with fetched data
          setState(() {
            firstName = userSnapshot['firstName'] ?? '';
            lastName = userSnapshot['lastName'] ?? '';
            weight = double.parse(userSnapshot['weight']);
            height = double.parse(userSnapshot['height']);
            age = int.parse(userSnapshot['age']);
          });
        }

        return; // Operation succeeded
      } catch (e) {
        retries--;
        await Future.delayed(Duration(seconds: 5)); // Retry after 5 seconds
      }
    }
    print("Exceeded maximum retries. Unable to fetch data.");
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      child: Scaffold(
        backgroundColor: AppColors.whiteColor,
        appBar: AppBar(
          backgroundColor: AppColors.whiteColor,
          centerTitle: true,
          automaticallyImplyLeading: false,
          elevation: 0,
          title: const Text(
            "Profile",
            style: TextStyle(
                color: AppColors.blackColor,
                fontSize: 16,
                fontWeight: FontWeight.w700),
          ),
          actions: [
            InkWell(
              onTap: () {},
              child: Container(
                margin: const EdgeInsets.all(8),
                height: 40,
                width: 40,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                    color: AppColors.lightGrayColor,
                    borderRadius: BorderRadius.circular(10)),
                child: Image.asset(
                  "assets/icons/more_icon.png",
                  width: 12,
                  height: 12,
                  fit: BoxFit.contain,
                ),
              ),
            )
          ],
        ),
        body: SingleChildScrollView(
          child: Container(
            padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 25),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Row(
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(30),
                      child: Image.asset(
                        "assets/images/user.png",
                        width: 50,
                        height: 50,
                        fit: BoxFit.cover,
                      ),
                    ),
                    const SizedBox(
                      width: 15,
                    ),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            firstName + " " + lastName,
                            style: TextStyle(
                              color: AppColors.blackColor,
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          Text(
                            "To Be Fit",
                            style: TextStyle(
                              color: AppColors.grayColor,
                              fontSize: 12,
                            ),
                          )
                        ],
                      ),
                    ),
                    SizedBox(
                      width: 70,
                      height: 25,
                      child: RoundButton(
                        title: "Edit",
                        type: RoundButtonType.primaryBG,
                        onPressed: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => EditPersonalData(),
                              ));
                        },
                      ),
                    )
                  ],
                ),
                const SizedBox(
                  height: 15,
                ),
                Row(
                  children: [
                    Expanded(
                      child: TitleSubtitleCell(
                        title: "${height}cm",
                        subtitle: "Height",
                      ),
                    ),
                    SizedBox(
                      width: 15,
                    ),
                    Expanded(
                      child: TitleSubtitleCell(
                        title: "${weight}kg",
                        subtitle: "Weight",
                      ),
                    ),
                    SizedBox(
                      width: 15,
                    ),
                    Expanded(
                      child: TitleSubtitleCell(
                        title: "${age}yo",
                        subtitle: "Age",
                      ),
                    ),
                  ],
                ),
                const SizedBox(
                  height: 25,
                ),
                Container(
                  padding:
                      const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
                  decoration: BoxDecoration(
                      color: AppColors.whiteColor,
                      borderRadius: BorderRadius.circular(15),
                      boxShadow: const [
                        BoxShadow(color: Colors.black12, blurRadius: 2)
                      ]),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Account",
                        style: TextStyle(
                          color: AppColors.blackColor,
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      const SizedBox(
                        height: 8,
                      ),
                      ListView.builder(
                        physics: const NeverScrollableScrollPhysics(),
                        shrinkWrap: true,
                        itemCount: accountArr.length,
                        itemBuilder: (context, index) {
                          var iObj = accountArr[index] as Map? ?? {};
                          return SettingRow(
                            icon: iObj["image"].toString(),
                            title: iObj["name"].toString(),
                            onPressed: () {
                              if (index == 0) {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => PersonalInfoScreen(
                                            uid: _auth.currentUser!.uid,
                                          )),
                                );
                              } else if (index == 1) {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => HealthMetricsScreen(
                                            uid: _auth.currentUser!.uid,
                                          )),
                                );
                              } else if (index == 2) {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          CancerTreatmentScreen(
                                            uid: _auth.currentUser!.uid,
                                          )),
                                );
                              }
                            },
                          );
                        },
                      )
                    ],
                  ),
                ),
                // const SizedBox(
                //   height: 25,
                // ),
                // Container(
                //   padding:
                //       const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
                //   decoration: BoxDecoration(
                //       color: AppColors.whiteColor,
                //       borderRadius: BorderRadius.circular(15),
                //       boxShadow: const [
                //         BoxShadow(color: Colors.black12, blurRadius: 2)
                //       ]),
                //   child: Column(
                //     crossAxisAlignment: CrossAxisAlignment.start,
                //     children: [
                //       Text(
                //         "Notification",
                //         style: TextStyle(
                //           color: AppColors.blackColor,
                //           fontSize: 16,
                //           fontWeight: FontWeight.w700,
                //         ),
                //       ),
                //       const SizedBox(
                //         height: 8,
                //       ),
                //       // SizedBox(
                //       //   height: 30,
                //       //   child: Row(
                //       //       crossAxisAlignment: CrossAxisAlignment.center,
                //       //       children: [
                //       //         Image.asset("assets/icons/p_notification.png",
                //       //             height: 15, width: 15, fit: BoxFit.contain),
                //       //         const SizedBox(
                //       //           width: 15,
                //       //         ),
                //       //         Expanded(
                //       //           child: Text(
                //       //             "Pop-up Notification",
                //       //             style: TextStyle(
                //       //               color: AppColors.blackColor,
                //       //               fontSize: 12,
                //       //             ),
                //       //           ),
                //       //         ),
                //       //         CustomAnimatedToggleSwitch<bool>(
                //       //           current: positive,
                //       //           values: [false, true],
                //       //           dif: 0.0,
                //       //           indicatorSize: Size.square(30.0),
                //       //           animationDuration:
                //       //               const Duration(milliseconds: 200),
                //       //           animationCurve: Curves.linear,
                //       //           onChanged: (b) => setState(() => positive = b),
                //       //           iconBuilder: (context, local, global) {
                //       //             return const SizedBox();
                //       //           },
                //       //           defaultCursor: SystemMouseCursors.click,
                //       //           onTap: () => setState(() => positive = !positive),
                //       //           iconsTappable: false,
                //       //           wrapperBuilder: (context, global, child) {
                //       //             return Stack(
                //       //               alignment: Alignment.center,
                //       //               children: [
                //       //                 Positioned(
                //       //                     left: 10.0,
                //       //                     right: 10.0,
                //       //                     height: 30.0,
                //       //                     child: DecoratedBox(
                //       //                       decoration: BoxDecoration(
                //       //                         gradient: LinearGradient(
                //       //                             colors: AppColors.secondaryG),
                //       //                         borderRadius:
                //       //                             const BorderRadius.all(
                //       //                                 Radius.circular(30.0)),
                //       //                       ),
                //       //                     )),
                //       //                 child,
                //       //               ],
                //       //             );
                //       //           },
                //       //           foregroundIndicatorBuilder: (context, global) {
                //       //             return SizedBox.fromSize(
                //       //               size: const Size(10, 10),
                //       //               child: DecoratedBox(
                //       //                 decoration: BoxDecoration(
                //       //                   color: AppColors.whiteColor,
                //       //                   borderRadius: const BorderRadius.all(
                //       //                       Radius.circular(50.0)),
                //       //                   boxShadow: const [
                //       //                     BoxShadow(
                //       //                         color: Colors.black38,
                //       //                         spreadRadius: 0.05,
                //       //                         blurRadius: 1.1,
                //       //                         offset: Offset(0.0, 0.8))
                //       //                   ],
                //       //                 ),
                //       //               ),
                //       //             );
                //       //           },
                //       //         ),
                //       //       ]),
                //       // )
                //     ],
                //   ),
                // ),
                const SizedBox(
                  height: 25,
                ),
                Container(
                  padding:
                      const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
                  decoration: BoxDecoration(
                      color: AppColors.whiteColor,
                      borderRadius: BorderRadius.circular(15),
                      boxShadow: const [
                        BoxShadow(color: Colors.black12, blurRadius: 2)
                      ]),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Other",
                        style: TextStyle(
                          color: AppColors.blackColor,
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      const SizedBox(
                        height: 8,
                      ),
                      ListView.builder(
                        physics: const NeverScrollableScrollPhysics(),
                        padding: EdgeInsets.zero,
                        shrinkWrap: true,
                        itemCount: otherArr.length,
                        itemBuilder: (context, index) {
                          var iObj = otherArr[index] as Map? ?? {};
                          return SettingRow(
                            icon: iObj["image"].toString(),
                            title: iObj["name"].toString(),
                            onPressed: () {
                              if (index == 0) {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => DocumentScreen()),
                                );
                              }
                            },
                          );
                        },
                      )
                    ],
                  ),
                ),
                SizedBox(height: 20),
                InkWell(
                  onTap: () {
                    try {
                      String? provider;
                      final providerData = user!.providerData;
                      for (UserInfo userInfo in providerData) {
                        provider = userInfo.providerId;
                      }

                      if (provider == "google.com") {
                        AuthService().signOut();
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => LoginScreen(),
                            ));
                      } else {
                        _auth.signOut();
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => LoginScreen(),
                            ));
                      }
                    } catch (e) {}

                    // try {
                    //   // if (GoogleSignIn().currentUser != null) {
                    //   //   AuthService().signOut();
                    //   //   Navigator.push(
                    //   //       context,
                    //   //       MaterialPageRoute(
                    //   //         builder: (context) => LoginScreen(),
                    //   //       ));
                    //   // } else {
                    //   //   _auth.signOut();
                    //   //   Navigator.push(
                    //   //       context,
                    //   //       MaterialPageRoute(
                    //   //         builder: (context) => LoginScreen(),
                    //   //       ));
                    //   // }

                    //   // final providerData = user!.providerData;
                    //   // if (providerData.contains('google.com')) {
                    //   //   AuthService().signOut();
                    //   //   Navigator.push(
                    //   //       context,
                    //   //       MaterialPageRoute(
                    //   //         builder: (context) => LoginScreen(),
                    //   //       ));
                    //   // } else {
                    //   //   // _auth.signOut();
                    //   //   // Navigator.push(
                    //   //   //     context,
                    //   //   //     MaterialPageRoute(
                    //   //   //       builder: (context) => LoginScreen(),
                    //   //   //     ));
                    //   // }
                    // } catch (e) {}

                    // Future<void> signOut(BuildContext context) async {
                    //   await _auth.signOut();
                    // }

                    // signOut(context);
                    // Navigator.push(
                    //     context,
                    //     MaterialPageRoute(
                    //       builder: (context) => LoginScreen(),
                    //     ));
                  },
                  child: Container(
                    height: 40,
                    width: double.infinity,
                    decoration: BoxDecoration(
                        gradient: LinearGradient(
                            colors: AppColors.primaryG,
                            begin: Alignment.centerLeft,
                            end: Alignment.centerRight),
                        borderRadius: BorderRadius.circular(25),
                        boxShadow: const [
                          BoxShadow(
                              color: Colors.black26,
                              blurRadius: 2,
                              offset: Offset(0, 2))
                        ]),
                    child: Center(
                        child: Text("Log Out",
                            style: TextStyle(
                              fontSize: 16,
                              color: AppColors.whiteColor,
                              fontFamily: "Poppins",
                              fontWeight: FontWeight.w400,
                            ))),
                  ),
                ),
                SizedBox(height: 50),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
