import 'package:dio/dio.dart';
import 'package:ecommerce_app/core/utils/exceptions.dart';
import 'package:ecommerce_app/core/utils/handleExceptions.dart';
import 'package:ecommerce_app/data/datasources/api_client.dart';
import 'package:ecommerce_app/domain/entities/edit_user.dart';

class EditUserDataSource{
  DioClient dio = DioClient();
  
    Future<bool> editUser(EditUserModel user) async {
    try {
      var res = await dio.dio.patch("/user/update", data: user.toJson());
      if (res.statusCode == 200) {
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
      throw AuthException(message: "Editing user failed. try again.");
    }
    return false;
  }
}

class GetUserDataSource{
  DioClient dio = DioClient();
  Future<GetUserModel> getUserDetails() async {
    try {
      var res = await dio.dio.get("/user");
      if (res.statusCode == 200) {
        GetUserModel user = GetUserModel();
        // print(res.data);
        return user.fromJson(res.data!);
      }
    } on DioException catch (e) {
      handledioExceptions(e);
    }
    return GetUserModel();
  }
}