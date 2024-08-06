import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:news_app/utils/constants.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  bool isListView = true;

  void toggleView() {
    setState(() {
      isListView = !isListView;
    });
  }

  final List<Map<String, String>> articles = [
    {
      'image': 'assets/images/splash_pic.jpg',
      'headline': 'Breaking News: Flutter 3.0 Released!',
      'source': 'TechCrunch',
    },
    {
      'image': 'assets/images/splash_pic.jpg',
      'headline': 'New Features in Flutter 3.0',
      'source': 'The Verge',
    },
    // Add more articles here
  ];
  final List<String> newsCategories = [
    'Technology',
    'Sports',
    'Politics',
    'Entertainment',
    'Science',
    'Health',
    'Business',
    'World',
    'Lifestyle',
    'Travel',
  ];

  final TextEditingController _searchController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "NEWS",
          style: TextStyle(
              fontSize: 18, fontWeight: FontWeight.w900, color: colorblue),
        ),
        actions: [
          IconButton(
            onPressed: toggleView,
            icon: const Icon(Icons.notifications),
          )
        ],
        leading: IconButton(
          onPressed: toggleView,
          icon: isListView
              ? const Icon(Icons.grid_on)
              : const Icon(Icons.list_outlined),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextField(
              controller: _searchController,
              decoration: const InputDecoration(
                suffixIcon: Icon(
                  CupertinoIcons.arrow_turn_down_right,
                ),
                suffixIconColor: colorblue,
                prefixIconColor: Color.fromARGB(255, 179, 164, 30),
                prefixIcon: Icon(Icons.search),
                labelText: "Search",
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(15.0)),
                ),
              ),
            ),
            SizedBox(
              height: height * 0.04,
            ),
            const Text(
              "Latest News",
              style: TextStyle(
                color: colorblue,
                fontWeight: FontWeight.w800,
                fontSize: 15,
              ),
            ),
            SizedBox(
              height: height * 0.02,
            ),
            Container(
              height: height * 0.35, // Adjust height according to your design
              child: GridView.builder(
                scrollDirection: Axis.horizontal,
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 1,
                  childAspectRatio: height *
                      0.39 /
                      width, // Adjust aspect ratio to display the whole card
                  crossAxisSpacing: 8.0,
                  mainAxisSpacing: 8.0,
                ),
                itemCount: articles.length,
                itemBuilder: (context, index) {
                  final article = articles[index];
                  return GestureDetector(
                    onTap: () {
                      // Add your onTap functionality here
                    },
                    child: Card(
                      elevation: 5.0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Expanded(
                            child: ClipRRect(
                              borderRadius: const BorderRadius.vertical(
                                top: Radius.circular(10.0),
                              ),
                              child: Image.asset(
                                article['image']!,
                                fit: BoxFit.cover,
                                width: double.infinity,
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Text(
                                  article['headline']!,
                                  style: const TextStyle(
                                    fontSize: 16.0,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const SizedBox(height: 4.0),
                                Text(
                                  'Source: ${article['source']}',
                                  style: const TextStyle(
                                    fontSize: 12.0,
                                    color: Colors.grey,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
            SizedBox(
              height: height * 0.03,
            ),
            Container(
              height: height * 0.05,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: newsCategories.length,
                itemBuilder: (context, index) {
                  return GestureDetector(
                    onTap: () {
                      // Handle category selection
                      print('Selected category: ${newsCategories[index]}');
                    },
                    child: Container(
                      margin: const EdgeInsets.symmetric(horizontal: 8.0),
                      padding: const EdgeInsets.symmetric(
                          vertical: 10.0, horizontal: 15.0),
                      decoration: BoxDecoration(
                        color: colorblue,
                        borderRadius: BorderRadius.circular(20.0),
                      ),
                      child: Center(
                        child: Text(
                          newsCategories[index],
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 13.0,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
            SizedBox(
              height: height * 0.02,
            ),
          ],
        ),
      ),
    );
  }
}
