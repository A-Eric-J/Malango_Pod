import 'dart:developer';
import 'package:malango_pod/const_values/assets.dart';
import 'package:malango_pod/models/server_response.dart';
import 'package:malango_pod/services/cookie_service.dart';
import 'package:dio/dio.dart';


/// [WebService] is a service for every request to the server
/// and we use Dio for interacting with network.

class WebService {
  CookieService cookieService;

  WebService({this.cookieService});

  WebService setDependencies(
    CookieService cookieService,
  ) {
    this.cookieService = cookieService;
    log('Web service updated');
    return this;
  }

  final dio = Dio();

  Future<ServerResponse> getFunction(String url,
      {var body, bool withUserAgent = false}) async {
    log('requesting data from $url');
    Response response;
    try {

      var headers =
      await cookieService.header(withContentType: false, withUserAgent: withUserAgent);
      dio.options.sendTimeout = 50000;
      dio.options.connectTimeout = 50000;
      dio.options.receiveTimeout = 50000;


      response = await dio.get(url,
          options: Options(headers: headers, followRedirects: false));
    } on DioError catch (errorMessage) {
      response = errorMessage.response;
      log('request failed in get method');
      showError(errorMessage);
    }
    return ServerResponse(response, debugMode: debugMode,hasXmlResponse: withUserAgent);
  }

  void showError(DioError error) {
    switch (error.type) {
      case DioErrorType.connectTimeout:
        log('Error with connectTimeout');
        break;
      case DioErrorType.sendTimeout:
        log('Error with sendTimeout');
        break;
      case DioErrorType.receiveTimeout:
        log('Error with receiveTimeout');
        break;
      case DioErrorType.other:
        log('Connection timeout');
        break;
      case DioErrorType.response:
        log('Response error with ${error.response?.statusCode} status code');
        break;
      case DioErrorType.cancel:
        log('Request cancelled');
        break;
    }
  }

}
