// import 'dart:js_interop';

import 'package:dio/dio.dart';
import 'package:ecommerce_app/core/utils/exceptions.dart';
import 'package:ecommerce_app/core/utils/handleExceptions.dart';
import 'package:ecommerce_app/domain/entities/auth.dart';
import 'package:ecommerce_app/data/datasources/api_client.dart';
import 'package:ecommerce_app/domain/entities/product.dart';
import 'package:get/get.dart';
import 'dart:io' show Platform;

class AuthDataSource {
  DioClient dio = DioClient();
  Future<bool> login(LoginModel user) async {
    try {
      var res = await dio.dio.post("/auth/login", data: user.toJson());
      if (res.statusCode == 200) {
        // save access and refresh token to the storage
        await dio.saveTokens(res.data["accessToken"], res.data["refreshToken"],
            res.data["role"]);

        return true;
      }
    } on AuthException catch (e) {
      rethrow;
    } on DioException catch (e) {
      // handle dio exceptions.
      handledioExceptions(e);
    } catch (e) {
      throw AuthException(message: "Login failed. try again.");
    }
    return false;
  }

  Future<bool> register(RegisterModel user) async {
    String returnUrlScheme = "https://";
    try {
      if (Platform.isAndroid) {
        returnUrlScheme = "red://";
      }
    } catch (e) {}
    try {
      var res = await dio.dio.post("/auth/register", data: {
        "callbackUrl":
            "${returnUrlScheme}ecommerce-app-iota-taupe.vercel.app/confirmed-email",
        ...user.toJson()
      });
      if (res.statusCode == 201) {
        // log in
        // return await login(
        //     LoginModel(email: user.email, password: user.password));

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

  Future<bool> forgotPasswordEmail(String email) async {
    String returnUrlScheme = "https://";
    try {
      if (Platform.isAndroid) {
        returnUrlScheme = "red://";
      }
    } catch (e) {}
    try {
      var url =
          "/auth/forgot-password?email=$email&callbackUrl=${Uri.encodeComponent("${returnUrlScheme}ecommerce-app-iota-taupe.vercel.app/email-sent")}";
      var res = await dio.dio.post(url, data: email);
      if (res.statusCode == 200) {
        return true;
      }
    } on DioException catch (e) {
      handledioExceptions(e);
    } on AuthException catch (e) {
      rethrow;
    } catch (e) {
      throw AuthException(message: "Request failed. try again.");
    }
    return false;
  }

  Future<bool> forgotPasswordNew(Map<String, String> json) async {
    try {
      print("ehre?");
      var res = await dio.dio.post("/auth/reset-password", data: json);
      if (res.statusCode == 200) {
        print("res: $res");
        return true;
      }
    } on DioException catch (e) {
      handledioExceptions(e);
    } on AuthException catch (e) {
      rethrow;
    } catch (e) {
      throw AuthException(message: "Request failed. try again.");
    }
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

  Future<bool> send(ReviewModel review, int pid) async {
    try {
      var res =
          await dio.dio.put("/product/$pid/rating", data: review.toJson());
      if (res.statusCode == 204) {
        return true;
      }
    } on DioException catch (e) {
      handledioExceptions(e);
    }
    return false;
  }

  Future<Map<String, dynamic>> fetch(int pid) async {
    try {
      var res = await dio.dio.get("/product/$pid/review");
      var resR = await dio.dio.get("/product/$pid/rating");
      var returnee = {"reviews": [], "rating": 0};
      if (res.statusCode == 200) {
        returnee["reviews"] =
            res.data?.map((e) => ReviewModel.fromJson(e)).toList();

        // return {
        //   "reviews": res.data?.map((e) => ReviewModel.fromJson(e)).toList(),
        //   "rating": resR.data ?? 3
        // };
      }
      if (resR.statusCode == 200) {
        returnee["rating"] = resR.data ?? 3;
      }

      return returnee;
    } on DioException catch (e) {
      handledioExceptions(e);
    }
    return {};
  }

  Future<bool> delete(int pid) async {
    try {
      var res = await dio.dio.delete("/product/$pid/rating");
      if (res.statusCode == 200 || res.statusCode == 204) {
        return true;
      }
    } on DioException catch (e) {
      handledioExceptions(e);
    }
    return false;
  }
}

class PDetailDataSource {
  DioClient dio = DioClient();

  Future<PDetailModel?> fetch(int id) async {
    try {
      var res = await dio.dio.get("/product/$id");
      if (res.statusCode == 200) {
        var b = PDetailModel.fromJson(res.data);
        return b;
      }
    } on DioException catch (e) {
      handledioExceptions(e);
    }
    return null;
  }
}
