import 'package:dio/dio.dart';
import 'package:ecommerce_app/core/utils/exceptions.dart';
import 'package:ecommerce_app/core/utils/handleExceptions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get/get.dart';
// import 'package:get/get.dart';

class DioClient {
  static final DioClient _instance = DioClient._internal();
  late Dio _dio;
  final FlutterSecureStorage _storage = const FlutterSecureStorage();
  var excludePaths = ["/auth/refresh", '/auth/login', "/auth/register"];
  factory DioClient() {
    return _instance;
  }

  DioClient._internal() {
    _dio = Dio();
    _dio.options.baseUrl = dotenv.env["BASE_URL"] ?? "http://localhost:3000";
    _dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) async {
          print(options.path);
          String? accessToken = await getAccessToken();
          options.headers['Authorization'] = 'Bearer $accessToken';

          return handler.next(options);
        },
        onError: (DioException e, handler) async {
          try {
            if (e.response?.statusCode == 401 &&
                !(excludePaths.contains(e.requestOptions.path))) {
              String newAccessToken = await refreshToken();

              e.requestOptions.headers['Authorization'] =
                  'Bearer $newAccessToken';
              return handler.resolve(await _dio.fetch(e.requestOptions));
            } else {
              throw e;
            }
          } on AuthException catch (e) {
            Get.offNamed("/error", arguments: {
              "message": "An Error has occured: ${e.toString()}"
            });
            Future.delayed(
                Duration(seconds: 2), () => Get.offAllNamed("/login"));
          } on DioException catch (e) {
            if (e.requestOptions.path == "/auth/refresh" &&
                (await getRefreshToken() != null)) {
              Get.offAllNamed("/login",
                  arguments: {"message": "Session Expired. Please login."});
              return;
            } else {
              handler.reject(e);
            }
          } catch (e) {
            Get.offNamed("/error", arguments: {
              "message": "An Error has occured. Please Login again."
            });
            Future.delayed(
                const Duration(seconds: 2), () => Get.offAllNamed("/login"));
          }
        },
      ),
    );
  }

  Future<String?> getAccessToken() async =>
      await _storage.read(key: 'accessToken');

  Future<String?> getRefreshToken() async =>
      await _storage.read(key: "refreshToken");
  Future<String?> getRole() async => await _storage.read(key: "role");

  Future<String> refreshToken() async {
    try {
      var res = await dio.post("/auth/refresh", data: {
        "refreshToken": await getRefreshToken(),
        "accessToken": await getAccessToken()
      });
      if (res.statusCode == 200) {
        print(
            "refreshed successfully. returning new accesstoken... access:${res.data["accessToken"]}");

        await saveTokens(res.data["accessToken"], res.data["refreshToken"],
            res.data["role"]);
      }
      var newAccesstoken = await getAccessToken();
      if (newAccesstoken != null) {
        return newAccesstoken;
      } else {
        throw AuthException(message: "Refresh failed.");
      }
    } on AuthException catch (e) {
      rethrow;
    } on DioException catch (e) {
      rethrow;
    } catch (e) {
      throw AuthException(message: "Refresh failed for unkown reason.");
    }
  }

  Future<void> saveTokens(
      String? accessToken, String? refreshToken, String? role) async {
    print("role: $role");
    try {
      if (accessToken != null && refreshToken != null && role != null) {
        await _storage.write(key: 'accessToken', value: accessToken);
        await _storage.write(key: 'refreshToken', value: refreshToken);
        await _storage.write(key: 'role', value: role);
      }

      if (accessToken == null || refreshToken == null) {
        throw AuthException(message: "Saving Tokens Failed.");
      }
      if (role == null) {
        throw AuthException(message: "Role not Provided.");
      }
    } on AuthException catch (e) {
      rethrow;
    } catch (e) {
      throw AuthException(message: "Saving Tokens Failed.");
    }
  }

  Future<void> deleteTokens() async {
    try {
      _storage.delete(key: "accessToken");
      _storage.delete(key: "refreshToken");
      _storage.delete(key: "role");
    } catch (e) {
      throw AuthException(message: 'Logout failed. Try later.');
    }
  }

  Future<void> saveData(String? key, String? value) async {
    try {
      if (key != null && value != null) {
        await _storage.write(key: key, value: value);
      }
    } catch (e) {
      Get.snackbar("Failed", "couldn't save data");
    }
  }

  Future<String?> getData(String? key) async {
    try {
      if (key != null) {
        return await _storage.read(key: key);
      }
    } catch (e) {
      Get.snackbar("Failed", "couldn't get data");
    }
  }

  Dio get dio => _dio;
}
