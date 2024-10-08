import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../repository/image_repository_provider.dart';
import 'image_details_screen.dart';
import 'settings_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late Future<void> _fetchImagesFuture;
  final scrollController = ScrollController();

  void _scrollListener() {
    if (Provider.of<ImageRepositoryProvider>(context, listen: false)
        .isFetchingMore) return;
    if (scrollController.position.pixels ==
        scrollController.position.maxScrollExtent) {
      _fetchMoreImages();
    }
  }

  void _fetchMoreImages() {
    final imageRepository =
        Provider.of<ImageRepositoryProvider>(context, listen: false);

    if (!imageRepository.isFetchingMore) {
      imageRepository.isFetchingMore = true;

      imageRepository.fetchImages().whenComplete(() {
        imageRepository.isFetchingMore = false;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    scrollController.addListener(_scrollListener);
    final imageRepository =
        Provider.of<ImageRepositoryProvider>(context, listen: false);
    _fetchImagesFuture = imageRepository.fetchImages();
  }

  @override
  void dispose() {
    scrollController.removeListener(_scrollListener);
    scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    int columns;
    if (screenWidth >= 1024) {
      columns = 4;
    } else if (screenWidth >= 800) {
      columns = 3;
    } else if (screenWidth >= 500) {
      columns = 2;
    } else {
      columns = 1;
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Images',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 23),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => const SettingsScreen(),
                ),
              );
            },
          ),
        ],
      ),
      body: Consumer<ImageRepositoryProvider>(
        builder: (context, imageRepository, child) => Column(
          children: [
            Expanded(
              child: FutureBuilder(
                future: _fetchImagesFuture,
                builder: (context, snapshot) {
                  if (imageRepository.isLoading &&
                      !imageRepository.isFetchingMore) {
                    return const Center(child: CircularProgressIndicator());
                  }

                  if (snapshot.connectionState == ConnectionState.done &&
                      snapshot.hasError) {
                    return Center(child: Text('Error: ${snapshot.error}'));
                  }

                  return GridView.builder(
                    controller: scrollController,
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: columns,
                      childAspectRatio: 0.7,
                    ),
                    itemCount: imageRepository.imageList.length,
                    itemBuilder: (context, index) {
                      final image = imageRepository.imageList[index];
                      return Container(
                        margin: const EdgeInsets.all(5),
                        child: InkWell(
                          onTap: () => Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (_) =>
                                      ImageDetailsScreen(image: image))),
                          child: Column(
                            children: [
                              Expanded(
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(10),
                                  child: Hero(
                                    tag: image
                                        .id, // Use a unique tag for each image
                                    child: Image.network(
                                      image.webformatURL,
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                ),
                              ),
                              Row(
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Icon(
                                          CupertinoIcons.heart_fill,
                                          color: Colors.red,
                                        ),
                                        SizedBox(
                                          width: 3,
                                        ),
                                        Text(
                                          image.likes.toString(),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Text.rich(
                                    TextSpan(
                                      children: [
                                        const TextSpan(
                                          text: 'Views: ',
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold),
                                        ),
                                        TextSpan(text: image.views.toString()),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  );
                },
              ),
            ),
            if (imageRepository.isFetchingMore)
              Container(
                margin: const EdgeInsets.all(8),
                width: 20,
                height: 20,
                child: const CircularProgressIndicator(
                  color: Colors.blue,
                  strokeWidth: 2,
                ),
              ),
          ],
        ),
      ),
    );
  }
}
