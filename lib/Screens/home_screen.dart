import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:news_app/Screens/article_screen.dart';
import 'package:news_app/models/articles.dart';
import 'package:news_app/utils/constants.dart';
import 'package:news_app/services/fetch_articles_services.dart';
import 'package:timeago/timeago.dart' as timeago;
import 'package:flutter_spinkit/flutter_spinkit.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  bool isListView = true;

  double _headerHeight = 340;
  bool _isExpanded = false;
  final ScrollController _scrollController = ScrollController();

  void toggleView() {
    setState(() {
      isListView = !isListView;
    });
  }

  void _onScroll() {
    if (_scrollController.position.userScrollDirection ==
            ScrollDirection.reverse &&
        !_isExpanded) {
      // Scrolling up
      setState(() {
        _headerHeight = 0.0;
        _isExpanded = true;
      });
    } else if (_scrollController.position.userScrollDirection ==
            ScrollDirection.forward &&
        _isExpanded) {
      // Scrolling down
      setState(() {
        _headerHeight = MediaQuery.of(context).size.height * 0.32;
        _isExpanded = false;
      });
    }
  }

  List<Articles> articles = [];
  bool isLoading = true;
  String error = "";
  final NewsService newsService = NewsService();

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

  void loadArticles() async {
    // Simulate a delay for loading
    await Future.delayed(Duration(seconds: 3));

    try {
      final fetchArticles = await newsService.fetchArticles();
      setState(() {
        articles = fetchArticles;
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        isLoading = false;
        error = "Error Fetching Articles $e";
      });
    }
  }

  void _navigateToArticleDetails(Articles article) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ArticleDetailsPage(article: article),
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
    loadArticles();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _searchController.dispose();
    super.dispose();
  }

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
      body: isLoading
          ? const Center(
              child: SpinKitCircle(
                color: colorblue,
                size: 50.0,
              ),
            )
          : Padding(
              padding:
                  const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
              child: Stack(
                children: [
                  Column(
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
                            borderRadius:
                                BorderRadius.all(Radius.circular(15.0)),
                          ),
                        ),
                      ),
                      SizedBox(
                        height: height * 0.02,
                      ),
                      AnimatedContainer(
                        duration: Duration(milliseconds: 300),
                        height: _headerHeight,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Text(
                              "Latest News",
                              style: TextStyle(
                                color: colorblue,
                                fontWeight: FontWeight.w800,
                                fontSize: 15,
                              ),
                            ),
                            SizedBox(
                              height: height * 0.015,
                            ),
                            Container(
                              height: height *
                                  0.3, // Adjust height according to your design
                              child: GridView.builder(
                                scrollDirection: Axis.horizontal,
                                gridDelegate:
                                    SliverGridDelegateWithFixedCrossAxisCount(
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
                                      _navigateToArticleDetails(article);
                                    },
                                    child: Card(
                                      elevation: 5.0,
                                      shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(10.0),
                                      ),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: <Widget>[
                                          Expanded(
                                            child: ClipRRect(
                                              borderRadius:
                                                  const BorderRadius.vertical(
                                                top: Radius.circular(10.0),
                                              ),
                                              child: Image.network(
                                                article.urlToImage ?? '',
                                                fit: BoxFit.cover,
                                                width: double.infinity,
                                              ),
                                            ),
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: <Widget>[
                                                Text(
                                                  article.title ?? 'No Title',
                                                  style: const TextStyle(
                                                    fontSize: 14.0,
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                                ),
                                                SizedBox(
                                                    height: height * 0.0044),
                                                Text(
                                                  article.source?.name ??
                                                      'Unknown Source',
                                                  style: const TextStyle(
                                                      fontSize: 13.0,
                                                      color: Color.fromARGB(
                                                          255, 111, 111, 111),
                                                      fontWeight:
                                                          FontWeight.bold),
                                                ),
                                                const SizedBox(height: 4.0),
                                                Text(
                                                  timeago.format(DateTime.parse(
                                                    article.publishedAt!,
                                                  )),
                                                  style: const TextStyle(
                                                      fontSize: 12.0,
                                                      color: colorOrange,
                                                      fontWeight:
                                                          FontWeight.bold),
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
                              height: height * 0.015,
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
                                      print(
                                          'Selected category: ${newsCategories[index]}');
                                    },
                                    child: Container(
                                      margin: const EdgeInsets.symmetric(
                                          horizontal: 8.0),
                                      padding: const EdgeInsets.symmetric(
                                          vertical: 10.0, horizontal: 15.0),
                                      decoration: BoxDecoration(
                                        color: colorblue,
                                        borderRadius:
                                            BorderRadius.circular(20.0),
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
                          ],
                        ),
                      ),
                      SizedBox(
                        height: height * 0.015,
                      ),
                      const Text(
                        "More News",
                        style: TextStyle(
                          color: colorblue,
                          fontWeight: FontWeight.w800,
                          fontSize: 15,
                        ),
                      ),
                      SizedBox(
                        height: height * 0.015,
                      ),
                      Expanded(
                        child: ListView.builder(
                          controller: _scrollController,
                          itemCount: articles.length,
                          itemBuilder: (context, index) {
                            final article = articles[index];
                            return GestureDetector(
                              onTap: () => _navigateToArticleDetails(article),
                              child: ListTile(
                                leading: SizedBox(
                                    width: 80.0, // Fixed width for the image
                                    height: 100.0,
                                    child: Image.network(
                                        article.urlToImage ?? '')),
                                title: Text(
                                  article.title!,
                                  style: const TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.bold),
                                ),
                                subtitle: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      article.source!.name!,
                                      style: const TextStyle(
                                        fontSize: 12,
                                      ),
                                    ),
                                    Text(
                                      timeago.format(DateTime.parse(
                                        article.publishedAt!,
                                      )),
                                      style: const TextStyle(fontSize: 12),
                                    ),
                                  ],
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
    );
  }
}
