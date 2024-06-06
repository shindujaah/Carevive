import 'package:carevive/screens/resources_screen/resources_model.dart';
import 'package:carevive/utils/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class ResourceScreen extends StatefulWidget {
  final String title;
  final List<Resource> resources;

  ResourceScreen({required this.title, required this.resources});

  @override
  State<ResourceScreen> createState() => _ResourceScreenState();
}

class _ResourceScreenState extends State<ResourceScreen> {
  void _launchURL(Uri uri, bool inApp) async {
    try {
      if (await canLaunchUrl(uri)) {
        if (inApp) {
          await launchUrl(
            uri,
            mode: LaunchMode.inAppWebView,
          );
        } else {
          await launchUrl(
            uri,
            mode: LaunchMode.externalApplication,
          );
        }
      }
    } catch (e) {
      print(e.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.title,
          style: TextStyle(
              color: AppColors.blackColor,
              fontSize: 20,
              fontWeight: FontWeight.w700),
        ),
      ),
      body: ListView.builder(
        itemCount: widget.resources.length,
        itemBuilder: (context, index) {
          final resource = widget.resources[index];
          return Card(
            color: Colors.white,
            surfaceTintColor: Colors.white,
            margin: EdgeInsets.all(10),
            elevation: 5,
            child: Padding(
              padding: const EdgeInsets.all(15.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    resource.title,
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 10),
                  Text(
                    resource.description,
                    style: TextStyle(fontSize: 16),
                  ),
                  SizedBox(height: 5),
                  TextButton(
                    onPressed: () => _launchURL(Uri.parse(resource.url), false),
                    child: Text(
                      "Click Here",
                      style: TextStyle(
                        color: AppColors.primaryColor1,
                        // decoration: TextDecoration.underline,
                        fontWeight: FontWeight.w500,
                        fontSize: 15,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
