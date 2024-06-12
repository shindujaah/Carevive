import 'package:flutter/material.dart';
import 'news_service.dart';
import 'news_model.dart';
import 'resources_model.dart';
import 'resources.dart';
import 'package:intl/intl.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:carevive/utils/app_colors.dart';

class ResourceScreen extends StatefulWidget {
  final String title;
  final String category;

  ResourceScreen({required this.title, required this.category});

  @override
  State<ResourceScreen> createState() => _ResourceScreenState();
}

class _ResourceScreenState extends State<ResourceScreen> {
  late Future<List<News>> futureNews;
  final NewsService newsService = NewsService();
  int currentPage = 1;
  String sortBy = 'publishedAt';

  @override
  void initState() {
    super.initState();
    _fetchNews();
  }

  void _fetchNews() {
    if (widget.category == 'cancer') {
      futureNews = newsService.fetchNewsByKeyword('Cancer', page: currentPage, sortBy: sortBy);
    } else if (widget.category == 'healthcare') {
      futureNews = newsService.fetchNewsByCategory('health', page: currentPage, sortBy: sortBy);
    }
  }

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

  String _formatDate(String date) {
    final DateTime parsedDate = DateTime.parse(date);
    return DateFormat.yMMMMd().format(parsedDate);
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
            fontWeight: FontWeight.w700,
          ),
        ),
        backgroundColor: AppColors.whiteColor,
        centerTitle: true,
        iconTheme: IconThemeData(color: AppColors.blackColor),
      ),
      body: Column(
        children: [
          if (widget.category == 'cancer' || widget.category == 'healthcare')
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 15.0),
                decoration: BoxDecoration(
                  color: AppColors.whiteColor,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: AppColors.primaryColor1),
                ),
                child: DropdownButtonFormField<String>(
                  decoration: InputDecoration(
                    border: InputBorder.none,
                  ),
                  value: sortBy,
                  dropdownColor: AppColors.whiteColor,
                  style: TextStyle(color: AppColors.primaryColor1, fontWeight: FontWeight.bold),
                  items: [
                    DropdownMenuItem(
                      value: 'publishedAt',
                      child: Text('Published Date', style: TextStyle(color: AppColors.primaryColor1)),
                    ),
                    DropdownMenuItem(
                      value: 'popularity',
                      child: Text('Popularity', style: TextStyle(color: AppColors.primaryColor1)),
                    ),
                  ],
                  onChanged: (value) {
                    if (value != null) {
                      setState(() {
                        sortBy = value;
                        currentPage = 1;
                        _fetchNews();
                      });
                    }
                  },
                  icon: Icon(Icons.arrow_drop_down, color: AppColors.primaryColor1),
                ),
              ),
            ),
          Expanded(child: _getContentBasedOnCategory(widget.category)),
        ],
      ),
      bottomNavigationBar: widget.category == 'cancer' || widget.category == 'healthcare'
          ? Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  ElevatedButton(
                    onPressed: currentPage > 1
                        ? () {
                            setState(() {
                              currentPage--;
                              _fetchNews();
                            });
                          }
                        : null,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primaryColor1,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    child: Text('Previous', style: TextStyle(color: AppColors.whiteColor)),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      setState(() {
                        currentPage++;
                        _fetchNews();
                      });
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primaryColor1,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    child: Text('Next', style: TextStyle(color: AppColors.whiteColor)),
                  ),
                ],
              ),
            )
          : null,
    );
  }

  Widget _getContentBasedOnCategory(String category) {
    if (category == 'cancer' || category == 'healthcare') {
      return FutureBuilder<List<News>>(
        future: futureNews,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text('No news available'));
          } else {
            final news = snapshot.data!;
            return ListView.builder(
              itemCount: news.length,
              itemBuilder: (context, index) {
                final article = news[index];
                // Filter out articles with '[Removed]' title or description
                if (article.title == '[Removed]' || article.description == '[Removed]') {
                  return Container(); // Return an empty container for filtered articles
                }
                // Filter out articles with incorrect dates
                if (article.publishedAt != null && DateTime.parse(article.publishedAt!).year < 2000) {
                  return Container(); // Return an empty container for filtered articles
                }
                return Card(
                  color: Colors.white,
                  surfaceTintColor: Colors.white,
                  margin: EdgeInsets.all(10),
                  elevation: 5,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(15.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          article.title ?? 'No title available',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: AppColors.primaryColor1,
                          ),
                        ),
                        SizedBox(height: 10),
                        Text(
                          article.description ?? 'No description available',
                          style: TextStyle(fontSize: 16, color: AppColors.blackColor),
                        ),
                        if (article.urlToImage != null && article.urlToImage!.isNotEmpty)
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 10.0),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(10),
                              child: Image.network(article.urlToImage!),
                            ),
                          ),
                        Text(
                          'Published on: ${article.publishedAt != null ? _formatDate(article.publishedAt!) : 'Unknown date'}',
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.grey,
                          ),
                        ),
                        SizedBox(height: 5),
                        Align(
                          alignment: Alignment.centerRight,
                          child: ElevatedButton(
                            onPressed: article.url != null
                                ? () => _launchURL(Uri.parse(article.url!), false)
                                : null,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppColors.primaryColor1,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                            child: Text(
                              "Read More",
                              style: TextStyle(
                                color: AppColors.whiteColor,
                                fontWeight: FontWeight.w500,
                                fontSize: 15,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            );
          }
        },
      );
    } else {
      List<Resource> resources;
      switch (category) {
        case 'nutrition':
          resources = nutritionResources;
          break;
        case 'mental_health':
          resources = mentalHealthResources;
          break;
        case 'exercise':
          resources = exerciseResources;
          break;
        case 'general':
          resources = generalInfoResources;
          break;
        default:
          resources = [];
      }

      return Padding(
        padding: const EdgeInsets.all(10.0),
        child: ListView.builder(
          itemCount: resources.length,
          itemBuilder: (context, index) {
            final resource = resources[index];
            return Card(
              color: Colors.white,
              elevation: 5,
              margin: EdgeInsets.symmetric(vertical: 8.0),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15.0),
              ),
              child: Padding(
                padding: const EdgeInsets.all(15.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      resource.title,
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: AppColors.primaryColor1,
                      ),
                    ),
                    SizedBox(height: 8),
                    Text(
                      resource.description,
                      style: TextStyle(
                        fontSize: 14,
                        color: AppColors.blackColor,
                      ),
                    ),
                    SizedBox(height: 10),
                    Align(
                      alignment: Alignment.centerRight,
                      child: ElevatedButton(
                        onPressed: () => _launchURL(Uri.parse(resource.url), false),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.primaryColor1,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        child: Text(
                          "Click Here",
                          style: TextStyle(
                            color: AppColors.whiteColor,
                            fontWeight: FontWeight.w500,
                            fontSize: 14,
                          ),
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
}
