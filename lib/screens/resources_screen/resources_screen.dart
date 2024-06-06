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
    {'imageUrl': 'assets/icons/nutrition_icon.png', 'title': 'Nutrition'},
    {
      'imageUrl': 'assets/icons/mental_health_icon.png',
      'title': 'Mental Health'
    },
    {'imageUrl': 'assets/icons/exercise_icon.png', 'title': 'Exercise'},
    {'imageUrl': 'assets/icons/general_icon.png', 'title': 'General'},
    // Add more items here
  ];

  @override
  Widget build(BuildContext context) {
    var media = MediaQuery.of(context).size;

    return PopScope(
      canPop: false,
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
                fontSize: 20,
                fontWeight: FontWeight.w700),
          ),
        ),
        body: SafeArea(
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  GridView.builder(
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    itemCount: items.length,
                    padding: EdgeInsets.all(15),
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      childAspectRatio:
                          (MediaQuery.of(context).size.height - 50 - 25) /
                              (4 * 240),
                      mainAxisSpacing: 15,
                      crossAxisSpacing: 15,
                    ),
                    itemBuilder: (context, index) {
                      return InkWell(
                        onTap: () {
                          if (index == 0) {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => ResourceScreen(
                                  title: 'Nutrition Resources',
                                  resources: nutritionResources,
                                ),
                              ),
                            );
                          } else if (index == 1) {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => ResourceScreen(
                                  title: 'Mental Health Resources',
                                  resources: mentalHealthResources,
                                ),
                              ),
                            );
                          } else if (index == 2) {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => ResourceScreen(
                                  title: 'Exercise Resources',
                                  resources: exerciseResources,
                                ),
                              ),
                            );
                          } else if (index == 3) {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => ResourceScreen(
                                  title: 'General Information Resources',
                                  resources: generalInfoResources,
                                ),
                              ),
                            );
                          }
                        },
                        child: Container(
                          padding: EdgeInsets.symmetric(
                              vertical: 20, horizontal: 10),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20),
                            color: Colors.white,
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black12,
                                spreadRadius: 2,
                                blurRadius: 2,
                              ),
                            ],
                          ),
                          child: Column(
                            children: [
                              Padding(
                                padding: EdgeInsets.all(10),
                                child: Image.asset(
                                  items[index]['imageUrl']!,
                                  height: media.height * 0.12,
                                ),
                              ),
                              SizedBox(height: 10),
                              Text(
                                items[index]['title']!,
                                style: TextStyle(
                                  fontSize: 22,
                                  color: Colors.black.withOpacity(0.6),
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
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
