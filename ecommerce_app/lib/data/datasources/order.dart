import 'package:dio/dio.dart';
import 'package:ecommerce_app/core/utils/handleExceptions.dart';
import 'package:ecommerce_app/data/datasources/api_client.dart';
import 'package:ecommerce_app/domain/entities/order.dart';

class OrderDataSource {
  DioClient dio = DioClient();
  Future<List<Order>> fetchOrders() async {
    try {
      print("order here?");
      var res = await dio.dio.get("/order");
      if (res.statusCode == 200) {
        print(res);
        return res.data["data"]
                ?.map((elem) {
                  return Order.fromJson(elem);
                })
                .toList()
                .cast<Order>() ??
            [];
      }
    } on DioException catch (e) {
      print("Dioexception: ${e.message}");
      handledioExceptions(e);
    } catch (e) {
      print("someother exception: $e");

      rethrow;
    }
    return [];
  }

}
