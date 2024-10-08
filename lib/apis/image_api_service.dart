import 'package:dio/dio.dart';
import '../models/my_image.dart';
import '../secrets/api_keys.dart';

class ImageApiService {
  static final Dio _dio = Dio(BaseOptions(baseUrl: 'https://pixabay.com/api/'));

  static Future<List<MyImage>> fetchImages(int page) async {
    final response = await _dio.get('', queryParameters: {
      'key': APIKEYS.IMAGEAPIKEY,  // Use 'key' instead of 'api'
      'page': page,
      'per_page': 20,  // You can specify the number of images per page
    });

    if (response.statusCode == 200) {
      return List<MyImage>.from(response.data['hits'].map((x) => MyImage.fromJson(x)));
    } else {
      throw Exception('Failed to load images: ${response.statusCode}');
    }
  }
}
