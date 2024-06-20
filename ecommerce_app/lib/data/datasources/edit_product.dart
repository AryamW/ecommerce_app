import 'package:dio/dio.dart';
import 'package:ecommerce_app/core/utils/exceptions.dart';
import 'package:ecommerce_app/core/utils/handleExceptions.dart';
import 'package:ecommerce_app/data/datasources/api_client.dart';
import 'package:ecommerce_app/domain/entities/product.dart';

class EditProductDataSource{
  DioClient dio = DioClient();
  
    Future<bool> editProduct(AdminProduct product) async {
    try {
      FormData formData = await product.toForm();
      var res = await dio.dio.patch(
        "/product/${product.id}",
        data: formData,
      );
      if (res.statusCode == 200) {
        print(res.statusMessage);
        return true;
      }
    } on AuthException catch (e) {
      rethrow;
    } on DioException catch (e) {
      // handle dio exceptions.

        print(e.response?.data);
        print("sldgnlds: ${e.response?.data["errors"]}");

      handledioExceptions(e);
    } catch (e) {
      throw AuthException(message: "Editing Product failed. try again.");
    }
    return false;
  }


   Future<AdminProduct?> addProduct(AdminProduct product) async {
    try {
      FormData formData = await product.toForm();
      print("formdata  $formData");
      var res = await dio.dio.post(
        "/product",
        data: formData,
      );
      if (res.statusCode == 201) {
        var adminProduct  = AdminProduct.fromJson(res.data);
        print(res.statusMessage);
        return adminProduct;
      }
    } on AuthException catch (e) {
      rethrow;
    } on DioException catch (e) {
      // handle dio exceptions.

        print(e.response?.data);
        print("sldgnlds: ${e.response?.data["errors"]}");

      handledioExceptions(e);
    } catch (e) {
      throw AuthException(message: "Failed to add new Product. try again.");
    }
    return null;
  }


  Future<bool> deleteProduct(int id) async {
    try {
      var res = await dio.dio.delete(
        "/product/${id}",
      );
      if (res.statusCode == 204) {
        print(res.statusMessage);
        return true;
      }
    } on AuthException catch (e) {
      rethrow;
    } on DioException catch (e) {
      // handle dio exceptions.

        print(e.response?.data);
        print("sldgnlds: ${e.response?.data["errors"]}");

      handledioExceptions(e);
    } catch (e) {
      throw AuthException(message: "Editing Product failed. try again.");
    }
    return false;
  }


 Future<bool> deleteImage(int id, List imageList) async {
    try {
      print(imageList.join(","));
      var parameters = imageList.join(",");
      var res = await dio.dio.delete(
        "/product/${id}/Image",
        queryParameters: {
          'Images': parameters,
        },
      );
      print("dfasf${res.statusCode}");
      print("dfasf${res.requestOptions.uri}");

      if (res.statusCode == 204) {
        print(res.statusMessage);
        return true;
      }
    } on AuthException catch (e) {
      rethrow;
    } on DioException catch (e) {
      // handle dio exceptions.

        print(e.response?.data);
        print("sldgnlds: ${e.response?.data["errors"]}");

      handledioExceptions(e);
    } catch (e) {
      throw AuthException(message: "Editing Product failed. try again.");
    }
    return false;
  }

   Future<AdminProduct?> getProduct(int id) async {
    try {print("id is : $id");
      var res = await dio.dio.get(
        "/product/$id",
      );
      if (res.statusCode == 200) {
        var adminProduct  = AdminProduct.fromJson(res.data);
        print(res.statusMessage);
        return adminProduct;
      }
    } on AuthException catch (e) {
      rethrow;
    } on DioException catch (e) {
      // handle dio exceptions.

        print(e.response?.data);
        print("sldgnlds: ${e.response?.data["errors"]}");

      handledioExceptions(e);
    } catch (e) {
      throw AuthException(message: "Failed to add new Product. try again.");
    }
    return null;
  }

}


