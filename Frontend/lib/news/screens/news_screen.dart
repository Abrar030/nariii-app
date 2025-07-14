import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:url_launcher/url_launcher.dart';
import 'package:share_plus/share_plus.dart';

const Color kAppPrimaryRed = Color(0xFFF40000);
const String gnewsApiKey = '39b1bbc8c9ac32d05a49fcca8c89c394';

class NewsScreen extends StatefulWidget {
  const NewsScreen({super.key});

  @override
  State<NewsScreen> createState() => _NewsScreenState();
}

class _NewsScreenState extends State<NewsScreen> {
  List<Map<String, String>> articles = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchNews();
  }

  Future<void> fetchNews() async {
    final url =
        "https://gnews.io/api/v4/search?q=women+security+OR+women+safety+OR+sexual+harassment+OR+gender+violence&lang=en&country=in&max=10&token=$gnewsApiKey";

    try {
      final response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final List<Map<String, String>> fetchedArticles = [];

        for (var item in data['articles']) {
          fetchedArticles.add({
            "title": item['title'] ?? "No Title",
            "summary": item['description'] ?? "",
            "url": item['url'] ?? "",
            "image": item['image'] ?? "",
          });
        }

        setState(() {
          articles = fetchedArticles;
          isLoading = false;
        });
      } else {
        throw Exception("Failed to load news");
      }
    } catch (e) {
      debugPrint("❌ Error: $e");
      setState(() {
        isLoading = false;
      });
    }
  }

  void _shareArticle(String url) {
    Share.share('Check out this safety article: $url');
  }

  Future<void> _openUrl(String urlString) async {
    final Uri url = Uri.parse(urlString);
    if (!await launchUrl(url, mode: LaunchMode.externalApplication)) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Couldn't open the article")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 1,
        centerTitle: true,
        title: const Text(
          '📰 Safety News',
          style: TextStyle(
            color: Color(0xFFF40000),
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
        ),
        iconTheme: const IconThemeData(color: Color(0xFFF40000)),
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator(color: kAppPrimaryRed))
          : articles.isEmpty
              ? const Center(
                  child: Text(
                    "No safety news available.",
                    style: TextStyle(fontSize: 16),
                  ),
                )
              : ListView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: articles.length,
                  itemBuilder: (context, index) {
                    final article = articles[index];
                    return _NewsCard(
                      title: article['title']!,
                      summary: article['summary']!,
                      url: article['url']!,
                      image: article['image'],
                      onTap: () => _openUrl(article['url']!),
                      onShare: () => _shareArticle(article['url']!),
                    );
                  },
                ),
    );
  }
}

class _NewsCard extends StatelessWidget {
  final String title;
  final String summary;
  final String url;
  final String? image;
  final VoidCallback onTap;
  final VoidCallback onShare;

  const _NewsCard({
    required this.title,
    required this.summary,
    required this.url,
    this.image,
    required this.onTap,
    required this.onShare,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: LayoutBuilder(
        builder: (context, constraints) {
          final isSmall = constraints.maxWidth < 350;
          return AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            margin: const EdgeInsets.only(bottom: 10),
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(14),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.10),
                  blurRadius: 6,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (image != null && image!.isNotEmpty)
                  ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: Image.network(
                      image!,
                      width: isSmall ? 40 : 60,
                      height: isSmall ? 40 : 60,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) => Container(
                        width: isSmall ? 40 : 60,
                        height: isSmall ? 40 : 60,
                        color: Colors.grey[200],
                        child: const Icon(Icons.image, color: Colors.grey),
                      ),
                    ),
                  ),
                if (image != null && image!.isNotEmpty)
                  SizedBox(width: isSmall ? 6 : 10),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        maxLines: isSmall ? 1 : 2,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontSize: isSmall ? 12.5 : 14.5,
                          fontWeight: FontWeight.bold,
                          color: Colors.black87,
                        ),
                      ),
                      SizedBox(height: isSmall ? 3 : 6),
                      Text(
                        summary,
                        maxLines: isSmall ? 1 : 2,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(fontSize: isSmall ? 10.5 : 12.5, color: Colors.black54),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          IconButton(
                            onPressed: onShare,
                            icon: const Icon(Icons.share, color: kAppPrimaryRed),
                            iconSize: isSmall ? 15 : 18,
                            padding: EdgeInsets.zero,
                            constraints: const BoxConstraints(),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
