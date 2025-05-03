import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/news_model.dart';
import '../widgets/news_item_widget.dart';
import 'news_detail_page.dart';

class AllNewsPage extends StatefulWidget {
  const AllNewsPage({Key? key}) : super(key: key);

  @override
  State<AllNewsPage> createState() => _AllNewsPageState();
}

class _AllNewsPageState extends State<AllNewsPage> {
  final _supabase = Supabase.instance.client;
  List<NewsModel> _newsList = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchNews();
  }

  Future<void> _fetchNews() async {
    try {
      final response = await _supabase
          .from('news')
          .select()
          .order('id', ascending: false);

      setState(() {
        _newsList = List<NewsModel>.from(
          response.map((newsItem) => NewsModel.fromJson(newsItem)),
        );
        _isLoading = false;
      });
    } catch (e) {
      debugPrint('Error fetching news: $e');
      setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(appBar: _buildAppBar(context), body: _buildBody());
  }

  PreferredSizeWidget _buildAppBar(BuildContext context) {
    return AppBar(
      backgroundColor: const Color(0xFF131B31),
      title: const Text(
        'Samarinda News',
        style: TextStyle(
          fontSize: 24,
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),
      ),
      centerTitle: true,
      elevation: 0,
      leading: IconButton(
        icon: const Icon(Icons.arrow_back, color: Colors.white),
        onPressed: () => Navigator.pop(context),
      ),
    );
  }

  Widget _buildBody() {
    return Container(
      color: const Color(0xFF131B31),
      child:
          _isLoading
              ? const Center(child: CircularProgressIndicator())
              : _buildNewsList(),
    );
  }

  Widget _buildNewsList() {
    if (_newsList.isEmpty) {
      return const Center(
        child: Text("Belum ada berita.", style: TextStyle(color: Colors.white)),
      );
    }

    return ListView.builder(
      itemCount: _newsList.length,
      itemBuilder: (context, index) {
        final news = _newsList[index];
        return GestureDetector(
          onTap: () => _navigateToDetail(news),
          child: NewsItemWidget(news: news),
        );
      },
    );
  }

  void _navigateToDetail(NewsModel news) {
    Navigator.push(
      context,
      CupertinoPageRoute(builder: (context) => NewsDetailPage(news: news)),
    );
  }
}
