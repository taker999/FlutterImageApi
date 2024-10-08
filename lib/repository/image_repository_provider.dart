import 'dart:developer';

import 'package:flutter/foundation.dart';

import '../apis/image_api_service.dart';
import '../models/my_image.dart';

class ImageRepositoryProvider extends ChangeNotifier {
  final List<MyImage> _imageList = [];
  int _currentPage = 1;
  bool _isLoading = true;
  bool _isFetchingMore = false;

  Future<void> fetchImages() async {
    _isLoading = true;
    notifyListeners();

    try {
      final movies = await ImageApiService.fetchImages(_currentPage);
      if (movies.isNotEmpty) {
        _imageList.addAll(movies);
        _currentPage++;
      }
    } catch (e) {
      log("Error fetching images: $e");
    } finally {
      _isLoading = false;
      notifyListeners();
    }

    log('Current Page: $_currentPage');
  }

  List<MyImage> get imageList => _imageList;
  bool get isLoading => _isLoading;

  bool get isFetchingMore => _isFetchingMore;
  set isFetchingMore(bool val) {
    _isFetchingMore = val;
    notifyListeners();
  }
}
