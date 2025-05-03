import 'package:flutter/material.dart';
import '../models/news_model.dart';
import '../screens/news_detail_page.dart';

class NewsItemWidget extends StatelessWidget {
  final NewsModel news;  

  const NewsItemWidget({super.key, required this.news});

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => SystemMouseCursors.click, 
      child: Container(
        margin: const EdgeInsets.fromLTRB(10, 8, 10, 8),
        child: Card(
          elevation: 4,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(18),
            side: BorderSide(color: const Color.fromARGB(255, 161, 161, 161), width: 1),
          ),
          color: const Color.fromARGB(255, 17, 39, 104),
          child: InkWell(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => NewsDetailPage(news: news),
                ),
              );
            },
            child: Row(
              children: [
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(bottom: 4.0),
                          child: Text(
                            news.title,
                            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Color.fromARGB(255, 255, 255, 255)),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(bottom: 8.0),
                          child: Text(
                            news.description,
                            style: const TextStyle(fontSize: 13, color: Color.fromARGB(255, 255, 251, 251)),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        Text(
                          news.time,
                          style: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: Color.fromARGB(201, 254, 254, 254)),
                        ),
                      ],
                    ),
                  ),
                ),
                ClipRRect(
                  borderRadius: BorderRadius.only(
                    topRight: Radius.circular(18),
                    bottomRight: Radius.circular(18),
                  ),
                  child: Image.network(
                    news.image,
                    width: 180,
                    height: 180,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) {
                      return Container(
                        width: 180,
                        height: 180,
                        color: const Color.fromARGB(255, 255, 255, 255),
                        child: const Center(child: Text('Image loading failed')),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
