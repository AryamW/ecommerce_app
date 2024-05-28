import 'package:dio/dio.dart';
import 'package:ecommerce_app/core/utils/handleExceptions.dart';
import 'package:ecommerce_app/data/datasources/api_client.dart';
import 'package:ecommerce_app/domain/entities/address.dart';

class AddressDataSource{
  DioClient dio = DioClient();
  Future<List<AddressModel>> getShippingAddress() async {
    try {
      var res = await dio.dio.get("/address/shipping");
      if (res.statusCode == 200) {
        AddressModel address = AddressModel();
        List<dynamic> result = res.data['data'];
        // var s = result.map((e) => address.fromJson(e)).toList();
        // print(s[0].street);
        // return address.fromJson(res.data!);
        return result.map((e) => address.fromJson(e)).toList();
      }
    } on DioException catch (e) {
      handledioExceptions(e);
    }
    return [];
  }

  Future<bool> postShippingAddress({required AddressModel address}) async {
    try {
      var res = await dio.dio.post("/address/shipping", data: address.toJson());
      if (res.statusCode == 200) {
        bool result = res.data['success'];
        return result;
      }
    } on DioException catch (e) {
      handledioExceptions(e);
    }
    return false;
  }
  Future<bool> putShippingAddress({required AddressModel address}) async {
    try {
      var res = await dio.dio.put("/address/shipping/update", data: address.toJson());
      if (res.statusCode == 200) {
        bool result = res.data['success'];
       return result;
      }
    } on DioException catch (e) {
      handledioExceptions(e);
    }
    return false;
  }


  Future<bool> deleteShippingAddress({required int addressId}) async {
    try {
      var res = await dio.dio.delete("/address/shipping/remove/$addressId");
      if (res.statusCode == 200) {
        bool result = res.data['success'];
       return result;
      }
    } on DioException catch (e) {
      handledioExceptions(e);
    }
    return false;
  }


  Future<List<AddressModel>> getBillingAddress() async {
    try {
      var res = await dio.dio.get("/address/billing");
      if (res.statusCode == 200) {
        AddressModel address = AddressModel();
        List<dynamic> result = res.data['data'];
        
        // print(res.data);
        // return address.fromJson(res.data!);
        return result.map((e) => address.fromJson(e)).toList();
      }
    } on DioException catch (e) {
      handledioExceptions(e);
    }
    return [];
  }
  Future<bool> postBillingAddress({required AddressModel address}) async {
    try {
      var res = await dio.dio.post("/address/billing", data: address.toJson());
      if (res.statusCode == 200) {
        bool result = res.data['success'];
        return result;
      }
    } on DioException catch (e) {
      handledioExceptions(e);
    }
    return false;
  }
  Future<bool> putBillingAddress({required AddressModel address}) async {
    try {
      var res = await dio.dio.put("/address/billing/update", data: address.toJson());
      if (res.statusCode == 200) {
        bool result = res.data['success'];
       return result;
      }
    } on DioException catch (e) {
      handledioExceptions(e);
    }
    return false;
  }


  Future<bool> deleteBillingAddress({required int addressId}) async {
    try {
      var res = await dio.dio.delete("/address/billing/remove/$addressId");
      if (res.statusCode == 200) {
        bool result = res.data['success'];
       return result;
      }
    } on DioException catch (e) {
      handledioExceptions(e);
    }
    return false;
  }
}