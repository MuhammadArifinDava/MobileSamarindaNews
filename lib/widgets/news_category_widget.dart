import 'package:flutter/material.dart';

class NewsCategoryWidget extends StatefulWidget {
  final Function(String) onCategoryChanged; 

  const NewsCategoryWidget({super.key, required this.onCategoryChanged});

  @override
  _NewsCategoryWidgetState createState() => _NewsCategoryWidgetState();
}

class _NewsCategoryWidgetState extends State<NewsCategoryWidget> with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 7, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          TabBar(
            controller: _tabController,
            isScrollable: true,
            indicator: BoxDecoration(),
            labelColor: const Color.fromARGB(255, 70, 169, 250),
            unselectedLabelColor: const Color.fromARGB(255, 255, 255, 255),
            onTap: (index) {
        
              final categories = [
                'Semua Berita', 'Kriminal', 'Berita', 'Olahraga', 'Kesehatan', 'Wisata', 'Bisnis'
              ];
              widget.onCategoryChanged(categories[index]);
            },
            tabs: const [
              Tab(child: Align(alignment: Alignment.centerLeft, child: Text('Semua Berita'))),
              Tab(child: Align(alignment: Alignment.centerLeft, child: Text('Kriminal'))),
              Tab(child: Align(alignment: Alignment.centerLeft, child: Text('Berita'))),
              Tab(child: Align(alignment: Alignment.centerLeft, child: Text('Olahraga'))),
              Tab(child: Align(alignment: Alignment.centerLeft, child: Text('Kesehatan'))),
              Tab(child: Align(alignment: Alignment.centerLeft, child: Text('Wisata'))),
              Tab(child: Align(alignment: Alignment.centerLeft, child: Text('Bisnis'))),
            ],
          ),
        ],
      ),
    );
  }
}