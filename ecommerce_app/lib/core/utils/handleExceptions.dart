import 'package:dio/dio.dart';
import 'package:ecommerce_app/core/utils/exceptions.dart';
import 'package:get/get.dart';

void handledioExceptions(DioException e) {
  if (e.type == DioExceptionType.connectionError) {
    throw NetworkException(message: "Connection Error. Try again later");
  } else if (e.type == DioExceptionType.connectionTimeout) {
    throw NetworkException(message: "Connection TimeOut. Try again later");
  } else if (e.type == DioExceptionType.sendTimeout) {
    throw NetworkException(message: "Request TimeOut. Try again later");
  } else if (e.type == DioExceptionType.receiveTimeout) {
    throw NetworkException(message: "Response TimeOut. Try again later");
  } else if (e.type == DioExceptionType.cancel) {
    throw CustomeException(message: "Request canceled by user");
  } else if (e.type == DioExceptionType.badResponse) {
    var message;
    if (e.response?.data.runtimeType == String) {
      message = e.response?.data;
    } else if (e.response?.data["message"] != null) {
      message = e.response?.data["message"];
    } else if (e.response?.data["errors"] != null) {
      message = e.response?.data["errors"].toString();
    } else {
      message = e.response?.data.toString();
    }
    throw BadResponseException(
        message: message ?? "Unknown error has occured",
        statusCode: e.response?.statusCode,
        path: e.requestOptions.path);
  } else {
    throw CustomeException(message: "Something went wrong");
  }
}
