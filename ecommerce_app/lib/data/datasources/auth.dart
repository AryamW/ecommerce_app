// import 'dart:js_interop';

import 'package:dio/dio.dart';
import 'package:ecommerce_app/core/utils/exceptions.dart';
import 'package:ecommerce_app/core/utils/handleExceptions.dart';
import 'package:ecommerce_app/domain/entities/auth.dart';
import 'package:ecommerce_app/data/datasources/api_client.dart';
import 'package:ecommerce_app/domain/entities/product.dart';
import 'package:get/get.dart';

class AuthDataSource {
  DioClient dio = DioClient();
  Future<bool> login(LoginModel user) async {
    try {
      var res = await dio.dio.post("/auth/login", data: user.toJson());
      print("statuscode : ${res.statusCode}");
      if (res.statusCode == 200) {
        // save access and refresh token to the storage

        await dio.saveTokens(res.data["accessToken"], res.data["refreshToken"]);
        return true;
      }
    } on AuthException catch (e) {
      throw AuthException(message: "Login Failed. ${e.toString()}");
    } on DioException catch (e) {
      handledioExceptions(e);
    } catch (e) {
      throw AuthException(message: "Login Failed. Try again");
    }
    return false;
  }

  Future<bool> register(RegisterModel user) async {
    try {
      var res = await dio.dio.post("/auth/register", data: user.toJson());
      if (res.statusCode == 201) {
        // log in
        // return await login(
        //     LoginModel(email: user.email, password: user.password));
        await dio.saveTokens(res.data["accessToken"], res.data["refreshToken"]);
        return true;
      }
    } on AuthException catch (e) {
      rethrow;
    } on DioException catch (e) {
      // handle dio exceptions.
      handledioExceptions(e);
    } catch (e) {
      throw AuthException(message: "Registeration failed. try again.");
    }
    return false;
  }

  Future<bool> refresh() async {
    try {} catch (e) {}
    return false;
  }

  Future<bool> logout() async {
    try {
      await dio.deleteTokens();
      return true;
    } catch (e) {
      return false;
    }
  }
}


class ReviewDataSource {
  DioClient dio = DioClient();

  Future<bool> send(ReviewModel review) async {
    try {
      var res = await dio.dio.post("/review", data: review.toJson());
      print("wer a e re77");
      if (res.statusCode == 200) {
        return true;
      }
    } on DioException catch (e) {
      print("in review source: $e");
      if (e.type == DioExceptionType.badResponse) {
        Get.toNamed("/error",
            arguments: {"message": "Invalid request. Try again."});
      }
    }
    return false;
  }
}

class PDetailDataSource {
  DioClient dio = DioClient();

  Future<PDetailModel?> fetch(int id) async {
    try {
      var res = await dio.dio.get("/products/$id");
      print(res);
      if (res.statusCode == 200) {
        return PDetailModel.fromJson(res.data);
      }
    } on DioException catch (e) {
      handleDioExceptions(e);
      var err = "";
      if (e.type == DioExceptionType.badResponse) {
        if (e.response?.statusCode == 404) {
          err = "Product Not found!";
        } else if (e.response?.statusCode == 400) {
          err = "Invalid Request";
        } else {
          err = "Something went wrong";
        }
      }
      throw CustomeException(message: err);
    }
    return null;
  }
}
