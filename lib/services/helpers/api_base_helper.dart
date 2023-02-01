import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:flutter_catalog/libraries/url_data.dart' as URL;

import 'exceptions.dart';

abstract class ApiBase {
  late String serverUrl;
  late Map<String, String> headers;
}

class ApiService extends ApiBase {
  /// Singleton constructor
  static final ApiService _instance = ApiService._internal();

  factory ApiService(String url, {String? token, String? optionalServer}) {

    _instance.serverUrl = URL.MOCK_SERVER_URL + url;
    /// For the body json
    _instance.headers = {HttpHeaders.contentTypeHeader: 'application/json'};

    // if (token != null) {
    //   /// Add token if existing
    //   _instance.headers[HttpHeaders.authorizationHeader] = "JWT " + token;
    // }

    return _instance;
  }

  ApiService._internal();

  ///*************** apiGetRequest ***************
  Future<dynamic> apiGetRequest() async {
    var responseJson;
    print('SERVER URL =====> $serverUrl');

    try {
      final response = (headers == null)
          ? await http.get(Uri.parse(serverUrl))
          : await http.get(Uri.parse(serverUrl), headers: headers);
      responseJson = _returnResponse(response);
    } on SocketException {
      throw FetchDataException('Sin conexión a internet');
    }
    return responseJson;
  }

  ///*************** _returnResponse ***************
  dynamic _returnResponse(http.Response response) {
    switch (response.statusCode) {
      case 200:
      case 201: // For the POST

        print("##API: Body -> ${response.body}");
        print("##API: Status code -> ${response.statusCode}");

        /// Content-Type http header sent by the server is missing the
        /// encoding tag. This causes the Dart http client to decode the
        /// body as Latin-1 instead of utf-8.
        final responseJson = jsonDecode(utf8.decode(response.bodyBytes));
        return responseJson;
      case 204:
        throw NotContentException(utf8.decode(response.bodyBytes));
      case 400:
        throw BadRequestException(utf8.decode(response.bodyBytes));
      case 401:
      case 403:
        throw UnauthorizedException(utf8.decode(response.bodyBytes));
      case 404:
        throw NotFoundException(utf8.decode(response.bodyBytes));

      case 500:
      case 502:
        throw FetchDataException('${response.statusCode}');
    }
  }
}
