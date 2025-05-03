import 'package:flutter/material.dart';
import '../models/news_model.dart';

class NewsDetailPage extends StatelessWidget {
  final NewsModel news;
  const NewsDetailPage({super.key, required this.news});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 15, 34, 64),
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 15, 34, 64),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          news.title,
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(40.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (news.image.isNotEmpty)
              Container(
                height: 250,
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: NetworkImage(news.image),
                    fit: BoxFit.cover,
                  ),
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            const SizedBox(height: 16),
            Row(
              children: [
                Text(
                  news.time,
                  style: const TextStyle(color: Colors.white54, fontSize: 14),
                ),
                const Spacer(),
                Chip(
                  label: Text(
                    news.categories,
                    style: const TextStyle(
                      color: Color.fromARGB(191, 255, 255, 255),
                    ),
                  ),
                  backgroundColor: const Color.fromARGB(255, 18, 62, 138),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Text(
              news.title,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              news.description,
              style: const TextStyle(
                color: Color.fromARGB(206, 255, 250, 250),
                fontSize: 16,
              ),
            ),
            const SizedBox(height: 20),
            Text(
              news.content,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 16,
                height: 1.5,
              ),
            ),
            const SizedBox(height: 25),

            Row(
              children: [
                const Text('News by ', style: TextStyle(color: Colors.white54)),
                Text(
                  news.categories,
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const Spacer(),
                TextButton(
                  onPressed: () {},
                  child: const Text(
                    'Samarinda News',
                    style: TextStyle(color: Color.fromARGB(255, 68, 170, 253)),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }
}
