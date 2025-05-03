import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'all_news_page.dart';
import '../models/news_model.dart';
import '../widgets/news_category_widget.dart';
import '../widgets/news_item_widget.dart';
import 'news_detail_page.dart' as detail;
import 'login_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final supabase = Supabase.instance.client;
  List<NewsModel> newsList = [];
  List<NewsModel> filteredNews = [];
  bool isLoading = true;
  String selectedCategory = 'Semua Berita';
  TextEditingController searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    fetchNews();
    searchController.addListener(_filterSearchResults);
  }

  Future<void> fetchNews({String? category}) async {
    try {
      final response = await supabase
          .from('news')
          .select()
          .order('time', ascending: false)
          .limit(10);

      final List<NewsModel> loadedNews =
          (response as List).map((item) => NewsModel.fromJson(item)).where((
            news,
          ) {
            if (category == null || category == 'Semua Berita') {
              return true;
            }
            return news.categories == category;
          }).toList();

      setState(() {
        newsList = loadedNews;
        filteredNews = loadedNews;
        isLoading = false;
      });
    } catch (e) {
      print('Error fetching news: $e');
      setState(() {
        isLoading = false;
      });
    }
  }

  void _filterSearchResults() {
    final query = searchController.text.toLowerCase();
    setState(() {
      filteredNews =
          newsList
              .where(
                (news) =>
                    news.title.toLowerCase().contains(query) ||
                    news.description.toLowerCase().contains(query),
              )
              .toList();
    });
  }

  void _openSearchPopup() async {
    await showDialog<String>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: const Color.fromARGB(255, 15, 34, 64),
          titleTextStyle: const TextStyle(color: Colors.white, fontSize: 20),
          contentTextStyle: const TextStyle(color: Colors.white),
          title: const Text('Search News'),
          content: TextFormField(
            controller: searchController,
            style: const TextStyle(color: Colors.white),
            decoration: const InputDecoration(
              labelText: 'Enter News Title',
              labelStyle: TextStyle(color: Colors.white70),
              enabledBorder: UnderlineInputBorder(
                borderSide: BorderSide(color: Colors.white70),
              ),
              focusedBorder: UnderlineInputBorder(
                borderSide: BorderSide(color: Colors.white),
              ),
            ),
            autofocus: true,
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context, searchController.text);
              },
              child: const Text('Done', style: TextStyle(color: Colors.white)),
            ),
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text(
                'Cancel',
                style: TextStyle(color: Colors.white),
              ),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 15, 34, 64),
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 15, 34, 64),
        elevation: 4,
        title: const Text(
          'Samarinda News',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        leading: IconButton(
          icon: const Icon(Icons.search, color: Colors.white),
          onPressed: _openSearchPopup,
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.login_outlined, color: Colors.white),
            onPressed: () {
              Navigator.push(
                context,
                CupertinoPageRoute(builder: (context) => const LoginPage()),
              );
            },
          ),
        ],
        centerTitle: true,
      ),
      body:
          isLoading
              ? const Center(child: CircularProgressIndicator())
              : filteredNews.isEmpty
              ? const Center(
                child: Text(
                  'No matching news found.',
                  style: TextStyle(color: Colors.white),
                ),
              )
              : SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      NewsCategoryWidget(
                        onCategoryChanged: (category) {
                          setState(() {
                            selectedCategory = category;
                          });
                          fetchNews(category: category);
                        },
                      ),
                      _buildLargeNewsCard(
                        filteredNews[0].title,
                        filteredNews[0].image,
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text(
                              'Berita Terkini',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                            TextButton(
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  CupertinoPageRoute(
                                    builder: (context) => const AllNewsPage(),
                                  ),
                                );
                              },
                              child: const Text(
                                'Lihat Semua',
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: Color.fromARGB(255, 182, 209, 232),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      ...filteredNews
                          .take(2)
                          .map(
                            (news) => Padding(
                              padding: const EdgeInsets.only(bottom: 1.0),
                              child: GestureDetector(
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder:
                                          (context) =>
                                              detail.NewsDetailPage(news: news),
                                    ),
                                  );
                                },
                                child: NewsItemWidget(news: news),
                              ),
                            ),
                          ),
                    ],
                  ),
                ),
              ),
    );
  }

  Widget _buildLargeNewsCard(String title, String imageUrl) {
    return Stack(
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(16),
          child: Image.network(
            imageUrl,
            width: double.infinity,
            height: 220,
            fit: BoxFit.cover,
            errorBuilder: (context, error, stackTrace) {
              return Container(
                width: double.infinity,
                height: 220,
                color: const Color.fromARGB(255, 255, 255, 255),
                child: const Center(
                  child: Text(
                    'Gambar gagal dimuat.',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              );
            },
          ),
        ),
        Positioned(
          bottom: 16,
          left: 16,
          child: Container(
            width: 300,
            padding: const EdgeInsets.all(8),
            child: Text(
              title,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
