import 'dart:convert';
import 'dart:developer';
import 'package:flutter/foundation.dart';
import 'package:malango_pod/enums/response_status.dart';
import 'package:dio/dio.dart';

/// This class is the response models of  all requests to server
class ServerResponse {
  /// responseStatus to handle the request response
  ResponseStatus responseStatus = ResponseStatus.none;

  /// a boolean to show that the request was successful
  var success = false;

  /// response body
  Map<String, dynamic> body;

  /// for rss feed that the response is xml we need rawResponse
  String rawResponse;

  /// we need to know that the response is xml or not for parsing it in another way
  bool hasXmlResponse;

  /// response status code
  var statusCode = 0;

  /// response message
  String message;
  final bool debugMode;

  ServerResponse.fake(
      {this.body,
      this.success = true,
      this.statusCode = 200,
      this.hasXmlResponse = false,
      this.message,
      this.debugMode = true});

  ServerResponse(Response response,
      {@required this.debugMode, this.hasXmlResponse = false}) {
    if (response != null) {
      if (response.statusCode >= 200 && response.statusCode <= 500) {
        rawResponse = response.data;
        if (!hasXmlResponse) {
          body = json.decode(response.data);
          statusCode = response.statusCode;
          if (body['message'] != null) {
            message = body['message'];
          }
        }
        switch (statusCode) {
          case 200:
            responseStatus = ResponseStatus.success;
            success = true;
            break;
          case 201:
            responseStatus = ResponseStatus.created;
            success = true;
            break;
          case 401:
            responseStatus = ResponseStatus.unauthorized;
            success = false;
            break;
          case 403:
            responseStatus = ResponseStatus.forbidden;
            success = false;
            break;
          case 409:
            responseStatus = ResponseStatus.conflict;
            success = false;
            break;
          case 500:
            responseStatus = ResponseStatus.internalServerError;
            success = false;
            break;
          default:
            responseStatus = ResponseStatus.failed;
            success = false;
        }
      } else {
        /// Server did not understand our request
        responseStatus = ResponseStatus.failed;
        statusCode = response.statusCode;
        log('statusCode: $statusCode');
        if (response.data != null) {
          body = json.decode(response.data);
        }
      }

      if (debugMode) {
        log('Status code: $statusCode for request: ${response.requestOptions.uri}');
      }
    }
  }
}
