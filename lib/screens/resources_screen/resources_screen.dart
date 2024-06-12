import 'package:carevive/screens/resources_screen/resources.dart';
import 'package:carevive/screens/resources_screen/resources_list_screen.dart';
import 'package:carevive/utils/app_colors.dart';
import 'package:flutter/material.dart';

class ResourcesScreen extends StatefulWidget {
  const ResourcesScreen({super.key});

  @override
  State<ResourcesScreen> createState() => _ResourcesScreenState();
}

class _ResourcesScreenState extends State<ResourcesScreen> {
  List<Map<String, String>> items = [
    {
      'imageUrl': 'assets/icons/nutrition_icon.png',
      'title': 'Nutrition',
      'description': 'Information about nutrition and diet plans.',
      'category': 'nutrition'
    },
    {
      'imageUrl': 'assets/icons/mental_health_icon.png',
      'title': 'Mental Health',
      'description': 'Tips and resources for mental well-being.',
      'category': 'mental_health'
    },
    {
      'imageUrl': 'assets/icons/exercise_icon.png',
      'title': 'Exercise',
      'description': 'Guidance on physical activities and exercises.',
      'category': 'exercise'
    },
    {
      'imageUrl': 'assets/icons/general_icon.png',
      'title': 'General',
      'description': 'General health information and resources.',
      'category': 'general'
    },
    {
      'imageUrl': 'assets/icons/cancer_hand.png',
      'title': 'Cancer',
      'description': 'Latest news and resources about cancer.',
      'category': 'cancer'
    },
    {
      'imageUrl': 'assets/icons/healthcare_icon.png',
      'title': 'Healthcare',
      'description': 'Latest news and resources about healthcare.',
      'category': 'healthcare'
    },
  ];

  @override
  Widget build(BuildContext context) {
    var media = MediaQuery.of(context).size;

    return WillPopScope(
      onWillPop: () async => false,
      child: Scaffold(
        backgroundColor: AppColors.whiteColor,
        appBar: AppBar(
          backgroundColor: AppColors.whiteColor,
          automaticallyImplyLeading: false,
          elevation: 0,
          title: const Text(
            "Resources",
            style: TextStyle(
                color: AppColors.blackColor,
                fontSize: 16,
                fontWeight: FontWeight.w700),
          ),
          centerTitle: true,
        ),
        body: SafeArea(
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ListView.builder(
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    itemCount: items.length,
                    padding: EdgeInsets.all(15),
                    itemBuilder: (context, index) {
                      Color containerColor = (index % 2 == 1)
                          ? AppColors.primaryColor1
                          : Colors.white;
                      Color textColor = (index % 2 == 1)
                          ? Colors.white
                          : AppColors.primaryColor1;

                      return InkWell(
                        onTap: () {
                          if (index <= 3) {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => ResourceScreen(
                                  title: '${items[index]['title']} Resources',
                                  category: items[index]['category']!,
                                ),
                              ),
                            );
                          } else {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => ResourceScreen(
                                  title: '${items[index]['title']} Resources',
                                  category: items[index]['category']!,
                                ),
                              ),
                            );
                          }
                        },
                        child: Container(
                          margin: EdgeInsets.only(bottom: 20),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20),
                            color: containerColor,
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black12,
                                spreadRadius: 2,
                                blurRadius: 2,
                              ),
                            ],
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(15.0),
                            child: Row(
                              children: [
                                Expanded(
                                  flex: 3,
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        items[index]['title']!,
                                        style: TextStyle(
                                          fontSize: 16,
                                          color: textColor,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      SizedBox(height: 10),
                                      Text(
                                        items[index]['description']!,
                                        style: TextStyle(
                                          fontSize: 14,
                                          color: textColor.withOpacity(0.6),
                                        ),
                                      ),
                                      SizedBox(height: 10),
                                      Text(
                                        'Click more >',
                                        style: TextStyle(
                                          fontSize: 14,
                                          color: textColor,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                SizedBox(width: 10),
                                Expanded(
                                  flex: 2,
                                  child: Container(
                                    height: media.height * 0.15,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(20),
                                    ),
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.circular(20),
                                      child: Image.asset(
                                        items[index]['imageUrl']!,
                                        fit: BoxFit.cover,
                                        width: double.infinity,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
