import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:wallpaper/model/image_model.dart';
import 'package:wallpaper/values/strings.dart';

class ApiProvider {
  Future<ImageModel> getImages(int count) async {
    print('${apiUrl}search?sorting=toplist');
    final response = await http.get(
        Uri.parse('${apiUrl}search?sorting='));
    if (response.statusCode == 200) {
      print(response);
      return ImageModel.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Failed to get images');
    }
  }
}
